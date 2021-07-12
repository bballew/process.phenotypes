# process.phenotypes: automated phenotype standardization and reporting

## Overview

This is an R package designed to help the process of phenotype
dataset cleaning be automated, rigorous, and transparent. The overall
cleaning process is simplified as follows:

- a phenotype spreadsheet is exported to .tsv (plaintext, tab-delimited).
- the phenotype dataset is configured in 
[YAML](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
format. this allows the user to specify the expected data format
(binary, categorical, ordinal, numeric, date, blood pressure, string), boundary conditions
for numeric values, levels and alias for binary/categorical/ordinal variables,
special values to be encoded as NA (missing) entries, and other restrictions.
- the entire cleaning process for the file is run with a single R command.
- after cleaning is complete, an html format report is emitted, reporting 
summary statistics and data cleaning observations (e.g. invalid values detected
for categorical variables); this file is both for recordkeeping and for helping
the user improve configuration for more refined cleaning.

## Installation

### Direct Installation from GitLab

R has the capacity to install packages directly from GitLab.

Run the following in [R](https://www.r-project.org/) or [RStudio](https://www.rstudio.com/):

```
# the following step is only required if you don't have the 'devtools' package installed yet
install.packages("devtools")
# the following steps are always required when launching R
library(devtools)
devtools::install_gitlab("data-analysis5/process.phenotypes@string_cleanup", auth_token = devtools::github_pat())
```

#### **Note: Secured Access to GitLab**

For security reasons, R must be permitted access to GitLab
in order to allow remote installation. Please follow the instructions
[here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
to generate an access token with at least `read_api` access.

The convention in R is to set the access token to the "GITHUB_PAT" environment
variable (note that this is **GITHUB_PAT** even though the access is via GitLab;
this is a strange R quirk). You can do this by including the line

`GITHUB_PAT = YOURACCESSTOKEN`

in your R environment file "~/.Renviron". Alternatively, you can directly enter
the access token into the following command, but this is not considered a secure behavior.

### Alternative: Installation from Local Copy

There are various ways to install an R package from a local copy of the project.

#### **With a tarball**

The easiest way to get a tarball (`.tar.gz`) compressed version of the package is
to go to the [project GitLab page](https://gitlab.com/data-analysis5/process.phenotypes),
click the download button (to the left of the `Clone` button), select `tar.gz` as
output format, and save it somewhere on the local drive.

Then, choose one of the following methods:
- on the command line: `R CMD INSTALL /path/to/process.phenotypes-default.tar.gz`; or
- from RStudio: `Tools -> Install Packages -> Install from: Package Archive File`,
and select the tarball from your local drive.

### Alternative: Installation from Conda (OSX and Linux only)

Note: this option will only be available slightly after this README goes live, and at that
time this message will be removed.

This package has been added to the 54gene [Conda](https://docs.conda.io/en/latest/) channel.
To install, first install and configure [miniconda](https://docs.conda.io/en/latest/miniconda.html).
Then add the following to your `~/.condarc` (creating the file if it does not already exist):

```
channels:
  - https://gitlab.com/data-analysis5/conda-54gene/-/raw/default/conda-54gene
```

From the command line, execute the following command:

`conda install r-process.phenotypes`

## Execution

First, load the library in the current R instance:

`library(process.phenotypes)`

The entry point for the software is `process.phenotypes::create.phenotype.report`. 
You can get useful help documentation for this function
in the usual R manner: `?process.phenotypes::create_phenotype.report`. An example
run command might be:

```{r}
process.phenotypes::create.phenotype.report("/path/to/CV.export.tsv",
                                            "CV",
                                            "yaml-configuration/CV.yaml",
                                            "yaml-configuration/shared-models.yaml",
                                            "/path/to/CV-output.html")
```

## YAML Configuration

## Future Development Targets

### Imminent
- derived variables, using format similar to dependency specification
- expanded README documentation
- improved report format, because whoa

### Longer Term
- action to take upon dependency failure
- data export formats
  - plaintext/tsv
  - STATA
  - SAS?

### Open Proposals
- aliased variable transformations
  - alternatively, can use derived variables explicitly

## Version History
 * 12 Jul 2021: string_cleanup branch merged into default; v0.1.0
