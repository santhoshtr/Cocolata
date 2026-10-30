#!/usr/bin/env bash
# Set a new font version, build the font, and make a commit and a tag.
# This script does not push.
#
# Usage: scripts/bump-version.sh <version>     (example: 0.002)
set -euo pipefail

version=${1:?Usage: $0 <version> (example: 0.002)}
tag="v$version"

# fontinfo.rs reads the version as MAJOR.MINOR with a 3-digit minor part.
if [[ ! $version =~ ^[0-9]+\.[0-9]{3}$ ]]; then
    echo "Error: version must be MAJOR.MMM (example: 0.002), not '$version'" >&2
    exit 1
fi

cd "$(git rev-parse --show-toplevel)"

if [[ $(git branch --show-current) != master ]]; then
    echo "Error: not on the master branch" >&2
    exit 1
fi
if ! git diff --quiet HEAD; then
    echo "Error: the working tree has uncommitted changes" >&2
    exit 1
fi
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
    echo "Error: tag $tag exists" >&2
    exit 1
fi

sed -i "s/^version: .*/version: $version/" config.yaml
if ! grep -qx "version: $version" config.yaml; then
    echo "Error: could not set the version in config.yaml" >&2
    exit 1
fi

# Run the build in the devcontainer. If the devcontainer CLI is not
# available, the script runs in the container, so run make directly.
if command -v devcontainer >/dev/null; then
    devcontainer exec --workspace-folder . bash -c 'make clean && make -j build'
else
    make clean
    make -j build
fi

git commit -m "Bump version to $version" config.yaml
git tag "$tag"

echo "Created commit and tag $tag. Push them with: git push && git push origin $tag"
