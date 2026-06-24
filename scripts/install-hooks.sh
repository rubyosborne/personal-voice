#!/usr/bin/env bash
# Install a local git post-commit hook that keeps dist/voice.zip current.
# Run once per machine (hooks live in .git/ and aren't shared by clone):
#   ./scripts/install-hooks.sh

set -euo pipefail
cd "$(dirname "$0")/.."   # repo root

HOOK=".git/hooks/post-commit"
cat > "$HOOK" <<'EOF'
#!/usr/bin/env bash
# Rebuild the uploadable voice skill bundle after every commit, so
# dist/voice.zip always reflects the latest corpus. (gitignored; local only)
cd "$(git rev-parse --show-toplevel)"
./scripts/build-skill-bundle.sh >/dev/null 2>&1 || true
EOF
chmod +x "$HOOK"

echo "Installed $HOOK — dist/voice.zip will rebuild after each commit."
