/**********************************************************************
 03_cognitive_tables.do

 Reproduces the four block-C models in the main paper and the four CDE
 models in the appendix. Tables are written in the manuscript layout.

 Logits use conventional maximum-likelihood standard errors. OLS uses
 CR1 standard errors clustered by 18-person market. Following the
 supplied R output, OLS significance stars use residual degrees of
 freedom N-k rather than Stata's default G-1 cluster degrees of freedom.
**********************************************************************/

version 18
use "$DER/analysis_sample.dta", clear

/* Main paper: block C, all five treatments, N = 540. */
quietly logit truthful correct_c ib1.mechanism_id
estimates store main_c1

quietly logit truthful c.correct_c##ib1.mechanism_id
estimates store main_c2

quietly regress own_rank correct_c ib1.mechanism_id ///
    mean_correct_c_others, vce(cluster market_id)
estimates store main_c3

quietly regress own_rank c.correct_c##ib1.mechanism_id ///
    mean_correct_c_others, vce(cluster market_id)
estimates store main_c4

/* Appendix: CDE mean, excluding sDA because D/E were not recorded. */
preserve
drop if mechanism == "sDA"
assert _N == 432

quietly logit truthful correct_cde ib1.mechanism_id
estimates store app_cde1

quietly logit truthful c.correct_cde##ib1.mechanism_id
estimates store app_cde2

quietly regress own_rank correct_cde ib1.mechanism_id ///
    mean_correct_cde_others, vce(cluster market_id)
estimates store app_cde3

quietly regress own_rank c.correct_cde##ib1.mechanism_id ///
    mean_correct_cde_others, vce(cluster market_id)
estimates store app_cde4
restore

