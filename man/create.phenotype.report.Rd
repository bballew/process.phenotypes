% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_phenotype_report.R
\name{create.phenotype.report}
\alias{create.phenotype.report}
\title{Create markdown report summarizing phenotype data and cleaning process}
\usage{
create.phenotype.report(
  in.filename,
  dataset.yaml,
  shared.model.yaml,
  out.filename,
  quote = "",
  sep = "\\t",
  uniq.var.inclusion.prop = 1/3,
  write.tsv = TRUE,
  write.stata = FALSE,
  write.spss = FALSE,
  write.sas = FALSE,
  write.yaml = FALSE
)
}
\arguments{
\item{in.filename}{Character vector filename of input phenotype data.}

\item{dataset.yaml}{character vector filename of the yaml-format configuration
data for the dataset.}

\item{shared.model.yaml}{Character vector filename of the yaml configuration
for shared model specifications used by the dataset configuration.}

\item{out.filename}{Character vector filename of output report html file.}

\item{quote}{Character vector used to quote string tokens in input phenotypes,
and passed to read.table. Defaults to NULL. This parameter is exposed for
greater compability with unpredictable input formats (see Details).}

\item{sep}{Character vector used to delimit input fields in input phenotypes,
and passed to read.table. Defaults to tab (\\t). This parameter is exposed for
greater compatibility with unpredictable input formats (see Details).}

\item{uniq.var.inclusion.prop}{Numeric proportion of total values of a string
variable that can be unique before tabular output is automatically suppressed
from the output report. If set to a value greater than 1, all variables are
reported; if set below 0, all variable reporting is suppressed.}

\item{write.tsv}{Logical indicating whether to emit output phenotype data in tsv
tab-delimited plaintext. This is the primary intended output control for the
function, and should probably be set to TRUE.}

\item{write.stata}{Logical indicating whether to emit output phenotype data in
STATA .dta format. This method was added experimentally in order to provide
useful output formats for users of other statistical languages, and is subject
to modification based on downstream user feedback.}

\item{write.spss}{Logical indicating whether to emit output phenotype data
in SPSS .zsav format. This method was added experimentally in order to provide
useful output formats for users of other statistical languages, and is subject
to modification based on downstream user feedback.}

\item{write.sas}{Logical indicating whether to emit output phenotype data
in SAS .sas7bdat format, along with a source .sas file that needs to be run to
assign category levels and types. This method was added experimentally in order
to provide useful output formats for users of other statistical languages,
and is subject to modification based on downstream user feedback.}

\item{write.yaml}{Logical indicating whether to emit final version of stored
configuration data in YAML format. In addition to general recordkeeping, the
goal of this output is to provide a configuration file that can be used to
reload the output tsv back into process.phenotypes.}
}
\description{
Given phenotype information in a text file and configuration information
in yaml format, this function runs the primary cleaning logic of the
package, aggregates summary information about the cleaning process,
emits the cleaned data in one of various output formats, and summarizes
the cleaning process in an html report.
}
\details{
This function is the main entry point for phenotype data cleaning.
The primary cleaning process proceeds as follows:
\itemize{
\item load dataset and shared model configuration
\item load phenotype data
\item map phenotype headers based on input configuration
\itemize{
\item errors about mismatching column headers are detected here, and
generally indicate desync between input configuration and dataset.
this is particularly problematic with iterative runs of SurveyCTO
data, where columns get injected into the output based on the
number of responses to repeat variables.
}
\item make all inputs lowercase
\item remove superfluous whitespace
\item collapse certain types of character repeats
\item apply mappings of Unicode characters to more widely tolerated representations.
\itemize{
\item this is a particularly meaningful step for some datasets. if you're curious
about the kinds of chaos we've encountered in datasets, feel free to look
at system.file("unicode_pattern_replacements.tsv", package = "process.phenotypes")
}
\item exclude patterns matching known Excel error codes.
\itemize{
\item this processing step will be specifically reported in the output report
as a possible indicator of data malformation. Excel (Calc, Sheets, etc.) should generally not
be used to process biological data at any step. for more information on why,
please see \url{https://www.nature.com/articles/d41586-021-02211-4}.
}
\item detect remaining Unicode characters
\itemize{
\item these are reported in the cleaning report html. Unicode characters
are permitted in the output dataset, but in general we've found that
their inclusion is often erroneous, and may potentially conflict with
harmonization of responses across multiple subjects. if Unicode characters
are reported in your cleaning report, please consider extending the mapping
data mentioned above to improve the cleaning process.
}
\item remove certain nonword characters
\item normalize missing data based on recognized patterns
\item apply consent inclusion and exclusion, if configured
\item normalize missing data based on user-configured patterns
\item apply type conversions based on user-configured types
\item apply age exclusion
\item remove subjects with empty subject IDs
\item apply user-configured bounds to numeric variables
\item if \code{subject_ancestry = TRUE} is found for any variables in the user configuration,
apply heuristic harmonization with backend annotations
\itemize{
\item this is currently configured to run versus an \emph{ad hoc} set of Nigerian
ancestry groups, and should not be used in other cases without first
creating a reference list and adding it to the package. if there's sufficient
interest, this methodology may be expanded and improved
}
\item if \code{derived} block is present in user configuration, create derived
variables from cleaned primary variables
\item apply bounds on derived numeric variables
\item check user-configured dependencies between variables
\item if dependency failures were detected, apply user-configured handling on failures
\item aggregate summary information about: distributions, NA conversions, etc., for html report
\item remove subjects that fail NA rate limits
\itemize{
\item this is not much used currently, but is intended to flag truly toxic
subjects that may in fact represent catastrophic row or column shifts in
the input data. please be extremely cautious if any input subjects are removed
based on this criterion
}
\item emit cleaning report as html
\item if requested, emit configuration data in yaml format
\item if requested, emit cleaned data as tsv or in formats for other stats languages
}

The actual functionality and configuration in this package is extensive and frequently
expanding. Full details on exactly what cleaning is performed and available
configuration options for the input data are available at
\url{https://54geneprocessphenotypes.readthedocs.io/en/latest/}
}
\examples{
## create.phenotype.report operates on input files, which can be constructed
## from dataframes and lists in R if desired.
input.phenotypes <- tempfile("cpr.input.data", fileext = ".tsv")
input.dataset.yaml <- tempfile("cpr.input.data", fileext = ".dataset.yaml")
input.shared.models <- tempfile("cpr.input.data", fileext = ".shared_models.yaml")
output.html <- tempfile("cpr.output.data", fileext = ".html")
## a minimal dataset has to contain at least a subject ID column and
## a subject age column. everything else is optional.
pheno.data <- data.frame(
  var1 = c("A", "B", "C", "D", "E"),
  var2 = 16:20,
  var3 = sample(c("yes", "no"), 5, replace = TRUE)
)
var.summary <- list(
  tag = "HW",
  globals = list(
    consent_inclusion_file = NULL,
    consent_exclusion_file = NULL,
    max_invalid_datatypes_per_subject = 10,
    min_age_for_inclusion = 18
  ),
  variables = list(
    HW00001 = list(
      name = "var1",
      type = "string",
      suppress_reporting = TRUE,
      subject_id = TRUE
    ),
    HW00002 = list(
      name = "var2",
      type = "numeric",
      subject_age = TRUE
    ),
    HW00003 = list(
      name = "var3",
      shared_model = "yesno"
    )
  )
)
shared.models <- list(models = list("yesno" = list(
  type = "categorical",
  levels = list(
    "1" = list(name = "no"),
    "2" = list(name = "yes")
  )
)))
write.table(pheno.data, input.phenotypes,
  row.names = FALSE,
  col.names = TRUE, quote = TRUE, sep = "\t"
)
yaml::write_yaml(var.summary, input.dataset.yaml)
yaml::write_yaml(shared.models, input.shared.models)
## output datasets take their output prefix from the filename provided for the html report,
## so for example purposes the other output formats are suppressed.

\dontrun{
create.phenotype.report(input.phenotypes,
  input.dataset.yaml,
  input.shared.models,
  output.html,
  sep = "\t",
  quote = "\"",
  write.tsv = FALSE
)
}
}
