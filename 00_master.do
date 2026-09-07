version 18
clear all
set more off
set seed 20260907

/* Run this file from the root of the replication package. */
global ROOT "`c(pwd)'"
global DATA "$ROOT/data"
global CODE "$ROOT/code"
global OUT  "$ROOT/output"
global DER  "$OUT/data"
global TAB  "$OUT/tables"
global LOG  "$OUT/logs"

capture mkdir "$OUT"
capture mkdir "$DER"
capture mkdir "$TAB"
capture mkdir "$LOG"

confirm file "$DATA/analysis_input.csv"
confirm file "$CODE/01_prepare_data.do"
confirm file "$CODE/02_cognitive_results.do"
confirm file "$CODE/03_validation.do"

capture log close _all
log using "$LOG/replication.log", text replace name(replication)

do "$CODE/01_prepare_data.do"
do "$CODE/02_cognitive_results.do"
do "$CODE/03_validation.do"

log close replication
display as result "Replication completed and all validation checks passed."

