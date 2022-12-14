% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dependency_helper_functions.R
\name{response.depends.on.not.na}
\alias{response.depends.on.not.na}
\title{Test dependency of one variable on non-NA response of another}
\usage{
response.depends.on.not.na(
  dependent.variable,
  independent.variable,
  independent.na.aliases = character(),
  dependent.na.aliases = character()
)
}
\arguments{
\item{dependent.variable}{Character vector or factor for dependent/upstream variable
in the dependency.
This function is intended to be called from the \code{dependencies}
block of a dataset configuration file, in which case the mapping keys
under \code{variables} (e.g. HW00001) can be called directly.}

\item{independent.variable}{Character vector or factor for independent/downstream variable
in the dependency.
This function is intended to be called from the \code{dependencies}
block of a dataset configuration file, in which case the mapping keys
under \code{variables} (e.g. HW00001) can be called directly.}

\item{independent.na.aliases}{Character vector alternative values to be treated
as NAs in the independent variable. For example, depending on the question,
\verb{0 times} or \code{none} could be considered non-response.}

\item{dependent.na.aliases}{Character vector alternative values to be treated
as NAs in the dependent variable. For example, depending on the question,
\code{never} or \code{none} could be considered non-response.}
}
\value{
Logical vector representing the results
of the dependency test between the two provided vectors. Test
represents whether the specified dependency is satisfied.
}
\description{
This is a function designed for use within the user configuration
file, as a convenience to handle structured comparison between
a question and its dependent downstream response.
In the formal parameters, \code{dependent} refers to the logically
downstream question, and \code{independent} refers to the upstream
question on which the \code{dependent} question depends.

Note that the input vectors are specified as \emph{names of variables}
within the input phenotype dataset. At the time the dependencies
are evaluated, the phenotype dataset has had the user-configured
variable names applied as its column headers, and as such the
variables should be referred to by those labels directly.
}
\details{
This dependency test assumes the input vectors are factors or character vectors.
This is a very general test that supposes that anyone who responds
at all to the upstream question is a valid respondent for the downstream
one. The definition of \code{NA} can be expanded for each compared variable.
In this dependency test, an \code{NA} response in the independent variable
indicates a subject that should never provide a non-\code{NA} response
in the dependent variable; an \code{NA} response in the dependent variable
indicates a subject that did not in fact provide a response in the dependent variable.
}
\examples{
indep.var <- c("yes", "sometimes", "no response", "yes", "never")
dep.var <- 0:4
phenotype.data <- data.frame(
  HW00001 = indep.var,
  HW00002 = dep.var
)
dep.test <- response.depends.on.not.na(
  phenotype.data$HW00002,
  phenotype.data$HW00001,
  c("no response"),
  c("0")
)
## this function is designed as a utility to be
## deployed in the dependency block of a user configuration
## file. it requires the bindings of the phenotype data
## matrix to be available in the current context
\dontrun{
dep.test <- response.depends.on.not.na(
  HW00002,
  HW00001,
  c("no response"),
  c("0")
)
}
## expected: TRUE TRUE FALSE TRUE TRUE
}
\seealso{
response.depends.on.yes

response.depends.on.yes,
response.is.less.than, response.is.greater.than,
response.is.duplicate.of, response.is.computed.bmi
year.is.consistent.with.age
}
