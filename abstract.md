# R Environment for Environmental Sciences: Four Packages Worth Knowing

  Reproducibility in ecological research is a known problem with a less-known solution: not one tool, but a small, composable set of them. This poster introduces four R packages that, used together,
  address most of the practical pain points researchers encounter between raw data and reliable, publishable results.

  Each panel maps to one package. `renv` handles the environment itself: separate package libraries per project, version numbers recorded, no more "it works on my machine." Crucially, it also means
  that a project archived on Zenodo today will still run in five years, after dozens of package updates have broken everything else. `pins` solves a quieter but equally frustrating problem: shared
  datasets that live in too many places, get out of sync, and lack a single source of truth.

  `testthat` is the least obvious inclusion for ecologists, but arguably the most valuable. It lets you write down, in code, what you expect your data to look like: column names, value ranges, absence
  of duplicates. Those expectations are then checked automatically at every step of a pipeline. Combined with `checkmate` for argument validation and `testdat` for dataframe-specific checks, it turns
  assumptions that usually live in a researcher's head into something the computer can verify. Silent data corruption, wrong joins, and unexpected NAs get caught early rather than at submission.
  Finally, `rmarkdown` (and its successor `quarto`) ties everything together into documents where code, results, and prose coexist and can be re-run at any point.

  The poster also walks through a short workflow combining all four: loading a shared species occurrence dataset via `pins`, running it through a validated cleaning pipeline with
  `testthat` checks at each step, within a `renv`-locked environment, and producing a reproducible report with `rmarkdown`.

  The goal is practical. Many researchers are already using just one of them. The poster is meant to be the nudge that gets them to use the other three.
