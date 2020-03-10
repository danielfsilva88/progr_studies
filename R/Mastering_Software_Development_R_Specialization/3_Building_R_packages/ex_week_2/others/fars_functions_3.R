
#' Read a CSV file as a tibble object
#'
#'   This function search a CSV file and read it as a tibble object.
#'
#' @param filename Character vector, containing filename or path for the CSV-file which the \code{fars_read} function will search.
#'
#' @details The tibble objects are an efficient structure to storage and handling a \code{data.frame}.
#'   See more details about tibble objects in CRAN. \url{https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html}
#'
#' @note The \emph{"simple"} diagnostics messages and reading progress bar are omitted.
#'       An error message is generated when the file isn't found.
#'
#' @return This function returns the original CSV-file as a tibble object.
#'         For the examples, the data ("accident_\bold{year}.csv.bz2") should be download to working directry from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System.\href{https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars}{ FARS}
#'
#' @examples
#'
#'  fars_read ("accident_2013.csv.bz2")
#'  fars_read ("accident_2014.csv.bz2")
#'  fars_read ("accident_2015.csv.bz2")
#'
#' @importFrom dplyr tbl_df
#' @importFrom readr read_csv
#'
#' @export

fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Adding a year label to the filename.
#'
#' This function generate a new filename wich merge the original filename "accident.csv.bz2 " with a reference year especified by user.
#'
#' @param year Integer value, define the year to include in the filename.
#'
#' @details The files "accident_\bold{year}.csv.bz2" contain the American public data regarding fatal injuries suffered
#' in motor vehicle traffic crashes in a especified \code{year}. The \code{make_filename} function merge the \code{year} with the root "accident.csv.bz2" to obtain the true filename associated to the specified \code{year} .
#'          This function is required by \code{\link{fars_read_years}} functions.
#'
#' @return Character string with the filename/year merge
#'
#' @examples
#'
#' make_filename(2013)
#' make_filename(2014)
#' make_filename(2015)
#'
#' @export

make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' List of Month/Year accidents by year
#'
#' This function create a list of tibble object with the Month and Year associated with the report of an injury. Each item on the list corresponds to one year and each register corresponds to an injury report for this year.
#'
#' @param years Integers vector which contain the years to include in the list.
#'
#' @details The files "accident_\code{year}.csv.bz2" contain the American public data regarding fatal injuries suffered
#' in motor vehicle traffic crashes in a especified \code{year}. The \code{fars_read_years} function extract the Month and Year Variable from individual files asociated to \code{years} and locate it into list
#'
#' The files "accident_\bold{year}.csv.bz2" should be download to working directory from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System. \href{https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars}{FARS}
#'
#' @note When the individual file associated to i-th year isn't found, the function generates a warnings message and the i-th element on list will be NULL
#'
#' @return This function return a list of tibble object with the Month and Year variables
#'
#' @importFrom dplyr mutate select
#'
#' @examples
#'
#' fars_read_years(c(2013,2014,2015))
#'
#'
#' @export


fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Total number of fatal accidents per Month/Year
#'
#' This function generate a summary of the total number of fatal accidents grouped by Month/Year
#'
#' @param years Integers vector which contain the years to include in the summary table.
#'
#' @details The files "accident_\code{year}.csv.bz2" contain the American public data regarding fatal injuries suffered
#' in motor vehicle traffic crashes in a especified \code{year}. The \code{fars_summarize_years} function read the individual files asociated to \code{years} and generate a summary table with the number of injuries for Month -Year combination.
#'
#' The files "accident_\bold{year}.csv.bz2" should be download to working directory from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System. \href{https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars}{FARS}
#'
#' @note An error message is generated when the file "accident_\bold{year}.csv.bz2" isn't found in the working directory.
#'
#' @return This function return a summary table with number of fatal accidents per Month (rows) - Year (columns).
#'
#'
#' @examples
#'
#' fars_summarize_years(c(2013,2014,2015))
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#'
#' @export

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}


#' Spacial plot of fatal accidents per state - Year
#'
#' This function generate a plot with the pattern points of fatal accidents that happened in a state during a year
#'
#' @param state integer value, id state.
#' @param year  integer value, reference year.
#'
#' @details The files "accident_\code{year}.csv.bz2" contain the American public data regarding fatal injuries suffered
#' in motor vehicle traffic crashes in a especified \code{year}. The \code{fars_map_state} function read the individual files asociated to \code{year} and generate a spacial map with the patterns points for a state especified by user.
#'
#' The file "accident_\bold{year}.csv.bz2" should be download to working director
#'
#' @note An error message is generated when the file "accident_\bold{year}.csv.bz2" isn't found in the working directory.
#' #' The accidents locate in \eqn{Lattitude <90} or \eqn{Longitud > 900} are omitted.
#'
#' @return This function a map plot with the pattern points of injuries for state - year
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#'
#' fars_map_state(4,2013)
#' fars_map_state(8,2015)
#'
#'
#' @export

fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
