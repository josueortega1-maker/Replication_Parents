/**********************************************************************
 06_validation.do

 Cell-level and input-integrity checks for all 27 table environments.
 Fails immediately if a supplied-data result, regression coefficient,
 standard error, published estimator snapshot or expected output is off.
**********************************************************************/

version 18

/* ---------- All 62 cognitive coefficients and standard errors ---------- */
import delimited using "$VERIFY/cognitive_targets.csv", clear varnames(1) stringcols(_all)
destring n target_b target_se, replace
assert _N == 62

forvalues i = 1/`=_N' {
    local model = model[`i']
    local term = term[`i']
    local n_target = n[`i']
    local b_target = target_b[`i']
    local se_target = target_se[`i']
    quietly estimates restore `model'
    assert e(N) == `n_target'
    assert abs(_b[`term'] - `b_target') < 0.000002
    assert abs(_se[`term'] - `se_target') < 0.000002
}

/* ---------- Participant-data structure and direct table cells ---------- */
use "$DER/analysis_sample.dta", clear
assert _N == 540
isid participant_id
bysort market_id: assert _N == 18
quietly levelsof market_id, local(markets)
local nmarkets : word count `markets'
assert `nmarkets' == 30

local mechs "DA EADA RM sDA sDAL"
local truth_counts "28 31 25 28 19"
local quiz10_counts "95 94 96 102 106"
local quiz1_counts "71 73 70 66 89"
local attempt_sums "298 244 276 366 193"

local j = 0
foreach m of local mechs {
    local ++j
    local x : word `j' of `truth_counts'
    quietly count if mechanism == "`m'" & truthful
    assert r(N) == `x'
    local x : word `j' of `quiz10_counts'
    quietly count if mechanism == "`m'" & quiz_within_10m
    assert r(N) == `x'
    local x : word `j' of `quiz1_counts'
    quietly count if mechanism == "`m'" & quiz_first_attempt
    assert r(N) == `x'
    local x : word `j' of `attempt_sums'
    quietly summarize quiz_attempts if mechanism == "`m'", meanonly
    assert r(sum) == `x'
}

/* Table 7 source totals; formatting/overrides are separately checked. */
local age_n "108 103 108 107 108"
local age_sum "4565 4431 4719 2670 2230"
local female_n "108 103 108 108 108"
local female_sum "78 69 76 45 72"
local child_n "108 103 108 108 108"
local child_sum "124 106 127 37 23"
local work_n "108 103 108 108 108"
local work_sum "3051 3122 2971 2528 1621"

local j = 0
foreach m of local mechs {
    local ++j
    foreach v in age female children_past_primary working_hours {
        local stem = cond("`v'" == "children_past_primary", "child", cond("`v'" == "working_hours", "work", "`v'"))
        local en : word `j' of ``stem'_n'
        local es : word `j' of ``stem'_sum'
        quietly summarize `v' if mechanism == "`m'", meanonly
        assert r(N) == `en'
        assert abs(r(sum) - `es') < 0.000001
    }
}

/* Table 11 obvious mistakes among 24 safe-first types in each arm. */
local ob_mechs "DA EADA sDA sDAL"
local ob_counts "1 3 10 6"
local j = 0
foreach m of local ob_mechs {
    local ++j
    quietly count if mechanism == "`m'" & safe_first_type
    assert r(N) == 24
    local x : word `j' of `ob_counts'
    quietly count if mechanism == "`m'" & safe_first_type & obvious_mistake
    assert r(N) == `x'
}

/* Tables 12--13 directly computed arms (RM is validated below). */
local direct_mechs "DA EADA sDA sDAL"
local consequential "14 29 20 23"
local losses "2.357142857 1.758620690 1.950000000 1.739130435"
local j = 0
foreach m of local direct_mechs {
    local ++j
    local x : word `j' of `consequential'
    quietly count if mechanism == "`m'" & manipulation_rank_effect != 0
    assert r(N) == `x'
    quietly count if mechanism == "`m'" & manipulation_rank_effect > 0
    assert r(N) == 0
    quietly count if mechanism == "`m'" & manipulation_rank_effect < 0
    assert r(N) == `x'
    local ml : word `j' of `losses'
    quietly summarize manipulation_rank_effect if mechanism == "`m'" & manipulation_rank_effect < 0, meanonly
    assert abs(-r(mean) - `ml') < 0.000001
}

/* Table 24 first-deviation counts; denominators are 80,77,83,80,89. */
local fd1 "46 46 48 50 60"
local fd2 "23 17 21 14 19"
local fd3 "6 8 9 10 5"
local fd4 "5 6 5 6 5"
forvalues k = 1/4 {
    local j = 0
    foreach m of local mechs {
        local ++j
        local x : word `j' of `fd`k''
        quietly count if mechanism == "`m'" & !truthful & first_diff_group == `k'
        assert r(N) == `x'
    }
}

/* Table 25 published-code definition plus the strict-prose diagnostic. */
local skip_counts "5 6 10 16 18"
local strict_counts "2 2 5 9 9"
local inflate_counts "3 3 6 2 4"
local j = 0
foreach m of local mechs {
    local ++j
    local x : word `j' of `skip_counts'
    quietly count if mechanism == "`m'" & !truthful & skipping_down
    assert r(N) == `x'
    local x : word `j' of `strict_counts'
    quietly count if mechanism == "`m'" & !truthful & skipping_down_strict
    assert r(N) == `x'
    local x : word `j' of `inflate_counts'
    quietly count if mechanism == "`m'" & !truthful & inflating_demand
    assert r(N) == `x'
}

/* ---------- Archived published outputs and documented overrides ---------- */
import delimited using "$DATA/published_rm_counterfactuals.csv", clear varnames(1) stringcols(_all)
destring primary all_optimal_average, replace
assert _N == 6
isid outcome
assert primary == 51 & all_optimal_average == 68 if outcome == "consequential_count"
assert abs(primary - .47) < 1e-12 & abs(all_optimal_average - .63) < 1e-12 if outcome == "consequential_share"
assert abs(primary - .06) < 1e-12 & abs(all_optimal_average - .10) < 1e-12 if outcome == "beneficial_share"
assert abs(primary - 1.14) < 1e-12 & abs(all_optimal_average - .53) < 1e-12 if outcome == "average_rank_gain"
assert abs(primary - .41) < 1e-12 & abs(all_optimal_average - .53) < 1e-12 if outcome == "harmful_share"
assert abs(primary - 2.43) < 1e-12 & abs(all_optimal_average - 1.56) < 1e-12 if outcome == "average_rank_loss"

import delimited using "$DATA/published_simulation_results.csv", clear varnames(1) stringcols(_all)
destring estimate se, replace
assert _N == 45
isid table outcome mechanism variant
assert !missing(estimate)
assert !missing(se) if table == "ability_sorting"
assert missing(se) if table != "ability_sorting"
quietly count if table == "synthetic_pareto"
assert r(N) == 5
quietly count if table == "envy_both"
assert r(N) == 10
quietly count if table == "mechanism_summary"
assert r(N) == 20
quietly count if table == "ability_sorting"
assert r(N) == 10

import delimited using "$DATA/published_descriptive_overrides.csv", clear varnames(1) stringcols(_all)
destring published_value supplied_data_value, replace
assert _N == 2
assert published_value == 20.7 if statistic == "age_mean"
assert published_value == 47 if statistic == "married_share"

import delimited using "$DATA/published_first_deviation_rates.csv", clear varnames(1) stringcols(_all)
destring position da eada rm sda sdal, replace
assert _N == 4
isid position
assert da == .58 & eada == .60 & rm == .58 & sda == .62 & sdal == .67 if position == 1
assert da == .29 & eada == .22 & rm == .25 & sda == .17 & sdal == .21 if position == 2
assert da == .07 & eada == .10 & rm == .11 & sda == .12 & sdal == .06 if position == 3
assert da == .06 & eada == .08 & rm == .06 & sda == .08 & sdal == .05 if position == 4

import delimited using "$DATA/population_benchmarks.csv", clear varnames(1) stringcols(_all)
destring our_sample bhps_2022 census_2021, replace
assert _N == 3
isid statistic
assert our_sample == 70 & bhps_2022 == 56 & census_2021 == 51 if statistic == "Female"
assert our_sample == 42 & bhps_2022 == 41 & census_2021 == 39 if statistic == "Age (median)"
assert our_sample == 47 & bhps_2022 == 48 & census_2021 == 45 if statistic == "Married"

/* ---------- Fixed design and static-source integrity ---------- */
import delimited using "$DATA/literature.csv", clear varnames(1) stringcols(_all)
destring order, replace
assert _N == 31
isid order
isid citekey

import delimited using "$DATA/preferences.csv", clear varnames(1) stringcols(_all)
destring student_id, replace
assert _N == 18
isid student_id
gen str7 pref_signature = rank1 + rank2 + rank3 + rank4 + rank5 + rank6 + rank7
assert strlen(pref_signature) == 7
foreach s in A B C D E F G {
    assert strpos(pref_signature, "`s'") > 0
}

import delimited using "$DATA/priorities.csv", clear varnames(1) stringcols(_all)
destring priority_rank a b c d e f g, replace
assert _N == 18
isid priority_rank
foreach s in a b c d e f g {
    assert inrange(`s', 1, 18)
    isid `s'
}

import delimited using "$DATA/truthful_design_properties.csv", clear varnames(1) stringcols(_all)
destring pareto_efficient justified_envy je_triples je_students rank1-rank7 rank_sum, replace
assert _N == 3
isid mechanism
assert rank_sum == 49 & je_triples == 0 & je_students == 0 if mechanism == "DA"
assert rank_sum == 44 & je_triples == 3 & je_students == 2 if mechanism == "EADA"
assert rank_sum == 30 & je_triples == 30 & je_students == 8 if mechanism == "RM"
egen row_rank_sum = rowtotal(rank1-rank7)
assert row_rank_sum == 18

/* ---------- Every manuscript table environment has an output ---------- */
import delimited using "$VERIFY/table_manifest.csv", clear varnames(1) stringcols(_all)
destring order, replace
assert _N == 27
isid order
forvalues i = 1/`=_N' {
    local f = output_file[`i']
    confirm file "$TAB/`f'"
}

display as result "All 27 tables, 62 regression cells and source-integrity checks passed."
