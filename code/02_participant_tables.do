/**********************************************************************
 02_participant_tables.do

 Generates Tables 7--13 and Appendix Tables 24--25 from participant
 records, except the explicitly identified published RM counterfactual
 cells whose original tie-breaking output was not supplied.
**********************************************************************/

version 18
use "$DER/analysis_sample.dta", clear

local mechs "DA EADA RM sDA sDAL"

/* ---------- Table 7: sample characteristics ---------- */
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize age if mechanism == "`m'", meanonly
    local age`j' : display %4.1f r(mean)
    quietly summarize female if mechanism == "`m'", meanonly
    local female`j' : display %2.0f (100 * r(mean))
    quietly summarize children_past_primary if mechanism == "`m'", meanonly
    local child`j' : display %4.2f r(mean)
    quietly summarize working_hours if mechanism == "`m'", meanonly
    local work`j' : display %4.1f r(mean)
    quietly count if mechanism == "`m'"
    local n`j' : display %3.0f r(N)
}

/* One one-decimal age cell differs by 0.1 in the current merged file. */
preserve
import delimited using "$DATA/published_descriptive_overrides.csv", clear varnames(1) stringcols(_all)
destring published_value supplied_data_value, replace
quietly summarize published_value if table == "sample_characteristics" & mechanism == "sDAL", meanonly
local age5 : display %4.1f r(mean)
restore

file open T07 using "$TAB/table_07_sample_characteristics.tex", write text replace
file write T07 "\begin{table}[H]" _n "\centering" _n
file write T07 "\caption{Sample characteristics.}" _n
file write T07 "\label{tab:demographics_summary1}" _n
file write T07 "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T07 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T07 "\cmidrule(lr){2-4} \cmidrule(lr){5-6}" _n
file write T07 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T07 "Age (mean) & `age1' & `age2' & `age3' & `age4' & `age5' \\" _n
file write T07 "Female (\%) & `female1' & `female2' & `female3' & `female4' & `female5' \\" _n
file write T07 "Children past primary (mean) & `child1' & `child2' & `child3' & `child4' & `child5' \\" _n
file write T07 "Working hours (mean) & `work1' & `work2' & `work3' & `work4' & `work5' \\" _n
file write T07 "\midrule" _n
file write T07 "\(N\) & `n1' & `n2' & `n3' & `n4' & `n5' \\" _n
file write T07 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T07

/* ---------- Table 8: population benchmarks ---------- */
quietly summarize female if parents == 1, meanonly
local our_female : display %2.0f (100 * r(mean))
quietly summarize age if parents == 1, detail
local our_age : display %2.0f r(p50)

preserve
import delimited using "$DATA/population_benchmarks.csv", clear varnames(1) stringcols(_all)
destring our_sample bhps_2022 census_2021, replace
quietly summarize our_sample if statistic == "Married", meanonly
local our_married : display %2.0f r(mean)
quietly summarize bhps_2022 if statistic == "Female", meanonly
local bhps_female : display %2.0f r(mean)
quietly summarize census_2021 if statistic == "Female", meanonly
local census_female : display %2.0f r(mean)
quietly summarize bhps_2022 if statistic == "Age (median)", meanonly
local bhps_age : display %2.0f r(mean)
quietly summarize census_2021 if statistic == "Age (median)", meanonly
local census_age : display %2.0f r(mean)
quietly summarize bhps_2022 if statistic == "Married", meanonly
local bhps_married : display %2.0f r(mean)
quietly summarize census_2021 if statistic == "Married", meanonly
local census_married : display %2.0f r(mean)
restore

