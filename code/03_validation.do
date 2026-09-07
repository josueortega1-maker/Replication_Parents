/**********************************************************************
 03_validation.do

 Checks every reported coefficient and standard error against independent
 targets reconstructed from the supplied R output and current manuscript.
**********************************************************************/

version 18

capture program drop checkest
program define checkest
    syntax, MODEL(name) TERM(string) B(real) SE(real) [TOL(real 0.00001)]
    estimates restore `model'
    assert abs(_b[`term'] - `b') < `tol'
    assert abs(_se[`term'] - `se') < `tol'
end

/* Main paper: block C, N = 540. */
estimates restore main_c1
assert e(N) == 540
checkest, model(main_c1) term(correct_c) b(-.104934) se(.037500)
checkest, model(main_c1) term(2.mechanism_id) b(.106117) se(.309024)
checkest, model(main_c1) term(3.mechanism_id) b(-.118483) se(.319122)
checkest, model(main_c1) term(4.mechanism_id) b(.045314) se(.313025)
checkest, model(main_c1) term(5.mechanism_id) b(-.435151) se(.337619)

estimates restore main_c2
assert e(N) == 540
checkest, model(main_c2) term(correct_c) b(-.164486) se(.084175)
checkest, model(main_c2) term(2.mechanism_id#c.correct_c) b(-.082833) se(.112284)
checkest, model(main_c2) term(3.mechanism_id#c.correct_c) b(.295893) se(.136189)
checkest, model(main_c2) term(4.mechanism_id#c.correct_c) b(.129787) se(.132948)
checkest, model(main_c2) term(5.mechanism_id#c.correct_c) b(.108640) se(.129111)

estimates restore main_c3
assert e(N) == 540
checkest, model(main_c3) term(correct_c) b(-.020962) se(.023467)
checkest, model(main_c3) term(mean_correct_c_others) b(-.052623) se(.080278)

estimates restore main_c4
assert e(N) == 540
checkest, model(main_c4) term(correct_c) b(-.072950) se(.032951)
checkest, model(main_c4) term(2.mechanism_id#c.correct_c) b(.144015) se(.054409)
checkest, model(main_c4) term(3.mechanism_id#c.correct_c) b(-.040800) se(.049347)
checkest, model(main_c4) term(4.mechanism_id#c.correct_c) b(.025522) se(.068197)
checkest, model(main_c4) term(5.mechanism_id#c.correct_c) b(.076179) se(.063452)

/* Appendix CDE: N = 432. */
estimates restore app_cde1
assert e(N) == 432
checkest, model(app_cde1) term(correct_cde) b(-.134747) se(.043616)
checkest, model(app_cde1) term(2.mechanism_id) b(.117724) se(.310408)
checkest, model(app_cde1) term(3.mechanism_id) b(-.078404) se(.321350)
checkest, model(app_cde1) term(5.mechanism_id) b(-.373244) se(.340134)

estimates restore app_cde2
assert e(N) == 432
checkest, model(app_cde2) term(correct_cde) b(-.110242) se(.082281)
checkest, model(app_cde2) term(2.mechanism_id#c.correct_cde) b(-.228080) se(.122466)
checkest, model(app_cde2) term(3.mechanism_id#c.correct_cde) b(.210120) se(.130466)
checkest, model(app_cde2) term(5.mechanism_id#c.correct_cde) b(-.005302) se(.151977)

estimates restore app_cde3
assert e(N) == 432
checkest, model(app_cde3) term(correct_cde) b(-.069688) se(.027988)
checkest, model(app_cde3) term(mean_correct_cde_others) b(-.013754) se(.083199)

estimates restore app_cde4
assert e(N) == 432
checkest, model(app_cde4) term(correct_cde) b(-.055731) se(.031525)
checkest, model(app_cde4) term(2.mechanism_id#c.correct_cde) b(.090325) se(.057455)
checkest, model(app_cde4) term(3.mechanism_id#c.correct_cde) b(-.070473) se(.047998)
checkest, model(app_cde4) term(5.mechanism_id#c.correct_cde) b(-.174149) se(.099686)

display as result "All coefficient, standard-error and sample-size checks passed."

