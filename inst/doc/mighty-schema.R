## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE---------------------------------------------------------------
S7schema::document_schema(
  x = system.file("schema", "mighty.json", package = "mighty.metadata"),
  header_start_level = 1
)

