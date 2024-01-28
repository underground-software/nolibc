#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
set -uexo pipefail

#default values, override by setting the appropriate env variables
: "${KERNEL_REPO:=$HOME/Documents/linux}"
: "${WORKDIR:=/tmp/nolibcsync}"
: "${WORKBRANCH:=work}"

show_pretty() {
	git -C "${KERNEL_REPO}" show -s "${HASH}" --pretty="$1"
}

#create new orphaned branch for this work
git worktree add "${WORKDIR}" --orphan -b "${WORKBRANCH}"
git -C "${WORKDIR}" commit --allow-empty -m 'initial commit'
git worktree remove "${WORKDIR}"

# reads a list of hashes from stdin, you might generate them via a command like:
# $ git rev-list --reverse ^v4.18 HEAD -- tools/include/nolibc/ tools/testing/selftests/nolibc/
while read -r HASH
do
	git worktree add --no-checkout "${WORKDIR}" "${WORKBRANCH}"
	git -C "${KERNEL_REPO}" archive "${HASH}":tools/include/nolibc/ ':(exclude)Makefile' | tar -C "${WORKDIR}" -x
	git -C "${KERNEL_REPO}" archive "${HASH}":tools/testing/selftests/nolibc/ --prefix='tests/' | tar -C "${WORKDIR}" -x
	git -C "${WORKDIR}" add --all
	#skip empty commits (e.g. commits that only change the exluded makefile)
	if test -n "$(git -C "${WORKDIR}" status --porcelain)"
	then
		show_pretty '%B' |
		GIT_AUTHOR_NAME="$(show_pretty '%an')" \
		GIT_AUTHOR_EMAIL="$(show_pretty '%ae')" \
		GIT_AUTHOR_DATE="$(show_pretty '%ad')" \
		GIT_COMMITTER_NAME="$(show_pretty '%cn')" \
		GIT_COMMITTER_EMAIL="$(show_pretty '%ce')" \
		GIT_COMMITTER_DATE="$(show_pretty '%cd')" \
		git -C "${WORKDIR}" commit -F - --trailer="Upstream-commit: ${HASH}"
	fi
	git worktree remove "${WORKDIR}"
done