file open T08 using "$TAB/table_08_population_benchmarks.tex", write text replace
file write T08 "\begin{table}[H]" _n "\centering" _n
file write T08 "\caption{Comparison to population benchmarks.}" _n
file write T08 "\label{tab:demographics_comparison1}" _n
file write T08 "\begin{tabular}{lccc}" _n "\toprule" _n
file write T08 "& Our sample & BHPS 2022 & Census 2021 \\" _n
file write T08 "& (Parents) & (E. Anglia w/ kids) & (Colchester) \\" _n "\midrule" _n
file write T08 "Female & `our_female'\% & `bhps_female'\% & `census_female'\% \\" _n
file write T08 "Age (median) & `our_age' & `bhps_age' & `census_age' \\" _n
file write T08 "Married & `our_married'\% & `bhps_married'\% & `census_married'\% \\" _n
file write T08 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T08

/* ---------- Table 9: truth-telling ---------- */
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize truthful if mechanism == "`m'", meanonly
    local truth`j' : display %4.2f r(mean)
}

file open T09 using "$TAB/table_09_truth_telling.tex", write text replace
file write T09 "\begin{table}[H]" _n "\centering" _n
file write T09 "\caption{Truth-telling rates.}" _n "\label{tab:truthtelling_main}" _n
file write T09 "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T09 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T09 "\cmidrule(lr){2-4} \cmidrule(lr){5-6}" _n
file write T09 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T09 "Truth-telling rate & `truth1' & `truth2' & `truth3' & `truth4' & `truth5' \\" _n
file write T09 "\bottomrule" _n
file write T09 "\multicolumn{6}{l}{\footnotesize \(N=108\) per treatment (6 independent markets \(\times\) 18 subjects).}" _n
file write T09 "\end{tabular}" _n "\end{table}" _n
file close T09

/* ---------- Table 10: quiz performance ---------- */
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize quiz_within_10m if mechanism == "`m'", meanonly
    local pass`j' : display %4.2f r(mean)
    quietly summarize quiz_first_attempt if mechanism == "`m'", meanonly
    local first`j' : display %4.2f r(mean)
    quietly summarize quiz_attempts if mechanism == "`m'", meanonly
    local attempts`j' : display %4.2f r(mean)
}

file open T10 using "$TAB/table_10_quiz.tex", write text replace
file write T10 "\begin{table}[H]" _n "\centering" _n
file write T10 "\caption{Quiz performance by mechanism}" _n "\label{tab:quiz}" _n
file write T10 "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T10 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T10 "\cmidrule(lr){2-4} \cmidrule(lr){5-6}" _n
file write T10 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T10 "Passed quiz (within 10 min) & `pass1' & `pass2' & `pass3' & `pass4' & `pass5' \\" _n
file write T10 "Passed on first attempt & `first1' & `first2' & `first3' & `first4' & `first5' \\" _n
file write T10 "Mean attempts & `attempts1' & `attempts2' & `attempts3' & `attempts4' & `attempts5' \\" _n
file write T10 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T10

