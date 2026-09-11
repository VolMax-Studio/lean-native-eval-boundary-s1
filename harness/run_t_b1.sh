#!/usr/bin/env bash
# P10 T-B1 Acquisition and Source Proxy Harness — Frozen Pre-Registration Script
# Strictly executed POST-FREEZE; no retrieval or scan permitted before ratified freeze.
set -euo pipefail

TAG_MANIFEST="${1:-TAG_MANIFEST.json}"
OUTPUT_BASE="${2:-evidence/t_b1}"

if [ ! -f "${TAG_MANIFEST}" ]; then
  echo "Error: Tag manifest not found at ${TAG_MANIFEST}" >&2
  exit 2
fi

mkdir -p "${OUTPUT_BASE}"

python3 -c "
import json, urllib.request, hashlib, subprocess, os, sys

with open('${TAG_MANIFEST}') as f:
    tm = json.load(f)

members = tm['members']
results = []
manifest_entries = []

print(f'Starting post-freeze acquisition for {len(members)} denominator members...')

for m in members:
    tag = m['tag']
    commit = m['resolved_commit_sha']
    tag_dir = os.path.join('${OUTPUT_BASE}', tag)
    os.makedirs(tag_dir, exist_ok=True)

    basic_url = f'https://raw.githubusercontent.com/leanprover/lean4/{commit}/src/Init/Data/String/Basic.lean'
    object_url = f'https://raw.githubusercontent.com/leanprover/lean4/{commit}/src/runtime/object.cpp'

    basic_path = os.path.join(tag_dir, 'Basic.lean')
    object_path = os.path.join(tag_dir, 'object.cpp')

    # Retrieval
    req_b = urllib.request.Request(basic_url, headers={'User-Agent': 'VolMax-P10-Scan'})
    req_o = urllib.request.Request(object_url, headers={'User-Agent': 'VolMax-P10-Scan'})

    with urllib.request.urlopen(req_b) as rb:
        b_data = rb.read()
    with urllib.request.urlopen(req_o) as ro:
        o_data = ro.read()

    with open(basic_path, 'wb') as f:
        f.write(b_data)
    with open(object_path, 'wb') as f:
        f.write(o_data)

    b_sha = hashlib.sha256(b_data).hexdigest()
    o_sha = hashlib.sha256(o_data).hexdigest()

    manifest_entries.append({
        'tag': tag,
        'commit': commit,
        'basic_path': basic_path,
        'basic_bytes': len(b_data),
        'basic_sha256': b_sha,
        'object_path': object_path,
        'object_bytes': len(o_data),
        'object_sha256': o_sha
    })

    # Invoke source proxy
    proc = subprocess.run(
        [sys.executable, 'scripts/source_proxy.py', basic_path, object_path],
        capture_output=True,
        text=True
    )

    classification = proc.stdout.strip()
    results.append({
        'tag': tag,
        'commit': commit,
        'exit_code': proc.returncode,
        'classification': classification,
        'stderr': proc.stderr.strip()
    })
    print(f'[{tag}] -> {classification}')

with open(os.path.join('${OUTPUT_BASE}', 't_b1_manifest.json'), 'w') as f:
    json.dump(manifest_entries, f, indent=2)

with open(os.path.join('${OUTPUT_BASE}', 't_b1_results.json'), 'w') as f:
    json.dump(results, f, indent=2)

print('T-B1 acquisition and scan completed successfully.')
"
