# JTmethod

The goal of JTmethod is to provide a comprehensive implementation of the
[Jacobson and Truax (1991)](https://psycnet.apa.org/doiLanding?doi=10.1037%2F0022-006X.59.1.12) 
method in R. This includes the reliable change analysis, clinical significance 
assessment using Criteria A, B, C, and an empirical cutoff, and a complete 
classification of individual outcomes.

## Installation

You can install the development version of JTmethod from 
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("FranMeds/JTmethod")
```

## Example

The main function,`calc_indices`, reads participant data from a Excel workbook,
calculates the JT indices, and exports the results to a new workbook. See the
example below:

``` r
library(JTmethod)

calc_indices(
  input_path = "path/to/your/raw_data.xlsx",
  output_path = "path/to/save/your/analyzed_data.xlsx",
  expected_score_T2 = "lower",
  cutoff = 16,
  rel = 0.87
)
```

The function accepts four arguments:

- `input_path` - path ti the Excel file containing the raw data required for the JT
analysis.

- `output_path` - path and filename for teh output Excel file containing the 
calculated indices.

- `expected_score_T2` - expected direction of improvement at T2 (post-interventio).
Use `higher` when higher scores indicate improvement (e.g., social skills scales)
and `lower` when lower scores indicate improvement (e.g., depression, anxiety, 
or behavior problem scales).

- `cutoff` - criterion used to determine clinical significance. Th avaliable options 
are Criteria A, B, C or an empirical cutoff. 

- `rel` Reliability coefficient of the instrument used to collect the data. A 
reliability estimate supported by the literature and appropriate for the 
instrument should be used (see [Blampied, 2022](https://www.cambridge.org/core/product/identifier/S1754470X22000484/type/journal_article)).

## Criteria A, B, C, and Empirical Cutoff

JTmethod supports the three clinical significance criteria proposed by 
[Jacobson and Truax (1991)](https://psycnet.apa.org/doiLanding?doi=10.1037%2F0022-006X.59.1.12), 
as well as an empirical cutoff defined by the psychometric properties of the 
instrument used. Users must be explicitly state this value. As defined in the authors' original article (p. 13):

- **Criterion A** "The level of functioning subsequent to therapy should fall 
outside the range of the dysfunctional population, where range is denned as 
extending to two standard deviations beyond (in the direction of functionality) 
the mean for that population".
- **Criterion B** "The level of functioning subsequent to therapy should fall 
within the range of the functional or normal population, where range is denned 
as within two standard deviations of the mean of that population".
- **Criterion C** "The level of functioning subsequent to therapy places that 
client closer to the mean of the functional population than it does to the mean 
of the dysfunctional population".

Furthermore, we have an empirical cutoff:

- **Empirical cutoff** allows users to specify a cutoff score reported in the
instrument's manual or validation study.

An appropriate criterion should be selected according to the psychometric
properties and normative information available in the literature.

## Input File Format

The input Excel file must contain the following columns filled:

For Criterion A

| id  | T1  | T2  | mean_disf | sd_disf | mean_func | sd_func | higher_score | lower_score |
|:----|:---:|:---:|:---------:|:-------:|:---------:|:-------:|:------------:|:-----------:|
| P1  | 26  | 11  |    8.4    |   5.8   |           |         |      40      |      0      |
| P2  | 28  |  9  |    8.4    |   5.8   |           |         |      40      |      0      |
| P3  | 19  |  9  |    8.4    |   5.8   |           |         |      40      |      0      |

For Criterion B

| id  | T1  | T2  | mean_disf | sd_disf | mean_func | sd_func | higher_score | lower_score |
|:----|:---:|:---:|:---------:|:-------:|:---------:|:-------:|:------------:|:-----------:|
| P1  | 26  | 11  |           |         |    7.4    |   4.5   |      40      |      0      |
| P2  | 28  |  9  |           |         |    7.4    |   4.5   |      40      |      0      |
| P3  | 19  |  9  |           |         |    7.4    |   4.5   |      40      |      0      |

For Criterion C

| id  | T1  | T2  | mean_disf | sd_disf | mean_func | sd_func | higher_score | lower_score |
|:----|:---:|:---:|:---------:|:-------:|:---------:|:-------:|:------------:|:-----------:|
| P1  | 26  | 11  |    8.4    |   5.8   |    7.4    |   4.5   |      40      |      0      |
| P2  | 28  |  9  |    8.4    |   5.8   |    7.4    |   4.5   |      40      |      0      |
| P3  | 19  |  9  |    8.4    |   5.8   |    7.4    |   4.5   |      40      |      0      |

The choice between these three input formats depends on the reference population
used to calculate the Reliable Change Index (RCI).

Some arguments are expected:

- `id` - Participant identifier.
- `T1` - Pre-intervention score.
- `T2` - Post-intervention score.
- `mean_disf` - Mean of the dysfunctional population (required for Criteria A
and C).
- `sd_disf` - Standard deviation of the dysfunctional population (required for
Criteria A and C).
- `mean_func` - Mean of the functional population (required for Criteria B and
C).
- `sd_func` - Standard deviation of the functional population (required for
Criteria B and C).
- `higher_score` - Maximum possible score of the instrument (required only when
using an empirical cutoff).
- `lower_score` - Minimum possible score of the instrument (required only when
using an empirical cutoff).

Each dataset collected with a specific instrument should be placed in a separate
worksheet. A participant identified by the same ID may appear in multiple 
worksheets when necessary. Within a given worksheet, however, all participants 
must have data collected with the same instrument.

## Output

As expected, the function exports an Excel file containing the calculated JT 
indices for each participant. 

| id  | rc    |      confiability      |  cutoff  |  class. |
|:----|:-----:|:----------------------:|:--------:|:-------:|
| P1  | 5.28  | Reliable improvement   |    16    |   RI/R  |
| P2  | 1.89  | No reliable change     |    16    |   NRC   |
| P3  |-2,64  | Reliable deterioration |    16    |   RD/D  |

The output includes the Reliable Change Index (RCI), clinical
significance results, and the final classification of each participant according
to the [Jacobson and Truax (1991)](https://psycnet.apa.org/doiLanding?doi=10.1037%2F0022-006X.59.1.12) method.


