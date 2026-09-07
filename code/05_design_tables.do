/**********************************************************************
 05_design_tables.do

 Generates all non-estimated literature, example, experimental-design,
 algorithm-illustration and truthful-design-property tables.
**********************************************************************/

version 18

/* ---------- Table 1: experimental literature ---------- */
import delimited using "$DATA/literature.csv", clear varnames(1) stringcols(_all)
destring order, replace
sort order

file open T01 using "$TAB/table_01_literature.tex", write text replace
file write T01 "\begin{table}[t]" _n
file write T01 "\caption{Experimental School Choice Literature.}" _n
file write T01 "\label{tab:literature1}" _n "\resizebox{\linewidth}{!}{%" _n
file write T01 "\begin{tabular}{llr}" _n "\toprule" _n
file write T01 "Study & Mechanisms & Participants \\" _n "\midrule" _n
forvalues i = 1/`=_N' {
    local ck = citekey[`i']
    local mm = mechanisms[`i']
    local pp = participants[`i']
    file write T01 "\citet{`ck'} & `mm' & `pp' \\" _n
}
file write T01 "\midrule" _n
file write T01 "\textbf{This paper} & \textbf{DA, EADA, RM} & \textbf{324 parents (+ 216 students)} \\" _n
file write T01 "\bottomrule" _n "\end{tabular}}" _n "\end{table}" _n
file close T01

/* ---------- Table 2: four-student example ---------- */
file open T02 using "$TAB/table_02_example.tex", write text replace
file write T02 "\begin{table}[H]" _n "\centering" _n
file write T02 "\caption{A school choice problem with four students and four schools.}" _n
file write T02 "\label{tab:example}" _n "\begin{tabular}{ccccccccc}" _n
file write T02 "\multicolumn{4}{c}{\textbf{Preferences}} & \phantom{xxx} & \multicolumn{4}{c}{\textbf{Priorities}} \\" _n
file write T02 "\cmidrule(r){1-4}\cmidrule(l){6-9}" _n
file write T02 "\(i_1\) & \(i_2\) & \(i_3\) & \(i_4\) & & \(s_1\) & \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T02 "\(s_2\) & \(s_2\) & \(s_4\) & \(s_4\) & & \(i_1\) & \(i_4\) & \(i_2\) & \(i_1\) \\" _n
file write T02 "\(s_3\) & \(s_4\) & \(s_3\) & \(s_3\) & & \(i_4\) & \(i_3\) & \(i_1\) & \(i_2\) \\" _n
file write T02 "\(s_1\) & \(s_3\) & \(s_2\) & \(s_2\) & & \(i_3\) & \(i_1\) & \(i_4\) & \(i_4\) \\" _n
file write T02 "\(s_4\) & \(s_1\) & \(s_1\) & \(s_1\) & & \(i_2\) & \(i_2\) & \(i_3\) & \(i_3\) \\" _n
file write T02 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T02

/* ---------- Table 3: DA rounds in the main text ---------- */
file open T03 using "$TAB/table_03_da_rounds_main.tex", write text replace
file write T03 "\begin{table}[h!]" _n "\centering" _n
file write T03 "\caption{DA proposal rounds (tentative holders shown; rejections in bold).}" _n
file write T03 "\label{tab:rejectionsDA}" _n "\begin{tabular}{ccccc}" _n "\toprule" _n
file write T03 "& \(s_1\) & \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T03 "Round 1 & & \(i_1,\mathbf{i_2}\) & & \(\mathbf{i_3},i_4\) \\" _n
file write T03 "Round 2 & & \(i_1\) & \(i_3\) & \(i_2,\mathbf{i_4}\) \\" _n
file write T03 "Round 3 & & \(i_1\) & \(\mathbf{i_3},i_4\) & \(i_2\) \\" _n
file write T03 "Round 4 & & \(\mathbf{i_1},i_3\) & \(i_4\) & \(i_2\) \\" _n
file write T03 "Round 5 & & \(i_3\) & \(i_1,\mathbf{i_4}\) & \(i_2\) \\" _n
file write T03 "Round 6 & & \(\mathbf{i_3},i_4\) & \(i_1\) & \(i_2\) \\" _n
file write T03 "Round 7 & \(i_3\) & \(i_4\) & \(i_1\) & \(i_2\) \\" _n
file write T03 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T03

