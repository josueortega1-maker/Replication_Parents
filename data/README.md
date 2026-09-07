# Restricted participant input

The public repository intentionally does not distribute `analysis_input.csv`.

Authorized users should copy the deidentified 540-row file to:

```text
data/analysis_input.csv
```

Then verify it from the repository root:

```bash
sha256sum -c verification/restricted_data.sha256
```

Expected structure: 540 observations, 38 columns, 30 markets, 18 participants per market, and 108 observations in each of DA, EADA, RM, sDA, and sDAL. The complete variable dictionary is in `../DATA_DICTIONARY.md`.

The file contains participant-level behavioral, demographic, ranking, and Raven-response records. Do not publish or redistribute it without the data owners' authorization.
