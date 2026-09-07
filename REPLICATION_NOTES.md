# Replication notes and source discrepancies

This file records every place where the supplied author folder does not support a clean from-raw rerun of the literal manuscript cell. The Stata code preserves the manuscript output and makes the exception machine-visible.

## 0. Public repository is code-only

The public GitHub repository omits `data/analysis_input.csv`. Although direct identifiers were removed, it contains participant-level behavioral, demographic, ranking, and cognitive-response records. Authorized users can place the file locally and verify it against `verification/restricted_data.sha256`; the master script then runs without modification.

## 1. Recombinant estimator source is absent

Tables 14–16 and 26 depend on the paper's Mullin–Reiley recombinant estimator. The supplied files include `inference_v2.R`, which explicitly calls `recombinant_estimator_v2.R`, but neither that estimator nor its draw-level output is present. The folder and the author's accessible GitHub repositories were searched for the missing file.

Accordingly, `data/published_simulation_results.csv` records the estimates printed in the manuscript, and `code/04_published_simulation_tables.do` turns that provenance-marked snapshot into the four LaTeX tables. These are exact table-generation replications, not independent re-simulations. A future complete computational archive should add the missing estimator, random seed, software versions, and draw-level or block-level output.

## 2. RM counterfactual tie-breaking output is absent

Tables 12–13 compare each observed report with the outcome when that participant alone reports truthfully. Rank minimization can have multiple optimal allocations. The current participant file implies 59 consequential RM reports under its stored selected optimum, while the manuscript reports 51 for the primary tie-breaking rule and 68 averaged over all rank-minimizing allocations. The exact primary/all-optimum output used for the paper is not in the supplied folder.

Non-RM cells are reconstructed from participant records. RM cells come from the explicitly named `published_rm_counterfactuals.csv` snapshot and preserve both manuscript variants. Table 20's truthful RM property row also uses the supplied-design calculation snapshot because alternative rank-minimizing optima have the same rank sum but different rank profiles and justified-envy counts.

## 3. Published married share is not supported by the current merged file

Table 8 reports 47% married among parents. In the supplied 540-row merged file, marital category 2—the category used as married in the archived analysis—contains 234 of 319 nonmissing parent responses (73.4%). No coding of the current categories naturally reproduces 47%. The table retains the published 47% alongside the published BHPS/Census benchmarks. The discrepancy is recorded in `published_descriptive_overrides.csv` rather than hidden in code.

## 4. One age cell differs by 0.1

After applying the archived age-cleaning rule, the supplied sDAL data have mean age 20.648, which formats to 20.6 at one decimal. Table 7 reports 20.7. The output preserves the published 20.7 via `published_descriptive_overrides.csv`; every other Table 7 cell is generated directly from the current deidentified records.

## 5. Skipping-down prose and archived code differ

The appendix prose defines skipping down as demoting at least one of A/B while promoting neither. In the archived R code, the “neither promoted” condition is commented out. The reported Table 25 cells match that lenient code exactly:

| Definition | DA | EADA | RM | sDA | sDAL |
|---|---:|---:|---:|---:|---:|
| Published/archived-code | 0.06 | 0.08 | 0.12 | 0.20 | 0.20 |
| Strict prose | 0.03 | 0.03 | 0.06 | 0.11 | 0.10 |

The main output follows the published code. The master run also writes `output/data/skipping_definition_diagnostic.csv` with both definitions.

## 6. First-deviation display cells do not follow uniform rounding

The underlying Table 24 counts are reconstructed and validated (for example, 46/80 for DA position 1 and 5/89 for sDAL position 4+). The manuscript's displayed rates do not follow one conventional rounding rule across exact-half cases and include 0.05 for 5/89. The literal display matrix is therefore stored in `published_first_deviation_rates.csv`; all 20 underlying numerator checks remain data-driven.

## 7. Main and appendix EADA illustrations are not identical

The manuscript repeats the EADA step tables, but the priority/order entries in Tables 4–5 differ from those in Tables 22–23. The replication package generates each table separately and preserves the literal version at each manuscript location.

## 8. Recombinant draw-count wording

The main mechanism-summary note says “10,000 recombinant draws per treatment.” The appendix method description specifies 10,000 draws for each `(session, fixed-role)` block. With 6 sessions and 18 roles, that is 1,080,000 synthetic markets per mechanism. The package preserves the table note verbatim; a future estimator archive should resolve the wording.

## 9. Raven CDE scale and sDA exclusion

The CDE coefficients reproduce only when the 36-item total is divided by 3, yielding mean correct answers per 12-item block. The appendix prose calls this a “total score,” which can be read differently. The effective regression scale is `(C+D+E)/3`. sDA is excluded because D/E responses are incomplete, leaving `N=432`.
