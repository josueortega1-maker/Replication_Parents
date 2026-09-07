# Data dictionary

The input file `data/analysis_input.csv` has one observation per participant.

| Variable | Description |
|---|---|
| `participant_id` | Arbitrary sequential participant identifier |
| `market_id` | Arbitrary sequential 18-person experimental market and inference cluster |
| `id_in_group` | Induced participant type, 1–18 |
| `parents` | Parent-subject indicator |
| `da`, `eada`, `rm` | Source treatment indicators |
| `low_stakes` | Low-stakes student-treatment indicator |
| `truthful` | Complete induced ranking submitted |
| `own_rank` | Assigned-school rank under induced preferences; lower is better |
| `choices_c` | Recorded Raven item paths for block C |
| `choices_d` | Recorded Raven item paths for block D |
| `choices_e` | Recorded Raven item paths for block E |

Generated variables include the five-category `mechanism`, block scores `correct_c`, `correct_d`, and `correct_e`, the CDE mean `correct_cde`, and leave-one-out market means used in the rank regressions.

