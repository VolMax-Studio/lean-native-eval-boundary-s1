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
import json, urllib.request, urllib.error, hashlib, subprocess, os, sys

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
    stdout_path = os.path.join(tag_dir, 'stdout.json')
    stderr_path = os.path.join(tag_dir, 'stderr.txt')
    exit_code_path = os.path.join(tag_dir, 'exit-code.txt')

    entry = {
        'tag': tag,
        'commit': commit,
        'basic_url': basic_url,
        'object_url': object_url,
        'basic_http_status': None,
        'object_http_status': None,
        'basic_bytes': None,
        'basic_sha256': None,
        'object_bytes': None,
        'object_sha256': None,
        'retrieval_error': None
    }

    # Deterministic HTTP retrieval with typed error handling
    req_b = urllib.request.Request(basic_url, headers={'User-Agent': 'VolMax-P10-Scan'})
    req_o = urllib.request.Request(object_url, headers={'User-Agent': 'VolMax-P10-Scan'})

    b_data = None
    o_data = None
    retrieval_failed = False
    failure_type = None

    try:
        with urllib.request.urlopen(req_b, timeout=30) as rb:
            entry['basic_http_status'] = rb.getcode()
            b_data = rb.read()
    except urllib.error.HTTPError as e:
        entry['basic_http_status'] = e.code
        retrieval_failed = True
        failure_type = 'EVIDENCE_INSUFFICIENT' if e.code == 404 else 'EXTERNAL_EXECUTION_BLOCKER'
        entry['retrieval_error'] = f'Basic.lean HTTP {e.code}'
    except Exception as e:
        retrieval_failed = True
        failure_type = 'EXTERNAL_EXECUTION_BLOCKER'
        entry['retrieval_error'] = f'Basic.lean connection error: {str(e)}'

    if not retrieval_failed:
        try:
            with urllib.request.urlopen(req_o, timeout=30) as ro:
                entry['object_http_status'] = ro.getcode()
                o_data = ro.read()
        except urllib.error.HTTPError as e:
            entry['object_http_status'] = e.code
            retrieval_failed = True
            failure_type = 'EVIDENCE_INSUFFICIENT' if e.code == 404 else 'EXTERNAL_EXECUTION_BLOCKER'
            entry['retrieval_error'] = f'object.cpp HTTP {e.code}'
        except Exception as e:
            retrieval_failed = True
            failure_type = 'EXTERNAL_EXECUTION_BLOCKER'
            entry['retrieval_error'] = f'object.cpp connection error: {str(e)}'

    if retrieval_failed:
        with open(exit_code_path, 'w') as f:
            f.write('1\n')
        with open(stderr_path, 'w') as f:
            f.write(entry['retrieval_error'] + '\n')
        with open(stdout_path, 'w') as f:
            f.write('{}\n')

        manifest_entries.append(entry)
        results.append({
            'tag': tag,
            'commit': commit,
            'exit_code': 1,
            'outcome': failure_type,
            'error': entry['retrieval_error'],
            'proxy_output': None,
            'stdout_path': stdout_path,
            'stderr_path': stderr_path
        })
        print(f'[{tag}] -> {failure_type} ({entry[\"retrieval_error\"]})')
        continue

    # Write files and compute hashes
    with open(basic_path, 'wb') as f:
        f.write(b_data)
    with open(object_path, 'wb') as f:
        f.write(o_data)

    entry['basic_bytes'] = len(b_data)
    entry['basic_sha256'] = hashlib.sha256(b_data).hexdigest()
    entry['object_bytes'] = len(o_data)
    entry['object_sha256'] = hashlib.sha256(o_data).hexdigest()
    manifest_entries.append(entry)

    # Invoke source proxy
    proc = subprocess.run(
        [sys.executable, 'scripts/source_proxy.py', basic_path, object_path],
        capture_output=True,
        text=True
    )

    with open(stdout_path, 'w') as f:
        f.write(proc.stdout)
    with open(stderr_path, 'w') as f:
        f.write(proc.stderr)
    with open(exit_code_path, 'w') as f:
        f.write(f'{proc.returncode}\n')

    parsed_outcome = 'EVIDENCE_INSUFFICIENT'
    proxy_payload = None
    if proc.returncode == 0:
        try:
            proxy_payload = json.loads(proc.stdout)
            parsed_outcome = proxy_payload.get('outcome', 'EVIDENCE_INSUFFICIENT')
        except Exception:
            parsed_outcome = 'EVIDENCE_INSUFFICIENT'

    results.append({
        'tag': tag,
        'commit': commit,
        'exit_code': proc.returncode,
        'outcome': parsed_outcome,
        'proxy_output': proxy_payload,
        'stdout_path': stdout_path,
        'stderr_path': stderr_path
    })
    print(f'[{tag}] -> {parsed_outcome}')

with open(os.path.join('${OUTPUT_BASE}', 't_b1_manifest.json'), 'w') as f:
    json.dump(manifest_entries, f, indent=2)

with open(os.path.join('${OUTPUT_BASE}', 't_b1_results.json'), 'w') as f:
    json.dump(results, f, indent=2)

print('T-B1 acquisition and scan completed successfully.')
"
