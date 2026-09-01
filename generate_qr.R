# Generate the poster QR code as a compact, single-path SVG.
#
# The target URL is FROZEN: it is printed on an A0 poster and cannot be changed
# afterwards. Error-correction level Q (25% recovery) is chosen so the symbol
# survives scuffing, glare and a partially obscured print.
#
# Two things this script does that the qrcode package's own generate_svg() does
# not:
#   1. A 4-module quiet zone. The package emits 3; ISO/IEC 18004 requires 4, and
#      on the poster's dark footer an undersized quiet zone is the most likely
#      reason a scan would fail.
#   2. One merged <path> instead of ~530 <rect> elements, so the file is small
#      enough to paste or embed anywhere and the coordinates are plain module
#      units (viewBox "0 0 41 41") rather than sub-pixel decimals.

url <- "https://albansagouis.com/reproducible-r/"
out_file <- "assets/qr_reproducible-r.svg"
printed_mm <- 46            # 92 px on the 1680 px A0 artboard = 46 mm
quiet <- 4L                 # quiet-zone modules per side

qr <- qrcode::qr_code(x = url, ecl = "Q")

# qr_code() returns the symbol wrapped in a 3-module quiet zone. Strip it so the
# zone can be re-added at the required width.
packaged_quiet <- 3L
n <- nrow(qr)
symbol <- qr[
  (packaged_quiet + 1L):(n - packaged_quiet),
  (packaged_quiet + 1L):(n - packaged_quiet)
]
size <- nrow(symbol)

# Offset extraction is easy to get wrong by one and impossible to spot by eye,
# so verify against the finder pattern that must sit at the symbol's corner:
# row 1 is solid, row 2 is dark-light*5-dark.
stopifnot(
  "symbol is not square"        = identical(nrow(symbol), ncol(symbol)),
  "finder row 1 malformed"      = all(symbol[1L, 1:7]),
  "finder row 2 malformed"      = identical(as.logical(symbol[2L, 1:7]),
                                            c(TRUE, rep(FALSE, 5L), TRUE))
)

# Merge each row's consecutive dark modules into one path segment, so the file
# carries ~130 segments rather than one rect per dark module.
segments <- unlist(lapply(seq_len(size), function(row) {
  runs <- rle(as.logical(symbol[row, ]))
  start <- cumsum(c(1L, utils::head(runs$lengths, -1L)))
  dark_runs <- which(runs$values)
  sprintf(
    "M%d %dh%dv1h-%dz",
    start[dark_runs] - 1L + quiet,
    row - 1L + quiet,
    runs$lengths[dark_runs],
    runs$lengths[dark_runs]
  )
}))

extent <- size + 2L * quiet

svg <- sprintf(
  paste0(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d" width="1000" height="1000" shape-rendering="crispEdges">\n',
    '  <title>%s</title>\n',
    '  <rect width="%d" height="%d" fill="#FFFFFF"/>\n',
    '  <path fill="#000000" d="%s"/>\n',
    '</svg>\n'
  ),
  extent, extent, url, extent, extent, paste(segments, collapse = "")
)

writeLines(text = svg, con = out_file)

# --- checks -----------------------------------------------------------------
# A QR is unrecoverable once printed wrong, so verify rather than assume.

written <- paste(readLines(con = out_file, warn = FALSE), collapse = "\n")
dark_modules <- sum(symbol)

stopifnot(
  "SVG was not written"     = file.exists(out_file),
  "SVG is empty"            = file.size(out_file) > 0L,
  "URL missing from SVG"    = grepl(url, written, fixed = TRUE),
  "viewBox missing"         = grepl(sprintf('viewBox="0 0 %d %d"', extent, extent), written, fixed = TRUE),
  "path is empty"           = grepl('d="M', written, fixed = TRUE),
  "module count mismatch"   = sum(as.integer(regmatches(
                                paste(segments, collapse = ""),
                                gregexpr("(?<=h)\\d+", paste(segments, collapse = ""), perl = TRUE)
                              )[[1L]])) == dark_modules
)

module_mm <- printed_mm / extent
cat(sprintf(
  paste0(
    "URL         : %s\nECC level   : Q (25%% recovery)\n",
    "Symbol      : %d x %d modules (version %d), %d dark\n",
    "With zone   : %d x %d modules (%d-module quiet zone)\n",
    "Printed at  : %g mm -> %.2f mm per module  [%s]\n",
    "Path segs   : %d (was 531 rects)\nOutput      : %s (%.1f kB)\n"
  ),
  url, size, size, (size - 17L) %/% 4L, dark_modules,
  extent, extent, quiet, printed_mm, module_mm,
  if (module_mm >= 0.5) "OK" else "TOO SMALL",
  length(segments), out_file, file.size(out_file) / 1024
))