/* ---------- Tables 4--5: EADA steps in the main text ---------- */
file open T04 using "$TAB/table_04_eada_step2_main.tex", write text replace
file write T04 "\begin{table}[h!]" _n
file write T04 "\caption{Second step in EADA: reduced preferences (left) and DA rounds (right).}" _n
file write T04 "\label{tab:seada1}" _n "\begin{minipage}{.52\linewidth}" _n "\centering" _n
file write T04 "\begin{tabular}{ccccccc}" _n "\toprule" _n
file write T04 "\(i_1\) & \(i_2\) & \(i_4\) & & \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T04 "\(s_2\) & \(s_2\) & \(s_4\) & & \(i_4\) & \(i_2\) & \(i_1\) \\" _n
file write T04 "\(s_3\) & \(s_4\) & \(s_3\) & & \(i_1\) & \(i_1\) & \(i_2\) \\" _n
file write T04 "\(s_4\) & \(s_3\) & \(s_2\) & & \(i_2\) & \(i_4\) & \(i_4\) \\" _n
file write T04 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}\hfill%" _n
file write T04 "\begin{minipage}{.44\linewidth}" _n "\centering" _n "\begin{tabular}{cccc}" _n "\toprule" _n
file write T04 "& \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T04 "Round 1 & \(i_1,\mathbf{i_2}\) & & \(i_4\) \\" _n
file write T04 "Round 2 & \(i_1\) & & \(i_2,\mathbf{i_4}\) \\" _n
file write T04 "Round 3 & \(i_1\) & \(i_4\) & \(i_2\) \\" _n
file write T04 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}" _n "\end{table}" _n
file close T04

file open T05 using "$TAB/table_05_eada_step3_main.tex", write text replace
file write T05 "\begin{table}[h!]" _n
file write T05 "\caption{Third step in EADA: reduced problem (left) and DA rounds (right).}" _n
file write T05 "\label{tab:seada2}" _n "\begin{minipage}{.52\linewidth}" _n "\centering" _n
file write T05 "\begin{tabular}{ccccc}" _n "\toprule" _n
file write T05 "\(i_1\) & \(i_2\) & & \(s_2\) & \(s_4\) \\" _n "\midrule" _n
file write T05 "\(s_2\) & \(s_2\) & & \(i_1\) & \(i_1\) \\" _n
file write T05 "\(s_4\) & \(s_4\) & & \(i_2\) & \(i_2\) \\" _n
file write T05 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}\hfill%" _n
file write T05 "\begin{minipage}{.44\linewidth}" _n "\centering" _n "\begin{tabular}{ccc}" _n "\toprule" _n
file write T05 "& \(s_2\) & \(s_4\) \\" _n "\midrule" _n
file write T05 "Round 1 & \(i_1,\mathbf{i_2}\) & \\" _n
file write T05 "Round 2 & \(i_1\) & \(i_2\) \\" _n
file write T05 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}" _n "\end{table}" _n
file close T05

/* ---------- Table 6: payoffs ---------- */
file open T06 using "$TAB/table_06_payoffs.tex", write text replace
file write T06 "\begin{table}[H]" _n "\centering" _n
file write T06 "\caption{Payoffs in the experiment (half for the low-stakes treatment).}" _n
file write T06 "\label{tab:payoffs}" _n "\begin{tabular}{lccccccc}" _n "\toprule" _n
file write T06 "School rank & 1 & 2 & 3 & 4 & 5 & 6 & 7 \\" _n "\midrule" _n
file write T06 "Payoff (\pounds) & 55 & 40 & 30 & 20 & 10 & 5 & 2 \\" _n
file write T06 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T06

/* ---------- Table 18: induced preferences ---------- */
import delimited using "$DATA/preferences.csv", clear varnames(1) stringcols(_all)
destring student_id, replace
sort student_id
assert _N == 18

