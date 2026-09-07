/**********************************************************************
 01_prepare_data.do

 Builds the Raven measures and analysis samples from de-identified input.
**********************************************************************/

version 18
import delimited using "$DATA/analysis_input.csv", clear varnames(1) stringcols(_all)

destring participant_id market_id id_in_group parents da eada rm low_stakes ///
    truthful own_rank, replace

/* Reconstruct the five treatment labels used in the paper. */
gen str5 mechanism = "EADA"
replace mechanism = "RM"   if rm == 1
replace mechanism = "DA"   if parents == 1 & da == 1
replace mechanism = "sDA"  if parents == 0 & da == 1 & low_stakes == 0
replace mechanism = "sDAL" if parents == 0 & da == 1 & low_stakes == 1

encode mechanism, gen(mechanism_id)
label list mechanism_id
assert mechanism_id == 1 if mechanism == "DA"

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

/*
 The Appendix CDE measure is the mean number correct per block. Scaling
 the raw 36-item total by three is essential for matching Table CDE.
*/
gen double correct_cde = (correct_c + correct_d + correct_e) / 3

/* Leave-one-out market means. Every experimental market has 18 subjects. */
bysort market_id: assert _N == 18
bysort market_id: egen double total_correct_c = total(correct_c)
bysort market_id: egen double total_correct_cde = total(correct_cde)
gen double mean_correct_c_others = (total_correct_c - correct_c) / 17
gen double mean_correct_cde_others = (total_correct_cde - correct_cde) / 17
drop total_correct_c total_correct_cde

order participant_id market_id id_in_group mechanism mechanism_id truthful ///
    own_rank correct_c correct_d correct_e correct_cde ///
    mean_correct_c_others mean_correct_cde_others

compress
save "$DER/analysis_sample.dta", replace
export delimited using "$DER/analysis_sample.csv", replace

assert _N == 540
foreach m in DA EADA RM sDA sDAL {
    quietly count if mechanism == "`m'"
    assert r(N) == 108
}

display as result "Analysis data prepared: 540 participants in 30 markets."

