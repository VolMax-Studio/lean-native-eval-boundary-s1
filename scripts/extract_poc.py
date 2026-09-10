"""Extract the sole Lean fence in Steps to Reproduce; never invoke Lean."""
import json, re, sys
from pathlib import Path
raw=Path(sys.argv[1]).read_bytes()
body=json.loads(raw)['body']
section=body.split('### Steps to Reproduce\n',1)[1].split('\n### ',1)[0]
blocks=re.findall(r'^```lean\n(.*?)^```[ \t]*$',section,re.M|re.S)
if len(blocks)!=1: raise SystemExit('EXTRACTION_AMBIGUOUS')
poc=blocks[0].encode('utf-8')
if len(re.findall(rb'^\s*native_decide\s*$',poc,re.M))!=1 or poc.count(b'#print axioms flt')!=1:
 raise SystemExit('POC_STRUCTURE_UNEXPECTED')
Path(sys.argv[2]).write_bytes(poc)
