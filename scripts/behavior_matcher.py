"""Structural draft matcher; inputs are saved outputs, never a Lean invocation.
No outcome-derived revisions permitted after freeze.
"""
import re,json,sys
from pathlib import Path
STD={'propext','Classical.choice','Quot.sound'}
# Freeze UTF-8, noncolored diagnostics; unparseable output is insufficient evidence.
DIAG=re.compile(r'(?m)^(.+?):(\d+):(\d+): error:([^\n]*(?:\n(?![^\n]*?:\d+:\d+: (?:error|warning|information):)[^\n]*)*)')
AX=re.compile(r"(?m)^'flt' depends on axioms:\s*\[([^\]]*)\]")
def classify(poc,stdout,stderr,exitcode):
    joined=stdout+'\n'+stderr
    ax=AX.findall(stdout)
    names=[n.strip() for n in ax[0].split(',')] if len(ax)==1 else []
    required=any(n not in STD and 'native_decide' in n for n in names)
    # Conjunction retained literally; any diagnostic error blocks acceptance.
    no_error='error:' not in joined and not DIAG.search(joined)
    if exitcode==0 and no_error and required and 'sorryAx' not in names:
        return 'ACCEPT'
    loc=[i+1 for i,l in enumerate(poc.splitlines()) if l.strip()=='native_decide']
    ds=list(DIAG.finditer(joined))
    expected=(len(loc)==1 and exitcode!=0 and len(ds)==1
              and int(ds[0][2])==loc[0] and Path(ds[0][1]).name=='PoC.lean'
              and 'native_decide' in ds[0][4] and re.search(r'\bfalse\b',ds[0][4]) is not None)
    if expected: return 'EXPECTED_NATIVE_REJECTION'
    return 'EVIDENCE_INSUFFICIENT'
if __name__=='__main__':
    print(classify(Path(sys.argv[1]).read_text(),Path(sys.argv[2]).read_text(),Path(sys.argv[3]).read_text(),int(sys.argv[4])))
