#!/usr/bin/env bash
# Publish both anonymous repositories under a neutral GitHub account.
#
#   page : <user>.github.io      -> https://<user>.github.io/
#   code : FG-WVAM               -> https://github.com/<user>/FG-WVAM
#
# Prerequisites
#   * a neutral GitHub account (e.g. anonymous-fgwvam)
#   * a fine-grained token with, for that account:
#       Contents: Read and write
#       Administration: Read and write   (create repos, enable Pages)
#       Metadata: Read
#
# Usage (from this directory):
#   GH_TOKEN=github_pat_xxx bash scripts/deploy_anonymous.sh
#
# The token is only used for the push URL and the API calls; it is not written
# into .git/config.
set -euo pipefail

: "${GH_TOKEN:?set GH_TOKEN to the neutral account token}"
GH_USER="${GH_USER:-anonymous-fgwvam}"
CODE_REPO="${CODE_REPO:-FG-WVAM}"
PAGE_REPO="${PAGE_REPO:-${GH_USER}.github.io}"
PROXY="${HTTPS_PROXY:-http://127.0.0.1:7897}"

export GH_TOKEN HTTPS_PROXY="$PROXY" HTTP_PROXY="$PROXY"

api() { gh api "$@"; }

echo "[0/5] account check"
LOGIN=$(api user --jq .login)
[ "$LOGIN" = "$GH_USER" ] || { echo "token belongs to $LOGIN, expected $GH_USER"; exit 1; }
echo "    token OK for $LOGIN"

create_repo() {
  local name="$1" desc="$2"
  if api "repos/$GH_USER/$name" >/dev/null 2>&1; then
    echo "    $name already exists"
  else
    api --method POST user/repos -f name="$name" -F private=false \
        -f description="$desc" >/dev/null
    echo "    created $name"
  fi
}

push_repo() {
  local dir="$1" name="$2"
  git -C "$dir" config user.name "Anonymous"
  git -C "$dir" config user.email "noreply@example.com"
  git -C "$dir" branch -M main
  git -C "$dir" push --force "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${name}.git" main
}

enable_pages() {
  local name="$1"
  api --method POST "repos/$GH_USER/$name/pages" \
      -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || api --method PUT "repos/$GH_USER/$name/pages" \
      -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || echo "    Pages may already be enabled (check Settings -> Pages)"
}

HERE="$(cd "$(dirname "$0")/.." && pwd)"
CODE_DIR="$(cd "$HERE/../FG-WVAM" && pwd)"

echo "[1/5] repositories"
create_repo "$PAGE_REPO" "Anonymous project page"
create_repo "$CODE_REPO" "FG-WVAM: anonymous code release"

echo "[2/5] pushing page"
push_repo "$HERE" "$PAGE_REPO"

echo "[3/5] pushing code"
push_repo "$CODE_DIR" "$CODE_REPO"

echo "[4/5] enabling GitHub Pages"
enable_pages "$PAGE_REPO"

echo "[5/5] done"
echo "    page : https://${GH_USER}.github.io/"
echo "    code : https://github.com/${GH_USER}/${CODE_REPO}"
echo "    Pages build takes about one minute; status:"
echo "      gh api repos/${GH_USER}/${PAGE_REPO}/pages --jq .status"