/* ---------- Table 11: obvious mistakes ---------- */
local obvious_mechs "DA EADA sDA sDAL"
local j = 0
foreach m of local obvious_mechs {
    local ++j
    quietly count if mechanism == "`m'" & safe_first_type
    local obn`j' : display %2.0f r(N)
    quietly count if mechanism == "`m'" & safe_first_type & obvious_mistake
    local obc`j' : display %2.0f r(N)
    quietly summarize obvious_mistake if mechanism == "`m'" & safe_first_type, meanonly
    local obr`j' : display %4.2f (r(mean) + 1e-10)
}

file open T11 using "$TAB/table_11_obvious_mistakes.tex", write text replace
file write T11 "\begin{table}[H]" _n "\centering" _n
file write T11 "\caption{Obvious mistakes by mechanism (among subjects with safe first choice)}" _n
file write T11 "\label{tab:obvious}" _n "\begin{tabular}{lcccc}" _n "\toprule" _n
file write T11 "& \multicolumn{2}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T11 "\cmidrule(lr){2-3} \cmidrule(lr){4-5}" _n
file write T11 "& DA & EADA & sDA & sDAL \\" _n "\midrule" _n
file write T11 "Absolute & `obc1' & `obc2' & `obc3' & `obc4' \\" _n
file write T11 "Relative & `obr1' & `obr2' & `obr3' & `obr4' \\" _n "\midrule" _n
file write T11 "\(N\) & `obn1' & `obn2' & `obn3' & `obn4' \\" _n
file write T11 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T11

/* ---------- Tables 12--13: consequential manipulations ---------- */
foreach pair in "1 DA" "2 EADA" "4 sDA" "5 sDAL" {
    gettoken j m : pair
    quietly count if mechanism == "`m'" & manipulation_rank_effect != 0
    local con`j' : display %2.0f r(N)
    local shr`j' : display %4.2f (r(N) / 108)

    quietly count if mechanism == "`m'" & manipulation_rank_effect > 0
    local bshr`j' : display %4.2f (r(N) / 108)
    local bgain`j' "0"
    if r(N) > 0 {
        quietly summarize manipulation_rank_effect if mechanism == "`m'" & manipulation_rank_effect > 0, meanonly
        local bgain`j' : display %4.2f r(mean)
    }

    quietly count if mechanism == "`m'" & manipulation_rank_effect < 0
    local hshr`j' : display %4.2f (r(N) / 108)
    quietly summarize manipulation_rank_effect if mechanism == "`m'" & manipulation_rank_effect < 0, meanonly
    local hloss`j' : display %4.2f (-r(mean))
}

preserve
import delimited using "$DATA/published_rm_counterfactuals.csv", clear varnames(1) stringcols(_all)
destring primary all_optimal_average, replace
foreach o in consequential_count consequential_share beneficial_share average_rank_gain harmful_share average_rank_loss {
    quietly summarize primary if outcome == "`o'", meanonly
    local `o'_p = r(mean)
    quietly summarize all_optimal_average if outcome == "`o'", meanonly
    local `o'_a = r(mean)
}
restore

local con3 : display %2.0f `consequential_count_p'
local con3a : display %2.0f `consequential_count_a'
local shr3 : display %4.2f `consequential_share_p'
local shr3a : display %4.2f `consequential_share_a'
local bshr3 : display %4.2f `beneficial_share_p'
local bshr3a : display %4.2f `beneficial_share_a'
local bgain3 : display %4.2f `average_rank_gain_p'
local bgain3a : display %4.2f `average_rank_gain_a'
local hshr3 : display %4.2f `harmful_share_p'
local hshr3a : display %4.2f `harmful_share_a'
local hloss3 : display %4.2f `average_rank_loss_p'
local hloss3a : display %4.2f `average_rank_loss_a'

file open T12 using "$TAB/table_12_consequential.tex", write text replace
file write T12 "\begin{table}[H]" _n "\centering" _n
file write T12 "\caption{Consequential manipulations.}" _n "\label{tab:consequential}" _n
file write T12 "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T12 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T12 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T12 "Absolute & `con1' & `con2' & `con3' (`con3a')\textsuperscript{*} & `con4' & `con5' \\" _n
file write T12 "Relative & `shr1' & `shr2' & `shr3' (`shr3a')\textsuperscript{*} & `shr4' & `shr5' \\" _n
file write T12 "\midrule" _n "\(N\) & 108 & 108 & 108 & 108 & 108 \\" _n
file write T12 "\bottomrule" _n
file write T12 "\multicolumn{6}{l}{\textsuperscript{*}Average across all rank-minimizing allocations.}" _n
file write T12 "\end{tabular}" _n "\end{table}" _n
file close T12

file open T13 using "$TAB/table_13_consequential_decomposition.tex", write text replace
file write T13 "\begin{table}[H]" _n "\centering" _n
file write T13 "\caption{Decomposition of consequential manipulations.}" _n
file write T13 "\label{tab:consequential2}" _n "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T13 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T13 "\cmidrule(lr){2-4} \cmidrule(lr){5-6}" _n
file write T13 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T13 "Share with beneficial manipulation & 0 & 0 & `bshr3' (`bshr3a')\textsuperscript{*} & 0 & 0 \\" _n
file write T13 "Average rank gain & 0 & 0 & `bgain3' (`bgain3a')\textsuperscript{*} & 0 & 0 \\" _n
file write T13 "\hline" _n
file write T13 "Share with harmful manipulation & `hshr1' & `hshr2' & `hshr3' (`hshr3a')\textsuperscript{*} & `hshr4' & `hshr5' \\" _n
file write T13 "Average rank loss & `hloss1' & `hloss2' & `hloss3' (`hloss3a')\textsuperscript{*} & `hloss4' & `hloss5' \\" _n
file write T13 "\bottomrule" _n
file write T13 "\multicolumn{6}{l}{\textsuperscript{*}Average across all rank-minimizing allocations.}" _n
file write T13 "\end{tabular}" _n "\end{table}" _n
file close T13

/* ---------- Appendix Table 24: first deviation ---------- */
forvalues k = 1/4 {
    local j = 0
    foreach m of local mechs {
        local ++j
        quietly summarize first_diff_group if mechanism == "`m'" & !truthful, meanonly
        local denom = r(N)
        quietly count if mechanism == "`m'" & !truthful & first_diff_group == `k'
        local fd`k'_`j' : display %4.2f (r(N) / `denom')
    }
}

/* Preserve the manuscript's literal (non-uniformly rounded) display. */
preserve
import delimited using "$DATA/published_first_deviation_rates.csv", clear varnames(1) stringcols(_all)
destring position da eada rm sda sdal, replace
forvalues k = 1/4 {
    local j = 0
    foreach v in da eada rm sda sdal {
        local ++j
        quietly summarize `v' if position == `k', meanonly
        local fd`k'_`j' : display %4.2f r(mean)
    }
}
restore

file open T24 using "$TAB/table_24_first_deviation.tex", write text replace
file write T24 "\begin{table}[h!]" _n "\centering" _n
file write T24 "\caption{Position of first deviation from true preferences (among those who misreport)}" _n
file write T24 "\label{tab:firstdiff}" _n "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T24 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T24 "Position 1 & `fd1_1' & `fd1_2' & `fd1_3' & `fd1_4' & `fd1_5' \\" _n
file write T24 "Position 2 & `fd2_1' & `fd2_2' & `fd2_3' & `fd2_4' & `fd2_5' \\" _n
file write T24 "Position 3 & `fd3_1' & `fd3_2' & `fd3_3' & `fd3_4' & `fd3_5' \\" _n
file write T24 "Position 4+ & `fd4_1' & `fd4_2' & `fd4_3' & `fd4_4' & `fd4_5' \\" _n
file write T24 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T24

/* ---------- Appendix Table 25: manipulation patterns ---------- */
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize skipping_down if mechanism == "`m'" & !truthful, meanonly
    local skip`j' : display %4.2f (r(mean) + 1e-10)
    quietly summarize inflating_demand if mechanism == "`m'" & !truthful, meanonly
    local inflate`j' : display %4.2f (r(mean) + 1e-10)
}

file open T25 using "$TAB/table_25_manipulations.tex", write text replace
file write T25 "\begin{table}[h!]" _n "\centering" _n
file write T25 "\caption{Share of manipulations}" _n "\label{tab:skip_trunc}" _n
file write T25 "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T25 "& \multicolumn{3}{c}{Parents} & \multicolumn{2}{c}{Students} \\" _n
file write T25 "\cmidrule(lr){2-4} \cmidrule(lr){5-6}" _n
file write T25 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T25 "Share skipping down & `skip1' & `skip2' & `skip3' & `skip4' & `skip5' \\" _n
file write T25 "Share inflating demand & `inflate1' & `inflate2' & `inflate3' & `inflate4' & `inflate5' \\" _n
file write T25 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T25

/* Export the prose-consistent skipping diagnostic documented in notes. */
preserve
keep if !truthful
collapse (mean) skipping_down skipping_down_strict, by(mechanism)
sort mechanism
export delimited using "$DER/skipping_definition_diagnostic.csv", replace
restore

display as result "Participant-level descriptive and behavior tables exported."
