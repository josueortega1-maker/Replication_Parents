/**********************************************************************
 02_cognitive_results.do

 Reproduces the four models in the main cognitive-ability table and the
 four models in the CDE appendix table.

 Logit models use conventional maximum-likelihood standard errors, as in
 the manuscript. OLS models cluster standard errors by 18-person market.
 DA is the omitted treatment throughout.
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

/* Appendix: blocks CDE, excluding sDA because D/E were not recorded. */
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

/* Export manuscript-ready fragments. Requires the standard estout package. */
capture which esttab
if _rc {
    display as error "Install estout once with: ssc install estout"
    exit 499
}

esttab main_c1 main_c2 main_c3 main_c4 using "$TAB/table_cognitive_main.tex", ///
    replace booktabs fragment label b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("(1)" "(2)" "(3)" "(4)") ///
    keep(correct_c 2.mechanism_id 3.mechanism_id 4.mechanism_id ///
         5.mechanism_id 2.mechanism_id#c.correct_c ///
         3.mechanism_id#c.correct_c 4.mechanism_id#c.correct_c ///
         5.mechanism_id#c.correct_c mean_correct_c_others _cons) ///
    order(correct_c 2.mechanism_id 3.mechanism_id 4.mechanism_id ///
          5.mechanism_id 2.mechanism_id#c.correct_c ///
          3.mechanism_id#c.correct_c 4.mechanism_id#c.correct_c ///
          5.mechanism_id#c.correct_c mean_correct_c_others _cons) ///
    coeflabels(correct_c "Raven" 2.mechanism_id "EADA" ///
        3.mechanism_id "RM" 4.mechanism_id "sDA" ///
        5.mechanism_id "sDAL" ///
        2.mechanism_id#c.correct_c "Raven x EADA" ///
        3.mechanism_id#c.correct_c "Raven x RM" ///
        4.mechanism_id#c.correct_c "Raven x sDA" ///
        5.mechanism_id#c.correct_c "Raven x sDAL" ///
        mean_correct_c_others "Mean Raven of others" _cons "Constant") ///
    stats(N, fmt(0) labels("Observations")) nonotes

esttab app_cde1 app_cde2 app_cde3 app_cde4 using "$TAB/table_cognitive_cde.tex", ///
    replace booktabs fragment label b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("(1)" "(2)" "(3)" "(4)") ///
    keep(correct_cde 2.mechanism_id 3.mechanism_id 5.mechanism_id ///
         2.mechanism_id#c.correct_cde 3.mechanism_id#c.correct_cde ///
         5.mechanism_id#c.correct_cde mean_correct_cde_others _cons) ///
    order(correct_cde 2.mechanism_id 3.mechanism_id 5.mechanism_id ///
          2.mechanism_id#c.correct_cde 3.mechanism_id#c.correct_cde ///
          5.mechanism_id#c.correct_cde mean_correct_cde_others _cons) ///
    coeflabels(correct_cde "Raven" 2.mechanism_id "EADA" ///
        3.mechanism_id "RM" 5.mechanism_id "sDAL" ///
        2.mechanism_id#c.correct_cde "Raven x EADA" ///
        3.mechanism_id#c.correct_cde "Raven x RM" ///
        5.mechanism_id#c.correct_cde "Raven x sDAL" ///
        mean_correct_cde_others "Mean Raven of others" _cons "Constant") ///
    stats(N, fmt(0) labels("Observations")) nonotes

display as result "Main and appendix cognitive tables exported."