file open T18 using "$TAB/table_18_preferences.tex", write text replace
file write T18 "\begin{table}[H]" _n "\centering" _n
file write T18 "\caption{Preferences used in the experiment.}" _n "\label{tab:preferences}" _n
file write T18 "\resizebox{\textwidth}{!}{%" _n "\begin{tabular}{*{18}{c}}" _n "\toprule" _n
forvalues i = 1/18 {
    if `i' < 18 file write T18 "\(i_{`i'}\) & "
    if `i' == 18 file write T18 "\(i_{`i'}\) \\" _n
}
file write T18 "\midrule" _n
forvalues r = 1/7 {
    forvalues i = 1/18 {
        local school = rank`r'[`i']
        local sn = strpos("ABCDEFG", "`school'")
        if `i' < 18 file write T18 "\(s_{`sn'}\) & "
        if `i' == 18 file write T18 "\(s_{`sn'}\) \\" _n
    }
}
file write T18 "\bottomrule" _n "\end{tabular}%" _n "}" _n "\end{table}" _n
file close T18

/* ---------- Table 19: priorities ---------- */
import delimited using "$DATA/priorities.csv", clear varnames(1) stringcols(_all)
destring priority_rank a b c d e f g, replace
sort priority_rank
assert _N == 18

file open T19 using "$TAB/table_19_priorities.tex", write text replace
file write T19 "\begin{table}[H]" _n "\centering" _n
file write T19 "\caption{Priorities used in the experiment.}" _n "\label{tab:priorities1}" _n
file write T19 "\begin{tabular}{*{7}{c}}" _n "\toprule" _n
file write T19 "\(s_1\) & \(s_2\) & \(s_3\) & \(s_4\) & \(s_5\) & \(s_6\) & \(s_7\) \\" _n "\midrule" _n
forvalues r = 1/18 {
    local j = 0
    foreach school in a b c d e f g {
        local ++j
        local sid = `school'[`r']
        if `j' < 7 file write T19 "\(i_{`sid'}\) & "
        if `j' == 7 file write T19 "\(i_{`sid'}\) \\" _n
    }
}
file write T19 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T19

/* ---------- Table 20: truthful-design properties ---------- */
import delimited using "$DATA/truthful_design_properties.csv", clear varnames(1) stringcols(_all)
destring pareto_efficient justified_envy je_triples je_students rank1-rank7 rank_sum, replace
assert _N == 3

