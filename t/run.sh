#!/bin/sh

if [ ! -d t/vim-vspec ]; then
    git clone https://github.com/kana/vim-vspec.git t/vim-vspec
fi

export testcase
for testcase in t/*.vim; do
    vim -u NONE -i NONE -N -e -s -S t/.run.vim 2>&1 | sed 's/\r$//'
done
