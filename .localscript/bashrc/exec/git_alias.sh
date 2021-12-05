#!/bin/sh

# Show git diff "in staged" humanized
git config --global alias.difstat "diff --staged --numstat"

# Show git diff "in staged" with code preview
git config --global alias.difstag "diff --staged"

# Logging commit with decoration
# a.k.a adog / (a)ll (d)ecorate (o)neline (g)raph
git config --global alias.adog "log --all --decorate --oneline --graph"
