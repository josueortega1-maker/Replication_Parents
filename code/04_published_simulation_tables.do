/**********************************************************************
 04_published_simulation_tables.do

 Generates the four recombinant-estimator tables from the archived
 published estimates supplied with this package. The underlying draw
 file and recombinant_estimator_v2.R were absent from the author folder,
 so these tables are regenerated from the published estimator output,
 not re-simulated. See REPLICATION_NOTES.md.
**********************************************************************/

version 18
import delimited using "$DATA/published_simulation_results.csv", clear ///
    varnames(1) stringcols(_all)
destring estimate se, replace
save "$DER/published_simulation_results.dta", replace

/* ---------- Table 14: truth-telling calibration under EADA ---------- */
local variants "observed_truth_0.29 target_truth_0.30 target_truth_0.50 target_truth_0.70 target_truth_0.90"
local j = 0
foreach v of local variants {
    local ++j
    quietly summarize estimate if table == "synthetic_pareto" & variant == "`v'", meanonly
    assert r(N) == 1
    local sp`j' : display %5.3f r(mean)
}

file open T14 using "$TAB/table_14_synthetic_pareto.tex", write text replace
file write T14 "\begin{table}[H]" _n "\centering" _n
file write T14 "\caption{Truth-telling and Pareto-efficiency under EADA (synthetic markets)}" _n
file write T14 "\label{tab:synthetic-pareto}" _n "\begin{tabular}{lc}" _n "\toprule" _n
file write T14 "Truth-telling rate & Share of Pareto-efficient allocations \\" _n "\midrule" _n
file write T14 "0.29 (observed) & `sp1' \\" _n
file write T14 "0.30 & `sp2' \\" _n
file write T14 "0.50 & `sp3' \\" _n
file write T14 "0.70 & `sp4' \\" _n
file write T14 "0.90 & `sp5' \\" _n
file write T14 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T14

/* ---------- Tables 15--16: envy and mechanism performance ---------- */
local mechs "DA EADA RM sDA sDAL"
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize estimate if table == "envy_both" & outcome == "reported_envy" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local reported`j' : display %4.2f r(mean)
    quietly summarize estimate if table == "envy_both" & outcome == "true_envy" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local trueenvy`j' : display %4.2f r(mean)

    quietly summarize estimate if table == "mechanism_summary" & outcome == "pareto_efficient" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local pe`j' : display %4.2f r(mean)
    quietly summarize estimate if table == "mechanism_summary" & outcome == "average_rank" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local avgrank`j' : display %4.2f r(mean)
    quietly summarize estimate if table == "mechanism_summary" & outcome == "maximum_rank" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local maxrank`j' : display %4.2f r(mean)
}

file open T15 using "$TAB/table_15_justified_envy.tex", write text replace
file write T15 "\begin{table}[H]" _n "\centering" _n
file write T15 "\caption{Share of subjects with justified envy under submitted and true preferences}" _n
file write T15 "\label{tab:envy_both}" _n "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T15 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T15 "Reported & `reported1' & `reported2' & `reported3' & `reported4' & `reported5' \\" _n
file write T15 "True & `trueenvy1' & `trueenvy2' & `trueenvy3' & `trueenvy4' & `trueenvy5' \\" _n
file write T15 "\bottomrule" _n "\multicolumn{6}{l}{\small Recombinant estimates.}" _n
file write T15 "\end{tabular}" _n "\end{table}" _n
file close T15

file open T16 using "$TAB/table_16_mechanism_summary.tex", write text replace
file write T16 "\begin{table}[H]" _n "\centering" _n
file write T16 "\caption{Mechanism performance summary (recombinant estimates)}" _n
file write T16 "\label{tab:mechanism_summary}" _n "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T16 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T16 "Pareto-efficient & `pe1' & `pe2' & `pe3' & `pe4' & `pe5' \\" _n
file write T16 "Average rank & `avgrank1' & `avgrank2' & `avgrank3' & `avgrank4' & `avgrank5' \\" _n
file write T16 "Maximum rank & `maxrank1' & `maxrank2' & `maxrank3' & `maxrank4' & `maxrank5' \\" _n
file write T16 "Justified envy & `trueenvy1' & `trueenvy2' & `trueenvy3' & `trueenvy4' & `trueenvy5' \\" _n
file write T16 "\bottomrule" _n "\end{tabular}" _n
file write T16 "\begin{minipage}{0.95\textwidth}\footnotesize\centering\textit{Note:} Based on 10,000 recombinant draws per treatment.\end{minipage}" _n
file write T16 "\end{table}" _n
file close T16

/* ---------- Appendix Table 26: ability sorting ---------- */
local j = 0
foreach m of local mechs {
    local ++j
    quietly summarize estimate if table == "ability_sorting" & outcome == "between_school_variance_share" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local bv`j' : display %5.3f r(mean)
    quietly summarize se if table == "ability_sorting" & outcome == "between_school_variance_share" & mechanism == "`m'", meanonly
    local bvse`j' : display %5.3f r(mean)
    quietly summarize estimate if table == "ability_sorting" & outcome == "dispersion_school_mean_raven" & mechanism == "`m'", meanonly
    assert r(N) == 1
    local ds`j' : display %5.3f r(mean)
    quietly summarize se if table == "ability_sorting" & outcome == "dispersion_school_mean_raven" & mechanism == "`m'", meanonly
    local dsse`j' : display %5.3f r(mean)
}

file open T26 using "$TAB/table_26_ability_sorting.tex", write text replace
file write T26 "\begin{table}[h!]" _n "\centering" _n
file write T26 "\caption{Ability sorting across schools (recombinant estimates)}" _n
file write T26 "\label{tab:segregation}" _n "\begin{tabular}{lccccc}" _n "\toprule" _n
file write T26 "& DA & EADA & RM & sDA & sDAL \\" _n "\midrule" _n
file write T26 "Between-school variance share & `bv1' & `bv2' & `bv3' & `bv4' & `bv5' \\" _n
file write T26 "& (`bvse1') & (`bvse2') & (`bvse3') & (`bvse4') & (`bvse5') \\[4pt]" _n
file write T26 "Dispersion of school mean Raven & `ds1' & `ds2' & `ds3' & `ds4' & `ds5' \\" _n
file write T26 "& (`dsse1') & (`dsse2') & (`dsse3') & (`dsse4') & (`dsse5') \\" _n
file write T26 "\bottomrule" _n
file write T26 "\multicolumn{6}{l}{\footnotesize Recombinant standard errors in parentheses.}" _n
file write T26 "\end{tabular}" _n "\end{table}" _n
file close T26

display as result "Published recombinant-output tables 14--16 and 26 exported."
