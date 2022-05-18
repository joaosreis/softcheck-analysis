# A collection of analyses for SoftCheck

![main workflow](https://github.com/joaosreis/softcheck-analysis/actions/workflows/main.yml/badge.svg)

This repo contains a set of ready-to-instantiate analyses for
[SoftCheck](https://github.com/joaosreis/softcheck).

The set of analyses comprises:

- Available expressions: determine at each point the set of already computed
expressions, and not later modified, on all paths to the program point.
- Live variables: compute, for each program point, which variables are live in
the sense that a variable is live at a certain point if there is a path from
that point to one where the variable is used and not redefined.
- Reaching definitions: obtain, for each program point, which assignments may
have been made and not overwritten along some path to the program point.
- Taint: compute the possible program points where a certain expression is used.
- Very busy expressions: determine, for each program point, which expressions,
no matter what path is taken from that point, must always be used before any of
the variables occurring in it are redefined.
