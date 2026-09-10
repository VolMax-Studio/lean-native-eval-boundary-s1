"""Replay the nine packaged synthetic cases; no Lean or source snapshot reads."""
import importlib.util
import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]

def module(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / 'scripts' / (name + '.py'))
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result

def main():
    cases = json.loads((ROOT / 'tests/synthetic_cases.json').read_text(encoding='utf-8'))
    if len(cases) != 9 or len({c['id'] for c in cases}) != 9:
        raise ValueError('Expected nine uniquely identified cases')
    proxy, behavior = module('source_proxy'), module('behavior_matcher')
    passed = 0
    for case in cases:
        try:
            if case['kind'] == 'source_proxy':
                actual = proxy.classify(case['lean'], case['cpp'])['outcome']
            elif case['kind'] == 'behavior_matcher':
                actual = behavior.classify(case['poc'], case['stdout'], case['stderr'], case['exitcode'])
            else:
                raise ValueError('Unknown case kind')
            ok = actual == case['expected']
            print(f"{'PASS' if ok else 'FAIL'} {case['id']} expected={case['expected']} actual={actual}")
        except Exception as exc:
            ok = False
            print(f"FAIL {case['id']} exception={type(exc).__name__}: {exc}")
        passed += int(ok)
    print(f'SUMMARY passed={passed} failed={len(cases)-passed} total={len(cases)}')
    return 0 if passed == len(cases) else 1

if __name__ == '__main__':
    raise SystemExit(main())