file open T20 using "$TAB/table_20_truthful_properties.tex", write text replace
file write T20 "\begin{table}[H]" _n "\centering" _n "\small" _n
file write T20 "\begin{tabular}{lcccccc}" _n "\toprule" _n
file write T20 "Mechanism & PE? & JE? & \#JE triples & \#JE students & Rank profile \(\rho\) & Avg rank \(\bar r\) \\" _n "\midrule" _n
forvalues i = 1/3 {
    local m = mechanism[`i']
    local pe = cond(pareto_efficient[`i'] == 1, "Yes", "No")
    local je = cond(justified_envy[`i'] == 1, "Yes", "No")
    local jt = je_triples[`i']
    local js = je_students[`i']
    local rs = rank_sum[`i']
    file write T20 "`m' & `pe' & `je' & \(`jt'\) & \(`js'\) & \(("
    forvalues r = 1/7 {
        local rv = rank`r'[`i']
        if `r' < 7 file write T20 "`rv',"
        if `r' == 7 file write T20 "`rv')\) & \(`rs'/18\) \\" _n
    }
}
file write T20 "\bottomrule" _n "\end{tabular}" _n
file write T20 "\caption{PE and JE refer to Pareto-efficient and justified envy. A justified-envy (JE) triple is \((i,s,j)\) with \(i\) preferring \(s\) to \(\mu(i)\) and having higher priority at \(s\) than assignee \(j\in\mu(s)\). The rank profile reports the histogram of assigned ranks.}" _n
file write T20 "\label{tab:properties1}" _n "\end{table}" _n
file close T20

/* ---------- Table 21: appendix copy of DA rounds ---------- */
file open T21 using "$TAB/table_21_da_rounds_appendix.tex", write text replace
file write T21 "\begin{table}[H]" _n "\centering" _n
file write T21 "\caption{DA proposal rounds (tentative holders shown; rejections in bold).}" _n
file write T21 "\label{tab:rejections}" _n "\begin{tabular}{ccccc}" _n "\toprule" _n
file write T21 "& \(s_1\) & \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T21 "Round 1 & & \(i_1,\mathbf{i_2}\) & & \(\mathbf{i_3},i_4\) \\" _n
file write T21 "Round 2 & & \(i_1\) & \(i_3\) & \(i_2,\mathbf{i_4}\) \\" _n
file write T21 "Round 3 & & \(i_1\) & \(\mathbf{i_3},i_4\) & \(i_2\) \\" _n
file write T21 "Round 4 & & \(\mathbf{i_1},i_3\) & \(i_4\) & \(i_2\) \\" _n
file write T21 "Round 5 & & \(i_3\) & \(i_1,\mathbf{i_4}\) & \(i_2\) \\" _n
file write T21 "Round 6 & & \(\mathbf{i_3},i_4\) & \(i_1\) & \(i_2\) \\" _n
file write T21 "Round 7 & \(i_3\) & \(i_4\) & \(i_1\) & \(i_2\) \\" _n
file write T21 "\bottomrule" _n "\end{tabular}" _n "\end{table}" _n
file close T21

/* ---------- Tables 22--23: appendix EADA illustration ---------- */
file open T22 using "$TAB/table_22_eada_step2_appendix.tex", write text replace
file write T22 "\begin{table}[H]" _n
file write T22 "\caption{Second step in EADA: reduced preferences (left) and DA rounds (right).}" _n
file write T22 "\label{tab:seada1}" _n "\begin{minipage}{.52\linewidth}" _n "\centering" _n
file write T22 "\begin{tabular}{ccccccc}" _n "\toprule" _n
file write T22 "\(i_1\) & \(i_2\) & \(i_4\) & & \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T22 "\(s_2\) & \(s_2\) & \(s_4\) & & \(i_4\) & \(i_2\) & \(i_1\) \\" _n
file write T22 "\(s_3\) & \(s_4\) & \(s_3\) & & \(i_1\) & \(i_4\) & \(i_2\) \\" _n
file write T22 "\(s_4\) & \(s_3\) & \(s_2\) & & \(i_2\) & \(i_1\) & \(i_4\) \\" _n
file write T22 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}\hfill%" _n
file write T22 "\begin{minipage}{.44\linewidth}" _n "\centering" _n "\begin{tabular}{cccc}" _n "\toprule" _n
file write T22 "& \(s_2\) & \(s_3\) & \(s_4\) \\" _n "\midrule" _n
file write T22 "Round 1 & \(i_1,\mathbf{i_2}\) & & \(i_4\) \\" _n
file write T22 "Round 2 & \(i_1\) & & \(i_2,\mathbf{i_4}\) \\" _n
file write T22 "Round 3 & \(i_1\) & \(i_4\) & \(i_2\) \\" _n
file write T22 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}" _n "\end{table}" _n
file close T22

file open T23 using "$TAB/table_23_eada_step3_appendix.tex", write text replace
file write T23 "\begin{table}[H]" _n
file write T23 "\caption{Third step in EADA: reduced problem (left) and DA rounds (right).}" _n
file write T23 "\label{tab:seada2}" _n "\begin{minipage}{.52\linewidth}" _n "\centering" _n
file write T23 "\begin{tabular}{ccccc}" _n "\toprule" _n
file write T23 "\(i_1\) & \(i_2\) & & \(s_2\) & \(s_4\) \\" _n "\midrule" _n
file write T23 "\(s_2\) & \(s_4\) & & \(i_1\) & \(i_2\) \\" _n
file write T23 "\(s_4\) & \(s_2\) & & \(i_2\) & \(i_1\) \\" _n
file write T23 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}\hfill%" _n
file write T23 "\begin{minipage}{.44\linewidth}" _n "\centering" _n "\begin{tabular}{ccc}" _n "\toprule" _n
file write T23 "& \(s_2\) & \(s_4\) \\" _n "\midrule" _n
file write T23 "Round 1 & \(i_1\) & \(i_2\) \\" _n
file write T23 "\bottomrule" _n "\end{tabular}" _n "\end{minipage}" _n "\end{table}" _n
file close T23

display as result "Literature, design and algorithm-illustration tables exported."
