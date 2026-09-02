# R Environment for Environmental Sciences

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22251096.svg)](https://doi.org/10.5281/zenodo.22251096)

**Four packages worth knowing.**

Conference poster for the [iDiv Conference 2026](https://www.idiv.de/), Jena,
8 September 2026.

> Reproducibility is not one tool, it's a sequence.

Reproducibility in ecological research is a known problem with a less-known
solution: not one tool, but a small, composable set of them. The poster maps
four R packages onto the four points where an analysis usually breaks, and
works through a short example that combines all four.

| Package | The problem it solves |
|---|---|
| [renv](https://rstudio.github.io/renv/) | R keeps every package in one shared library and records no versions, so an analysis stops running after enough updates. renv gives each project its own library and writes the versions down. |
| [pins](https://pins.rstudio.com/) | Shared datasets live in too many places, drift out of sync, and have no single source of truth. |
| [testthat](https://testthat.r-lib.org/) | Expectations about the data, such as column names, value ranges and absence of duplicates, live in the researcher's head, so silent corruption and bad joins surface at submission rather than at the step that caused them. |
| [rmarkdown](https://rmarkdown.rstudio.com/) | Code, results and prose drift apart once they live in separate files. |

Most researchers already use one of the four. The poster is the nudge to use
the other three.

## Contents

| Path | What it is |
|---|---|
| `poster.html` | The poster: A0 portrait (841 × 1189 mm), self-contained: every image, font and script is embedded, so this one file is the whole deliverable. Open it in any browser. |
| `generate_qr.R` | Generates the poster's QR code as a compact single-path SVG. |
| `assets/` | The generated QR code. Source material only: `poster.html` embeds its own copy and does not read this directory. |
| `abstract.md` | The conference abstract. |
| `renv.lock` | Pinned R environment. |

## Reproducing

The poster is about reproducibility, so the repository practises it. Restore
the exact R environment, then regenerate the QR code:

```r
renv::restore()
```

```sh
Rscript generate_qr.R
```

`generate_qr.R` is deterministic: it rewrites `assets/qr_reproducible-r.svg`
byte for byte. It encodes a frozen URL at error-correction level Q (25 %
recovery) with a 4-module quiet zone, because a QR code printed wrong at A0
cannot be fixed afterwards. It verifies its own output and fails loudly rather
than writing a symbol that will not scan.

## Licence

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), reuse and adapt
freely, with attribution. See [LICENSE](LICENSE).

## Citation

See [CITATION.cff](CITATION.cff), or use GitHub's *Cite this repository*
button.

## Repository layout

`main` holds the poster. An earlier design, built with Quarto and Typst, was
abandoned; its final state is preserved on the local-only `quarto` branch and
is not published here.
