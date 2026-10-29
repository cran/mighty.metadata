## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(mighty.metadata)

## -----------------------------------------------------------------------------
path <- system.file("examples", "advs.yml", package = "mighty.metadata")
advs <- mighty_domain(path)
advs

## -----------------------------------------------------------------------------
list_columns(advs)
list_parameters(advs)
list_rows(advs)

## -----------------------------------------------------------------------------
select_column(advs, id = "AVAL") |>
  str()

## -----------------------------------------------------------------------------
advs <- mighty_domain(path) |>
  add_column(
    id = "TRTA",
    label = "Actual Treatment",
    method = "ADSL.TRT01A",
    .pos = 5
  ) |>
  update_column(id = "AVAL", label = "Analysis Value (Numeric)") |>
  remove_columns(id = "AVALC")

list_columns(advs)

## -----------------------------------------------------------------------------
validate(advs)

## ----error = TRUE-------------------------------------------------------------
try({
advs |> add_column(id = "AVAL", label = "Duplicate")
})

## -----------------------------------------------------------------------------
select_parameter(advs, id = "BMI") |>
  str()

## -----------------------------------------------------------------------------
advs <- advs |>
  add_parameter(
    id = "WSTCIR",
    label = "Waist Circumference (cm)",
    columns = list(
      list(id = "AVAL", method = "VS.VSSTRESN")
    )
  )

list_parameters(advs)

## -----------------------------------------------------------------------------
advs <- advs |>
  update_parameter(id = "WSTCIR", label = "Waist Circumference") |>
  remove_parameters(id = "BMIGRP")

list_parameters(advs)

## -----------------------------------------------------------------------------
select_row(advs, id = "BASELINE") |>
  str()

## -----------------------------------------------------------------------------
out <- tempfile(fileext = ".yml")
write_config(advs, path = out)

## -----------------------------------------------------------------------------
study_path <- system.file("examples", package = "mighty.metadata")
study <- mighty_study(study_path)
study

## -----------------------------------------------------------------------------
names(study)
str(study@study)
str(study@mighty)

## -----------------------------------------------------------------------------
study$ADSL <- study$ADSL |>
  update_column(id = "SEX", is_core = TRUE) |>
  update_column(id = "RACE", is_core = TRUE)

study$ADAE[["usecore"]] <- TRUE

study <- study |>
  populate_core()

list_columns(study$ADAE)

## -----------------------------------------------------------------------------
# Before: SAFFL in ADVS references ADSL.SAFFL
select_column(study$ADVS, id = "SAFFL") |>
  str()

## -----------------------------------------------------------------------------
study <- study |> populate_sparse()

# After: origin inherited from ADSL
select_column(study$ADVS, id = "SAFFL") |>
  str()

## -----------------------------------------------------------------------------
study <- mighty_study(study_path)

# Mark ADSL core variables
study$ADSL <- study$ADSL |>
  update_column(id = "SEX", is_core = TRUE) |>
  update_column(id = "RACE", is_core = TRUE)

# Mark consumer domains
study$ADAE[["usecore"]] <- TRUE

# Run the pipeline
study <- study |>
  populate_core() |>
  populate_sparse()

## -----------------------------------------------------------------------------
study <- mighty_study(study_path, populate = TRUE)

## -----------------------------------------------------------------------------
out <- withr::local_tempdir()
write_config(study, path = out)
list.files(out)

## -----------------------------------------------------------------------------
study <- mighty_study(study_path)

study$ADVS <- study$ADVS |>
  update_column(
    id = "STUDYID",
    include = "{study_id == 'example_study'}"
  )

## -----------------------------------------------------------------------------
resolved <- resolve_includes(study)
list_columns(resolved$ADVS)

## -----------------------------------------------------------------------------
resolved <- resolve_includes(study, info = list(study_id = "other"))
list_columns(resolved$ADVS)

## -----------------------------------------------------------------------------
create_md_table(study)

## -----------------------------------------------------------------------------
create_md_col(study)

## -----------------------------------------------------------------------------
create_md_param(study)

## -----------------------------------------------------------------------------
create_md_values(study)

