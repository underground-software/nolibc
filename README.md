# nolibc out of tree repo

The aim of this repository is to extract the latest version of
the linux kernel's 'nolibc' header only libc replacement on an
ongoing basis for easy consumption while offering access to the
unified history of the files (including revisions before it was
merged into the linux kernel repo) for use with git-blame etc
without having to pull all of the many gigabytes of git object
refs from the linux kernel.

This repository is read only (except for automatically pulling
in updates from the nolibc files in the linux linux periodically),
so any issues pull requests etc will be closed. Changes should be
made by submitting patches to the definitive upstream version in
the linux kernel repository.

The starting point for this work is a fork of Willy Tarreau's
existing out of tree repository for nolibc that was used exclusively
for its development for the first 1.5 years of the project (01/2017 -
09/2018) that includes the revisions from before a copy was merged
into the linux kernel.

Some commits to Willy's out of tree repository continued to be made
after a copy was merge into linux (equivalent versions were submitted
upstream), and fixes from the kernel were backported into the repo
keeping the in tree and out of tree code in sync for the next 3.5
years. (09/2018 - 02/2022). This repo will use those versions of the
commits as opposed to their corresponding upstream versions, so that
the master branch of this repository contains a strict superset of
Willy's master branch.

However at time of writing (01/2024), this syncing effort has been
abandoned and Willy's out of tree repo has been dormant for a year.

I am using the version from the master branch of Willy's repo as it
was on Sun Feb 27 07:40:44 PM UTC 2022 when the latest commit was:

```
296ea63 nolibc: add support for '%p' to vfprintf()
```

I added one commit on top of this branch that I authored to sync the
files exactly with their equivalents from upstream as of Thu Apr 21
12:05:45 AM UTC 2022, when the latest commit was:
```
bd845a193aae tools/nolibc/stdio: add support for '%p' to vfprintf()
```

That commit consisted of moving the text of the licenses to a the
`LICENSES` folder and replacing it in each file with the appropriate
SPDX identifier, and one trivial tabs vs spaces change.

For all subsequent changes, the commits are a result of synthesizing
a corresponding out of tree commit from an upstream commit that
changes file(s) within nolibc in the kernel using the `sync.sh`
script available in this branch.

The commit message, author, and committer are all preserved exactly
from their upstream counterparts except that an 'Upstream-commit'
trailer is appended with the hash of the corresponding upstream
commit. Empty commits / Merge commits without any changes are pruned,
and given the lack of other branches, merges also lose their
additional parents and become regular commits. No tags either.


At this time, changes to the folder `tools/include/nolibc` except
for the `Makefile` are mapped into the root of this repository, and
changes to `tools/testing/selftests/nolibc` are mapped into the
`tests` folder within this repository.

The code is currently up to date with upstream commit:
```
6613476e225e Linux 6.8-rc1
```
