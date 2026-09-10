"""Draft T-B1 syntactic signature predicate. Does not establish runtime behavior.
Input: two complete UTF-8 source files from one pinned commit.
Absence/type failures belong to retrieval layer, not this predicate.
No reference or denominator source scan is executed merely by importing this file.
"""
import re, json, sys
from pathlib import Path
KEY='lean_string_utf8_extract'
LOGICAL='''| s, b, e => if b.byteIdx ≥ e.byteIdx then "" else ofList (go₁ s.toList 0 b e)
where
  go₁ : List Char → Pos → Pos → Pos → List Char
    | [], _, _, _ => []
    | s@(c::cs), i, b, e => if i = b then go₂ s i e else go₁ cs (i + c) b e
  go₂ : List Char → Pos → Pos → List Char
    | [], _, _ => []
    | c::cs, i, e => if i = e then [] else c :: go₂ cs (i + c) e'''
def norm(s): return re.sub(r'\s+','',s.replace('Pos.Raw','Pos'))
def classify(lean,cpp):
    # Fixed paths and explicit layout are part of the proxy. Changes are not repaired post hoc.
    anns=list(re.finditer(r'^@\[extern "lean_string_utf8_extract"(?:, expose)?\]\n',lean,re.M))
    candidates=[]
    for a in anns:
        tail=lean[a.end():]
        h=re.match(r'def (?:Pos(?:\.Raw)?\.)?extract : \(@& String\) → \(@& Pos(?:\.Raw)?\) → \(@& Pos(?:\.Raw)?\) → String\n',tail)
        if not h: continue
        end=re.search(r'^\S',tail[h.end():],re.M)
        # `where` is part of this declaration; next column-zero line after it ends the block.
        rest=tail[h.end():]
        lines=rest.splitlines(keepends=True); kept=[]
        for line in lines:
            if line.strip() and not line[0].isspace() and line.rstrip()!='where': break
            kept.append(line)
        candidates.append(''.join(kept))
    logical=[c for c in candidates if norm(c)==norm(LOGICAL)]
    fs=list(re.finditer(r'^extern "C" LEAN_EXPORT obj_res lean_string_utf8_extract\(b_obj_arg s, b_obj_arg b0, b_obj_arg e0\) \{\n(.*?)^\}',cpp,re.M|re.S))
    if len(logical)!=1 or len(fs)!=1:
        return {'outcome':'PREDICATE_INAPPLICABLE','logical_signature_matches':len(logical),'native_definition_matches':len(fs)}
    native=re.sub(r'/\*.*?\*/|//[^\n]*','',fs[0][1],flags=re.S)
    signature='if(!lean_is_scalar(b0)||!lean_is_scalar(e0)){returns;}'
    return {'outcome':'MISMATCH' if norm(native).startswith(signature) else 'NO_MISMATCH',
            'meaning':'syntactic signature pair only; no behavioral equivalence asserted'}
if __name__=='__main__':
    print(json.dumps(classify(Path(sys.argv[1]).read_text(),Path(sys.argv[2]).read_text()),indent=2))
