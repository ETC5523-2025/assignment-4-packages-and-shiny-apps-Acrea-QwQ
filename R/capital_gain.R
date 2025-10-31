#' Simulated Average Capital Gain Rate Change
#'
#' A simulated dataset representing the trend of average capital gain rate changes
#' in Australia between 1986 and 2020, separated by policy phase.
#'
#' @format A data frame with 34 rows and 3 variables:
#' \describe{
#'   \item{year}{character, formatted as "YYYY-YY"}
#'   \item{phase}{character, indicating policy period}
#'   \item{value}{numeric, simulated capital gain rate (basis points)}
#' }
#' @source Simulated data inspired by real Australian financial trends — serious analysis not recommended.
#' Patterns were designed to mimic real-world shapes, but all numbers are fully synthetic.
#'
#' @examples
#' # Load the dataset
#' data(capital_gain)
#'
#' # Preview first few rows
#' head(capital_gain)
#'
"capital_gain"
