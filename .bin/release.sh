#!/bin/bash

VERSION="${1:?}"
OWNER="b4b4r07"
REPO="enhancd"

env="$(builtin cd "${0%/*}" && pwd)/../.env"
if [[ ! -f $env ]]; then
    exit 1
fi
source "$env"

archive-artifact() {
    # README
    command mv -f README.md README.md.old
    sed -E 's/^(\[version-badge\]: http.*latest-v)([^-]+)(-.*)$/\1'$VERSION'\3/g' \
        README.md.old \
        >README.md
    command rm -f README.md.old
#    cat <<EOT
#$(date +"%Y-%m-%d")  BABAROT <b4b4r07@gmail.com>
#
#	* v${VERSION} updated
#
#EOT

    {
        git config user.email "b4b4r07@gmail.com"
        git config user.name "b4b4r07"
        git add -A
        git commit -m ":tada: Release of version $VERSION"
        git tag -a $VERSION -m "Release of version $VERSION"

        git remote set-url origin git@github.com:$OWNER/$REPO
        git push --tags
        git push origin master
    } &>/dev/null
}

github-create-release() {
    local input

    input="
    {
        \"tag_name\": \"${VERSION}\",
        \"target_commitish\": \"master\",
        \"draft\": false,
        \"prerelease\": false
    }"

    curl --fail -X POST \
        https://api.github.com/repos/${OWNER}/${REPO}/releases \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "${input}" \
        &>/dev/null
}

archive-artifact && \
    github-create-release && \
    echo "Done! https://github.com/$OWNER/$REPO/releases"
