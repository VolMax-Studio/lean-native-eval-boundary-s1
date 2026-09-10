"""Replay declared single-change mutants in memory. Exceptions are not kills."""
import json
from pathlib import Path
import sys
import types
import hashlib

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]

def load_module(name, text):
    mod = types.ModuleType(name)
    exec(compile(text, name + '.py', 'exec'), mod.__dict__)
    return mod

def evaluate(mod, case):
    if case['kind'] == 'source_proxy':
        return mod.classify(case['lean'], case['cpp'])['outcome']
    return mod.classify(case['poc'], case['stdout'], case['stderr'], case['exitcode'])

def main():
    cases = json.loads((ROOT / 'tests/synthetic_cases.json').read_text(encoding='utf-8'))
    mutations = json.loads((ROOT / 'tests/mutations.json').read_text(encoding='utf-8'))
    texts = {kind: (ROOT / 'scripts' / (kind + '.py')).read_text(encoding='utf-8')
             for kind in ['source_proxy', 'behavior_matcher']}
    for kind, text in texts.items():
        mod = load_module(kind, text)
        for case in cases:
            if case['kind'] == kind and evaluate(mod, case) != case['expected']:
                raise RuntimeError('Baseline failed: ' + case['id'])
    killed = 0
    for mutation in mutations:
        text = texts[mutation['kind']]
        if text.count(mutation['find']) != 1:
            raise RuntimeError('Mutation site not unique: ' + mutation['id'])
        edited = text.replace(mutation['find'], mutation['replace'], 1)
        mod = load_module(mutation['kind'], edited)
        witnesses, exceptions = [], []
        for case in cases:
            if case['kind'] != mutation['kind']:
                continue
            try:
                actual = evaluate(mod, case)
            except Exception as exc:
                exceptions.append({'case': case['id'], 'type': type(exc).__name__})
                continue
            if actual != case['expected']:
                witnesses.append({'case': case['id'], 'expected': case['expected'], 'mutant_actual': actual})
        status = 'KILLED' if witnesses else 'SURVIVED'
        killed += bool(witnesses)
        print(json.dumps({'id': mutation['id'], 'status': status,
                          'mutated_source_sha256': hashlib.sha256(edited.encode()).hexdigest(),
                          'witnesses': witnesses, 'exceptions_not_counted_as_kills': exceptions}, sort_keys=True))
    print(f'SUMMARY killed={killed} survived={len(mutations)-killed} total={len(mutations)}')
    return 0 if killed == len(mutations) else 1

if __name__ == '__main__':
    raise SystemExit(main())
