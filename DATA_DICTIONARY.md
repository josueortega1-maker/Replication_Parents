# Data dictionary

## Participant input

`data/analysis_input.csv` contains one row per participant (`N=540`). It is required by the Stata code but is **not distributed in the public repository**. Authorized users should follow `data/README.md`.

| Variable | Description |
|---|---|
| `participant_id` | Arbitrary sequential participant identifier |
| `market_id` | Arbitrary sequential 18-person market; cluster identifier |
| `id_in_group` | Fixed induced type, 1–18 |
| `parents` | Parent-subject indicator |
| `da`, `eada`, `rm` | Source treatment indicators |
| `low_stakes` | Low-stakes student-treatment indicator |
| `ranking1`–`ranking7` | Submitted schools, best to worst |
| `true_pref1`–`true_pref7` | Induced schools, best to worst |
| `truthful_recorded` | Recorded complete truth-telling indicator, used only to cross-check the reconstructed value |
| `first_diff_recorded` | Recorded first differing position, used only as a reconstruction cross-check |
| `assigned_school` | Assigned school |
| `own_rank` | Assigned school's rank under induced preferences |
| `rank_own_truth` | Counterfactual true rank if this participant alone reported truthfully; defined for misreporters |
| `time_spent_quiz` | Quiz duration in seconds |
| `quiz_attempts` | Number of quiz attempts |
| `choices_c`, `choices_d`, `choices_e` | Recorded Raven answer-image paths for 12-item blocks C, D, E |
| `age` | Reported age after the archived cleaning rule (`1990` interpreted as birth year 1990; values over 90 missing) |
| `female` | Female indicator; missing when gender is missing |
| `children_past_primary` | Number of children past primary-school age |
| `working_hours` | Weekly working hours |
| `marital_code` | Original numeric marital-status category; retained to diagnose the published benchmark discrepancy |
| `raven_score_recorded` | Recorded C+D+E correct total, used only to cross-check item-level scoring |

`code/01_prepare_data.do` constructs `mechanism`, `truthful`, `first_diff`, quiz indicators, Raven block scores, the CDE mean, leave-one-out market Raven scores, obvious mistakes, manipulation rank effects, and skipping/inflating indicators.

## Other inputs

| File | Purpose |
|---|---|
| `literature.csv` | Rows of the literature-review table |
| `preferences.csv` | Fixed induced preferences for 18 roles |
| `priorities.csv` | Fixed school priorities for 18 roles and 7 schools |
| `published_first_deviation_rates.csv` | Literal manuscript display rates for Table 24; underlying counts are reconstructed and validated |
| `population_benchmarks.csv` | Published sample/BHPS/Census benchmark cells |
| `truthful_design_properties.csv` | DA/EADA/RM truthful-design calculation snapshot for Table 20 |
| `published_descriptive_overrides.csv` | Explicitly documented manuscript/current-data or display discrepancies |
| `published_rm_counterfactuals.csv` | Published primary and all-optimum RM counterfactual results |
| `published_simulation_results.csv` | Published recombinant estimates used in Tables 14–16 and 26 |

Files prefixed `published_*` are deliberately provenance-marked snapshots, not raw experimental observations.
