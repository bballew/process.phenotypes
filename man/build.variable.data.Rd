% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_surveycto.R
\name{build.variable.data}
\alias{build.variable.data}
\title{Construct variable annotation according to type information
from a SurveyCTO configuration row}
\usage{
build.variable.data(type.value, name.value, label.value, choice.list, varname)
}
\arguments{
\item{type.value}{Character vector of entry from SurveyCTO form definition "type" column.}

\item{name.value}{Character vector of entry from SurveyCTO form definition "name" column.}

\item{label.value}{Character vector of entry from SurveyCTO form definition "label" column.}

\item{choice.list}{List of shared model data for questionnaire, created from form definition
"choices" tab.}

\item{varname}{Character vector of constructed name of variable (e.g. HW00001).}
}
\value{
List with contents of variable configuration block for this variable, under
variable.summary$variables[[varname]].
}
\description{
Given a variable configuration entry from a SurveyCTO form
definition, this function attempts to construct a corresponding
basic entry in a process.phenotypes-style variable configuration
entry. Basic functionality for each type is provided (see Details);
however, it is expected that manual inspection and modifiction will
be necessary in many cases.
}
\details{
The constructed variable entry is designed to contain what we
find to be sensible default values for each output type. The
behaviors by type are as follows:
\itemize{
\item SurveyCTO types "start", "end", "deviceid", "subscriberid",
"simserial", "phonenumber", "username", "caseid", "image",
"text", "datetime": all are encoded as process.phenotypes
"string" types with NA canonical_name and suppressed reporting.
There is an argument for encoding the "datetime" type as
"date"; however, in the vast majority of instances we've
observed, datetime variables are largely there for recordkeeping
and are not actually expected to be parsed for year. In cases
where such parsing is required, a derived variable may be
more appropriate.
\item SurveyCTO type "calculate": these variables have contextually
different types, and for standardization purposes are encoded
by default as process.phenotypes "string" type. During manual
review, you will likely prefer to override this setting for
calculated variables that are, for example, truly numeric.
\item SurveyCTO type "date": process.phenotypes type "date", which
will cause them to be parsed into numeric representations of
their year component. If this behavior is not desired, be sure
to override this setting during manual review.
\item SurveyCTO types "integer" and "decimal": process.phenotypes
type "numeric".
\item SurveyCTO types: "select_one" and "select_multiple":
process.phenotypes type "categorical" with "shared_model"
the corresponding group in the SurveyCTO form choices tab.
It may be appropriate to override some of these values
to instead be "ordinal" type during manual review.
}

We have not encountered any other types \emph{per se} during our
review of SurveyCTO forms to date. It is likely that there are
some we do not currently support, or that will have been added
after this function was written. Certain types of infrastructure
entries in the form definition (e.g. notes, begin/end statements
for repeats and groups, and blank lines) are seamlessly processed.
Anything else encountered in the form file should cause
build.variable.data to emit an \verb{unrecognized CTO type flag detected}
warning. If you see such warnings, please inspect the type value
emitted in the warning. In most cases, the warnings are actually
harmless, the offending row is skipped, and the processing chain
continues without issue. However, if it looks like a meaningful
type entry has been skipped, it will probably break the parse.surveycto
logic chain. In that case, please post an issue so we can extend
support to the implicated type.
}
\examples{
type.value <- "text"
name.value <- "var1"
label.value <- "write something cool here"
choice.data <- data.frame(models = list(model1 = list(
  type = "categorical",
  levels = list(
    "1" = list(
      name = "answer 1",
      alternate_patterns = c("1")
    ),
    "2" = list(
      name = "answer 2",
      alternate_patterns = c("2")
    )
  )
)))
varname <- "HW00001"
var.data <- process.phenotypes:::build.variable.data(
  type.value,
  name.value,
  label.value,
  choice.data,
  varname
)
}
