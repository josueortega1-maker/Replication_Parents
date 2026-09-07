# Experimental School Choice with Parents — Cognitive Results Replication

Stata replication files for the cognitive-ability results in **“Experimental School Choice with Parents”** by Mikhail Freer, Thilo Klein and Josué Ortega.

## Quick start

Requires **Stata 18 or later** and the `estout` package:

```stata
ssc install estout
cd "PATH/TO/Replication_Parents"
do 00_master.do
```

The master script constructs both Raven measures from the recorded item responses, estimates the eight manuscript models, exports the two LaTeX table fragments and checks the results against independently verified numerical targets.

## Scope

This package reproduces:

- Main cognitive table: Raven block C, all five treatments, `N = 540`.
- Appendix cognitive table: mean score across blocks C, D and E, excluding `sDA`, `N = 432`.

The logit models use conventional maximum-likelihood standard errors. The assigned-rank OLS models use standard errors clustered by the 18-person experimental market. DA is the reference treatment in every model.

## Structure

```text
00_master.do
code/
  01_prepare_data.do
  02_cognitive_results.do
  03_validation.do
data/
  analysis_input.csv
output/
  data/
  tables/
  logs/
verification/
  verified_targets.csv
DATA_DICTIONARY.md
```

## Outputs

- `output/data/analysis_sample.dta`: constructed analysis data.
- `output/tables/table_cognitive_main.tex`: main block-C table.
- `output/tables/table_cognitive_cde.tex`: appendix CDE table.
- `output/logs/replication.log`: complete Stata run log.

## Data protection

The input contains only variables required for these models. Names, email addresses, recruitment records, IP addresses, payment identifiers and platform credentials have been excluded. Participant and market identifiers are arbitrary sequential numbers.

## Important scaling detail

The appendix measure is

```text
(correct C + correct D + correct E) / 3
```

rather than the raw 36-item total. Omitting this division changes Raven coefficients and standard errors by a factor of three.

