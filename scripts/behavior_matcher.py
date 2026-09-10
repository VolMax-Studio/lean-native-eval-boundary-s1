"""Structural text matcher derived from pinned formatter sources, without Lean runs.
The grammar accepts named diagnostic labels and optional end positions.
Conservative unparsed error markers prohibit acceptance and expected rejection.
"""
import re
import sys
from pathlib import Path

STD = {'propext', 'Classical.choice', 'Quot.sound'}
ERROR_MARKER = re.compile(r'(?<!\w)error(?:\([^\r\n]*\))?:')
HEADER = re.compile(
    r'(?m)^(?P<file>[^\r\n]+?):(?P<line>\d+):(?P<column>\d+)'
    r'(?:-(?P<end_line>\d+):(?P<end_column>\d+))?: '
    r'(?P<severity>error|warning)(?:\((?P<name>[^()\r\n]*)\))?: ?'
)
AX = re.compile(r"(?m)^'flt' depends on axioms:\s*\[([^\]]*)\]")

def diagnostics(stream):
    """Split one literal stream at all recognized severity headers."""
    starts = list(HEADER.finditer(stream))
    records = []
    for i, match in enumerate(starts):
        end = starts[i + 1].start() if i + 1 < len(starts) else len(stream)
        # A separate axiom-print record must not supply diagnostic keywords.
        ax = AX.search(stream, match.end(), end)
        if ax is not None:
            end = ax.start()
        records.append({**match.groupdict(), 'body': stream[match.end():end]})
    return records

def classify(poc, stdout, stderr, exitcode):
    ax = AX.findall(stdout)
    names = [name.strip() for name in ax[0].split(',')] if ax else []
    required = any(name not in STD and 'native_decide' in name for name in names)
    no_error = not ERROR_MARKER.search(stdout) and not ERROR_MARKER.search(stderr)
    if (exitcode == 0 and len(ax) == 1 and no_error and required
            and 'sorryAx' not in names):
        return 'ACCEPT'
    loc = [i + 1 for i, line in enumerate(poc.splitlines()) if line.strip() == 'native_decide']
    records = diagnostics(stdout) + diagnostics(stderr)
    errors = [record for record in records if record['severity'] == 'error']
    marker_count = len(ERROR_MARKER.findall(stdout)) + len(ERROR_MARKER.findall(stderr))
    expected = (
        len(loc) == 1 and exitcode != 0 and len(errors) == 1
        and marker_count == len(errors)
        and int(errors[0]['line']) == loc[0]
        and Path(errors[0]['file']).name == 'PoC.lean'
        and 'native_decide' in errors[0]['body']
        and re.search(r'\bfalse\b', errors[0]['body']) is not None
    )
    if expected:
        return 'EXPECTED_NATIVE_REJECTION'
    return 'EVIDENCE_INSUFFICIENT'

if __name__ == '__main__':
    print(classify(
        Path(sys.argv[1]).read_text(encoding='utf-8'),
        Path(sys.argv[2]).read_text(encoding='utf-8'),
        Path(sys.argv[3]).read_text(encoding='utf-8'),
        int(sys.argv[4]),
    ))
