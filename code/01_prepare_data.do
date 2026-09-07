/**********************************************************************
 01_prepare_data.do

 Builds every participant-level measure used by the paper tables from
 the de-identified input. No original participant or session IDs enter
 the public package.
**********************************************************************/

version 18
import delimited using "$DATA/analysis_input.csv", clear varnames(1) stringcols(_all)

destring participant_id market_id id_in_group parents da eada rm low_stakes ///
    truthful_recorded first_diff_recorded own_rank rank_own_truth ///
    time_spent_quiz quiz_attempts age female children_past_primary ///
    working_hours marital_code raven_score_recorded, replace

/* Reconstruct the five treatment labels used throughout the paper. */
gen str5 mechanism = "EADA"
replace mechanism = "RM"   if rm == 1
replace mechanism = "DA"   if parents == 1 & da == 1
replace mechanism = "sDA"  if parents == 0 & da == 1 & low_stakes == 0
replace mechanism = "sDAL" if parents == 0 & da == 1 & low_stakes == 1

encode mechanism, gen(mechanism_id)
assert mechanism_id == 1 if mechanism == "DA"
assert mechanism_id == 2 if mechanism == "EADA"
assert mechanism_id == 3 if mechanism == "RM"
assert mechanism_id == 4 if mechanism == "sDA"
assert mechanism_id == 5 if mechanism == "sDAL"

/* Rebuild truth-telling and the first deviation from the seven ranks. */
gen byte truthful = 1
forvalues j = 1/7 {
    replace truthful = 0 if ranking`j' != true_pref`j'
}
assert truthful == truthful_recorded

gen byte first_diff = .
forvalues j = 1/7 {
    replace first_diff = `j' if missing(first_diff) & ranking`j' != true_pref`j'
}
assert missing(first_diff) if truthful
assert first_diff == first_diff_recorded if !truthful

/* Rebuild assigned rank as a data-integrity check. */
gen byte own_rank_rebuilt = .
forvalues j = 1/7 {
    replace own_rank_rebuilt = `j' if assigned_school == true_pref`j'
}
assert own_rank_rebuilt == own_rank
drop own_rank_rebuilt

/* Quiz measures reported in Table 10. */
gen byte quiz_within_10m = time_spent_quiz <= 600 if !missing(time_spent_quiz)
gen byte quiz_first_attempt = quiz_attempts == 1 if !missing(quiz_attempts)

/* Raven answer keys: blocks C, D and E contain 12 items each. */
local key_c "8 2 3 8 7 4 5 1 7 6 1 2"
local key_d "3 4 3 7 8 6 5 4 1 2 5 6"
local key_e "7 6 8 2 1 5 2 4 1 6 3 5"

foreach block in c d e {
    gen byte correct_`block' = 0
}

forvalues j = 1/12 {
    local ans : word `j' of `key_c'
    gen byte hit_c`j' = 0
    replace hit_c`j' = real(regexs(1)) == `ans' ///
        if regexm(choices_c, "apm`j'/a([0-9]+)[.]png")
    replace correct_c = correct_c + hit_c`j'
}

forvalues j = 1/12 {
    local q = `j' + 12
    local ans : word `j' of `key_d'
    gen byte hit_d`j' = 0
    replace hit_d`j' = real(regexs(1)) == `ans' ///
        if regexm(choices_d, "apm`q'/a([0-9]+)[.]png")
    replace correct_d = correct_d + hit_d`j'
}

forvalues j = 1/12 {
    local q = `j' + 24
    local ans : word `j' of `key_e'
    gen byte hit_e`j' = 0
    replace hit_e`j' = real(regexs(1)) == `ans' ///
        if regexm(choices_e, "apm`q'/a([0-9]+)[.]png")
    replace correct_e = correct_e + hit_e`j'
}
drop hit_*

assert raven_score_recorded == correct_c + correct_d + correct_e

/* The CDE specification uses mean items correct per 12-item block. */
gen double correct_cde = (correct_c + correct_d + correct_e) / 3

/* Leave-one-out market means for assigned-rank regressions. */
bysort market_id: assert _N == 18
bysort market_id: egen double total_correct_c = total(correct_c)
bysort market_id: egen double total_correct_cde = total(correct_cde)
gen double mean_correct_c_others = (total_correct_c - correct_c) / 17
gen double mean_correct_cde_others = (total_correct_cde - correct_cde) / 17
drop total_correct_c total_correct_cde

/* Obvious mistake: safe-first induced types 1, 6, 12 and 15. */
gen byte safe_first_type = inlist(id_in_group, 1, 6, 12, 15)
gen byte obvious_mistake = ranking1 != true_pref1 if safe_first_type

/*
 Positive values mean the manipulation improved rank; negative values
 mean it harmed rank. RM's published tie-breaking summaries are handled
 separately in 02_participant_tables.do (see REPLICATION_NOTES.md).
*/
gen double manipulation_rank_effect = 0
replace manipulation_rank_effect = rank_own_truth - own_rank if !truthful

/* First-deviation grouping used in Appendix Table 24. */
gen byte first_diff_group = first_diff
replace first_diff_group = 4 if first_diff >= 4 & !missing(first_diff)

/*
 Skipping down and inflating demand. The five schools other than A/B
 must preserve relative order. This implements the archived code used
 for the published cells; see REPLICATION_NOTES.md for the strict prose
 definition and diagnostic estimates.
*/
gen str7 true_others = ""
gen str7 stated_others = ""
forvalues j = 1/7 {
    replace true_others = true_others + true_pref`j' ///
        if !inlist(true_pref`j', "A", "B")
    replace stated_others = stated_others + ranking`j' ///
        if !inlist(ranking`j', "A", "B")
}

foreach s in A B {
    gen byte pos_true_`s' = .
    gen byte pos_stated_`s' = .
    forvalues j = 1/7 {
        replace pos_true_`s' = `j' if true_pref`j' == "`s'"
        replace pos_stated_`s' = `j' if ranking`j' == "`s'"
    }
}

gen byte skipping_down = true_others == stated_others & ///
    (pos_stated_A > pos_true_A | pos_stated_B > pos_true_B)

gen byte inflating_demand = true_others == stated_others & ///
    ranking1 == true_pref1 & ///
    ((inlist(pos_stated_A, 2, 3) & pos_stated_A < pos_true_A) | ///
     (inlist(pos_stated_B, 2, 3) & pos_stated_B < pos_true_B))

/* Strict prose-consistent diagnostic: neither A nor B may be promoted. */
gen byte skipping_down_strict = skipping_down & ///
    pos_stated_A >= pos_true_A & pos_stated_B >= pos_true_B

order participant_id market_id id_in_group mechanism mechanism_id truthful ///
    first_diff own_rank manipulation_rank_effect quiz_within_10m ///
    quiz_first_attempt correct_c correct_d correct_e correct_cde ///
    mean_correct_c_others mean_correct_cde_others

compress
save "$DER/analysis_sample.dta", replace
export delimited using "$DER/analysis_sample.csv", replace

assert _N == 540
foreach m in DA EADA RM sDA sDAL {
    quietly count if mechanism == "`m'"
    assert r(N) == 108
}
quietly levelsof market_id, local(markets)
local nmarkets : word count `markets'
assert `nmarkets' == 30

display as result "Analysis data prepared: 540 participants in 30 markets."
