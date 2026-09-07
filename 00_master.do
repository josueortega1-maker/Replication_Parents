version 18
clear all
set more off
set seed 20260907

/* Run this file from the root of the replication package. */
global ROOT "`c(pwd)'"
global DATA "$ROOT/data"
global CODE "$ROOT/code"
global OUT "$ROOT/output"
global DER "$OUT/data"
global TAB "$OUT/tables"
global LOG "$OUT/logs"
global VERIFY "$ROOT/verification"

capture mkdir "$OUT"
capture mkdir "$DER"
capture mkdir "$TAB"
capture mkdir "$LOG"

foreach f in ///
    "$DATA/literature.csv" ///
    "$DATA/preferences.csv" ///
    "$DATA/priorities.csv" ///
    "$DATA/published_first_deviation_rates.csv" ///
    "$DATA/population_benchmarks.csv" ///
    "$DATA/published_descriptive_overrides.csv" ///
    "$DATA/published_rm_counterfactuals.csv" ///
    "$DATA/published_simulation_results.csv" ///
    "$DATA/truthful_design_properties.csv" ///
    "$VERIFY/cognitive_targets.csv" ///
    "$VERIFY/table_manifest.csv" {
        confirm file "`f'"
}

capture confirm file "$DATA/analysis_input.csv"
if _rc {
    display as error "Restricted input not found: data/analysis_input.csv"
    display as error "The public repository distributes code only. See data/README.md."
    exit 601
}

foreach f in ///
    "$CODE/01_prepare_data.do" ///
    "$CODE/02_participant_tables.do" ///
    "$CODE/03_cognitive_tables.do" ///
    "$CODE/04_published_simulation_tables.do" ///
    "$CODE/05_design_tables.do" ///
    "$CODE/06_validation.do" {
        confirm file "`f'"
}

capture log close _all
log using "$LOG/replication.log", text replace name(replication)

do "$CODE/01_prepare_data.do"
do "$CODE/02_participant_tables.do"
do "$CODE/03_cognitive_tables.do"
do "$CODE/04_published_simulation_tables.do"
do "$CODE/05_design_tables.do"
do "$CODE/06_validation.do"

log close replication
display as result "Replication completed: all 27 manuscript tables generated and validated."