/* Collect a formatted coefficient, SE and manuscript-style star suffix. */
capture program drop stashcell
program define stashcell
    syntax, MODEL(name) TERM(string) PREFIX(name) [LINEAR]
    quietly estimates restore `model'
    scalar __b = _b[`term']
    scalar __s = _se[`term']
    scalar __p = 2 * normal(-abs(__b / __s))
    if "`linear'" != "" scalar __p = 2 * ttail(e(N) - colsof(e(b)), abs(__b / __s))

    local __stars ""
    if __p < .10 local __stars "^{*}"
    if __p < .05 local __stars "^{**}"
    if __p < .01 local __stars "^{***}"

    local __bt : display %7.3f __b
    local __st : display %7.3f __s
    local __bt = strtrim("`__bt'")
    local __st = strtrim("`__st'")
    c_local `prefix'_b "`__bt'"
    c_local `prefix'_s "`__st'"
    c_local `prefix'_x "`__stars'"
end

/* Main-table cells. */
foreach spec in ///
    "main_c1 correct_c m1_r" ///
    "main_c2 correct_c m2_r" ///
    "main_c3 correct_c m3_r linear" ///
    "main_c4 correct_c m4_r linear" ///
    "main_c1 2.mechanism_id m1_e" ///
    "main_c2 2.mechanism_id m2_e" ///
    "main_c3 2.mechanism_id m3_e linear" ///
    "main_c4 2.mechanism_id m4_e linear" ///
    "main_c1 3.mechanism_id m1_m" ///
    "main_c2 3.mechanism_id m2_m" ///
    "main_c3 3.mechanism_id m3_m linear" ///
    "main_c4 3.mechanism_id m4_m linear" ///
    "main_c1 4.mechanism_id m1_d" ///
    "main_c2 4.mechanism_id m2_d" ///
    "main_c3 4.mechanism_id m3_d linear" ///
    "main_c4 4.mechanism_id m4_d linear" ///
    "main_c1 5.mechanism_id m1_l" ///
    "main_c2 5.mechanism_id m2_l" ///
    "main_c3 5.mechanism_id m3_l linear" ///
    "main_c4 5.mechanism_id m4_l linear" ///
    "main_c2 2.mechanism_id#c.correct_c m2_re" ///
    "main_c4 2.mechanism_id#c.correct_c m4_re linear" ///
    "main_c2 3.mechanism_id#c.correct_c m2_rm" ///
    "main_c4 3.mechanism_id#c.correct_c m4_rm linear" ///
    "main_c2 4.mechanism_id#c.correct_c m2_rd" ///
    "main_c4 4.mechanism_id#c.correct_c m4_rd linear" ///
    "main_c2 5.mechanism_id#c.correct_c m2_rl" ///
    "main_c4 5.mechanism_id#c.correct_c m4_rl linear" ///
    "main_c3 mean_correct_c_others m3_o linear" ///
    "main_c4 mean_correct_c_others m4_o linear" ///
    "main_c1 _cons m1_c" ///
    "main_c2 _cons m2_c" ///
    "main_c3 _cons m3_c linear" ///
    "main_c4 _cons m4_c linear" {
        tokenize `"`spec'"'
        local opt ""
        if "`4'" == "linear" local opt "linear"
        stashcell, model(`1') term("`2'") prefix(`3') `opt'
}

file open T17 using "$TAB/table_17_cognitive_main.tex", write text replace
file write T17 "\begin{table}[H]" _n "\centering" _n
file write T17 "\caption{Cognitive ability, truth-telling, and outcomes}" _n
file write T17 "\label{tab:cognitive1}" _n "\small" _n
file write T17 "\begin{tabular}{l cc cc}" _n "\toprule" _n
file write T17 "& \multicolumn{2}{c}{Truth-telling (logit)} & \multicolumn{2}{c}{Assigned rank (OLS)} \\" _n
file write T17 "\cmidrule(lr){2-3} \cmidrule(lr){4-5}" _n
file write T17 "& (1) & (2) & (3) & (4) \\" _n "\midrule" _n
file write T17 "Raven & \(`m1_r_b'`m1_r_x'\) & \(`m2_r_b'`m2_r_x'\) & \(`m3_r_b'`m3_r_x'\) & \(`m4_r_b'`m4_r_x'\) \\" _n
file write T17 "& \((`m1_r_s')\) & \((`m2_r_s')\) & \((`m3_r_s')\) & \((`m4_r_s')\) \\[4pt]" _n
file write T17 "EADA & \(`m1_e_b'`m1_e_x'\) & \(`m2_e_b'`m2_e_x'\) & \(`m3_e_b'`m3_e_x'\) & \(`m4_e_b'`m4_e_x'\) \\" _n
file write T17 "& \((`m1_e_s')\) & \((`m2_e_s')\) & \((`m3_e_s')\) & \((`m4_e_s')\) \\[4pt]" _n
file write T17 "RM & \(`m1_m_b'`m1_m_x'\) & \(`m2_m_b'`m2_m_x'\) & \(`m3_m_b'`m3_m_x'\) & \(`m4_m_b'`m4_m_x'\) \\" _n
file write T17 "& \((`m1_m_s')\) & \((`m2_m_s')\) & \((`m3_m_s')\) & \((`m4_m_s')\) \\[4pt]" _n
file write T17 "sDA & \(`m1_d_b'`m1_d_x'\) & \(`m2_d_b'`m2_d_x'\) & \(`m3_d_b'`m3_d_x'\) & \(`m4_d_b'`m4_d_x'\) \\" _n
file write T17 "& \((`m1_d_s')\) & \((`m2_d_s')\) & \((`m3_d_s')\) & \((`m4_d_s')\) \\[4pt]" _n
file write T17 "sDAL & \(`m1_l_b'`m1_l_x'\) & \(`m2_l_b'`m2_l_x'\) & \(`m3_l_b'`m3_l_x'\) & \(`m4_l_b'`m4_l_x'\) \\" _n
file write T17 "& \((`m1_l_s')\) & \((`m2_l_s')\) & \((`m3_l_s')\) & \((`m4_l_s')\) \\[4pt]" _n
file write T17 "Raven \(\times\) EADA & & \(`m2_re_b'`m2_re_x'\) & & \(`m4_re_b'`m4_re_x'\) \\" _n
file write T17 "& & \((`m2_re_s')\) & & \((`m4_re_s')\) \\[4pt]" _n
file write T17 "Raven \(\times\) RM & & \(`m2_rm_b'`m2_rm_x'\) & & \(`m4_rm_b'`m4_rm_x'\) \\" _n
file write T17 "& & \((`m2_rm_s')\) & & \((`m4_rm_s')\) \\[4pt]" _n
file write T17 "Raven \(\times\) sDA & & \(`m2_rd_b'`m2_rd_x'\) & & \(`m4_rd_b'`m4_rd_x'\) \\" _n
file write T17 "& & \((`m2_rd_s')\) & & \((`m4_rd_s')\) \\[4pt]" _n
file write T17 "Raven \(\times\) sDAL & & \(`m2_rl_b'`m2_rl_x'\) & & \(`m4_rl_b'`m4_rl_x'\) \\" _n
file write T17 "& & \((`m2_rl_s')\) & & \((`m4_rl_s')\) \\[4pt]" _n
file write T17 "\(\overline{\mathrm{Raven}}_{-i}\) & & & \(`m3_o_b'`m3_o_x'\) & \(`m4_o_b'`m4_o_x'\) \\" _n
file write T17 "& & & \((`m3_o_s')\) & \((`m4_o_s')\) \\[4pt]" _n
file write T17 "Constant & \(`m1_c_b'`m1_c_x'\) & \(`m2_c_b'`m2_c_x'\) & \(`m3_c_b'`m3_c_x'\) & \(`m4_c_b'`m4_c_x'\) \\" _n
file write T17 "& \((`m1_c_s')\) & \((`m2_c_s')\) & \((`m3_c_s')\) & \((`m4_c_s')\) \\" _n
file write T17 "\midrule" _n "\(N\) & 540 & 540 & 540 & 540 \\" _n "\bottomrule" _n
file write T17 "\end{tabular}" _n "\vspace{4pt}" _n
file write T17 "{\footnotesize Notes: Raven denotes the block C score (see text). Columns (1)--(2) report logit coefficients with standard errors in parentheses; columns (3)--(4) report OLS estimates with standard errors clustered at the market level in parentheses. \(^{*}p<0.10\), \(^{**}p<0.05\), \(^{***}p<0.01\). DA is the reference category. \(\overline{\mathrm{Raven}}_{-i}\) is included only in the rank regressions, as it should not affect one's truth-telling decision.}" _n
file write T17 "\end{table}" _n
file close T17

/* Appendix-table cells. */
foreach spec in ///
    "app_cde1 correct_cde a1_r" ///
    "app_cde2 correct_cde a2_r" ///
    "app_cde3 correct_cde a3_r linear" ///
    "app_cde4 correct_cde a4_r linear" ///
    "app_cde1 2.mechanism_id a1_e" ///
    "app_cde2 2.mechanism_id a2_e" ///
    "app_cde3 2.mechanism_id a3_e linear" ///
    "app_cde4 2.mechanism_id a4_e linear" ///
    "app_cde1 3.mechanism_id a1_m" ///
    "app_cde2 3.mechanism_id a2_m" ///
    "app_cde3 3.mechanism_id a3_m linear" ///
    "app_cde4 3.mechanism_id a4_m linear" ///
    "app_cde1 5.mechanism_id a1_l" ///
    "app_cde2 5.mechanism_id a2_l" ///
    "app_cde3 5.mechanism_id a3_l linear" ///
    "app_cde4 5.mechanism_id a4_l linear" ///
    "app_cde2 2.mechanism_id#c.correct_cde a2_re" ///
    "app_cde4 2.mechanism_id#c.correct_cde a4_re linear" ///
    "app_cde2 3.mechanism_id#c.correct_cde a2_rm" ///
    "app_cde4 3.mechanism_id#c.correct_cde a4_rm linear" ///
    "app_cde2 5.mechanism_id#c.correct_cde a2_rl" ///
    "app_cde4 5.mechanism_id#c.correct_cde a4_rl linear" ///
    "app_cde3 mean_correct_cde_others a3_o linear" ///
    "app_cde4 mean_correct_cde_others a4_o linear" ///
    "app_cde1 _cons a1_c" ///
    "app_cde2 _cons a2_c" ///
    "app_cde3 _cons a3_c linear" ///
    "app_cde4 _cons a4_c linear" {
        tokenize `"`spec'"'
        local opt ""
        if "`4'" == "linear" local opt "linear"
        stashcell, model(`1') term("`2'") prefix(`3') `opt'
}

file open T27 using "$TAB/table_27_cognitive_cde.tex", write text replace
file write T27 "\begin{table}[H]" _n "\centering" _n
file write T27 "\caption{Cognitive ability, truth-telling, and outcomes (blocks CDE)}" _n
file write T27 "\label{tab:cognitive_cde}" _n "\small" _n
file write T27 "\begin{tabular}{l cc cc}" _n "\toprule" _n
file write T27 "& \multicolumn{2}{c}{Truth-telling (logit)} & \multicolumn{2}{c}{Assigned rank (OLS)} \\" _n
file write T27 "\cmidrule(lr){2-3} \cmidrule(lr){4-5}" _n
file write T27 "& (1) & (2) & (3) & (4) \\" _n "\midrule" _n
file write T27 "Raven & \(`a1_r_b'`a1_r_x'\) & \(`a2_r_b'`a2_r_x'\) & \(`a3_r_b'`a3_r_x'\) & \(`a4_r_b'`a4_r_x'\) \\" _n
file write T27 "& \((`a1_r_s')\) & \((`a2_r_s')\) & \((`a3_r_s')\) & \((`a4_r_s')\) \\[4pt]" _n
file write T27 "EADA & \(`a1_e_b'`a1_e_x'\) & \(`a2_e_b'`a2_e_x'\) & \(`a3_e_b'`a3_e_x'\) & \(`a4_e_b'`a4_e_x'\) \\" _n
file write T27 "& \((`a1_e_s')\) & \((`a2_e_s')\) & \((`a3_e_s')\) & \((`a4_e_s')\) \\[4pt]" _n
file write T27 "RM & \(`a1_m_b'`a1_m_x'\) & \(`a2_m_b'`a2_m_x'\) & \(`a3_m_b'`a3_m_x'\) & \(`a4_m_b'`a4_m_x'\) \\" _n
file write T27 "& \((`a1_m_s')\) & \((`a2_m_s')\) & \((`a3_m_s')\) & \((`a4_m_s')\) \\[4pt]" _n
file write T27 "sDAL & \(`a1_l_b'`a1_l_x'\) & \(`a2_l_b'`a2_l_x'\) & \(`a3_l_b'`a3_l_x'\) & \(`a4_l_b'`a4_l_x'\) \\" _n
file write T27 "& \((`a1_l_s')\) & \((`a2_l_s')\) & \((`a3_l_s')\) & \((`a4_l_s')\) \\[4pt]" _n
file write T27 "Raven \(\times\) EADA & & \(`a2_re_b'`a2_re_x'\) & & \(`a4_re_b'`a4_re_x'\) \\" _n
file write T27 "& & \((`a2_re_s')\) & & \((`a4_re_s')\) \\[4pt]" _n
file write T27 "Raven \(\times\) RM & & \(`a2_rm_b'`a2_rm_x'\) & & \(`a4_rm_b'`a4_rm_x'\) \\" _n
file write T27 "& & \((`a2_rm_s')\) & & \((`a4_rm_s')\) \\[4pt]" _n
file write T27 "Raven \(\times\) sDAL & & \(`a2_rl_b'`a2_rl_x'\) & & \(`a4_rl_b'`a4_rl_x'\) \\" _n
file write T27 "& & \((`a2_rl_s')\) & & \((`a4_rl_s')\) \\[4pt]" _n
file write T27 "\(\overline{\mathrm{Raven}}_{-i}\) & & & \(`a3_o_b'`a3_o_x'\) & \(`a4_o_b'`a4_o_x'\) \\" _n
file write T27 "& & & \((`a3_o_s')\) & \((`a4_o_s')\) \\[4pt]" _n
file write T27 "Constant & \(`a1_c_b'`a1_c_x'\) & \(`a2_c_b'`a2_c_x'\) & \(`a3_c_b'`a3_c_x'\) & \(`a4_c_b'`a4_c_x'\) \\" _n
file write T27 "& \((`a1_c_s')\) & \((`a2_c_s')\) & \((`a3_c_s')\) & \((`a4_c_s')\) \\" _n
file write T27 "\midrule" _n "\(N\) & 432 & 432 & 432 & 432 \\" _n "\bottomrule" _n
file write T27 "\end{tabular}" _n "\vspace{4pt}" _n
file write T27 "{\footnotesize Notes: Raven denotes the total score on blocks C, D and E. Treatment sDA is excluded due to missing block D and E data. Columns (1)--(2) report logit coefficients with standard errors in parentheses; columns (3)--(4) report OLS estimates with standard errors clustered at the market level in parentheses. \(^{*}p<0.10\), \(^{**}p<0.05\), \(^{***}p<0.01\). DA is the reference category. \(\overline{\mathrm{Raven}}_{-i}\) is included only in the rank regressions, as it should not affect one's truth-telling decision.}" _n
file write T27 "\end{table}" _n
file close T27

display as result "Cognitive tables 17 and 27 exported."
