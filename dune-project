(lang dune 2.8)

(name softcheck-analysis)

(generate_opam_files true)

(source
 (uri "git+https://github.com/joaosreis/softcheck-analysis.git"))

(bug_reports "https://github.com/joaosreis/softcheck-analysis/issues")

(homepage "https://github.com/joaosreis/softcheck-analysis")

(license MIT)

(authors "Jo\195\163o Santos Reis <joaosreis@outlook.pt>")

(maintainers "Jo\195\163o Santos Reis <joaosreis@outlook.pt>")

(package
 (name softcheck-analysis)
 (synopsis "Example analyses for the Softcheck platform")
 (depends
  (dune :build)
  (core
   (>= 0.15))
  softcheck
  lattices
  ppx_deriving
  ppx_sexp_conv))
