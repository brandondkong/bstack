#!/usr/bin/env bash
# Validate bstack's skills, agents, and cross-file references.
# Usage: scripts/check.sh   (from anywhere; exits non-zero on any failure)
set -uo pipefail
shopt -s nullglob

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
fail=0
err() { printf 'FAIL %s\n' "$1"; fail=1; }

frontmatter_has() {
	awk 'NR==1 && $0!="---" {exit 1} NR>1 && $0=="---" {exit} NR>1' "$1" | grep -q "^$2:"
}

for f in skills/*/SKILL.md agents/*.md; do
	[ -e "$f" ] || continue
	for key in name description; do
		frontmatter_has "$f" "$key" || err "$f: frontmatter missing '$key'"
	done
done

# Every backticked relative path inside a skill resolves from that skill's directory.
for skill in skills/*/; do
	while IFS=: read -r file ref; do
		ref="${ref//\`/}"
		[ -e "$skill$ref" ] || err "$file: '$ref' does not exist (relative to $skill)"
	done < <(grep -roE '`(\.\./[a-z0-9-]+/)?(playbooks|principles|references|scripts)/[A-Za-z0-9._-]+`' "$skill" --include='*.md')
done

# The router's index and the files on disk match in both directions.
mode=skills/bstack-mode/SKILL.md
if [ -f "$mode" ]; then
	for dir in playbooks principles; do
		for f in skills/bstack-mode/$dir/*.md; do
			grep -q "\`$dir/$(basename "$f")\`" "$mode" || err "$f is not listed in $mode"
		done
	done
fi

claude plugin validate . >/dev/null 2>&1 || err "claude plugin validate failed (run it for details)"

[ "$fail" -eq 0 ] && echo "check: ok"
exit "$fail"
