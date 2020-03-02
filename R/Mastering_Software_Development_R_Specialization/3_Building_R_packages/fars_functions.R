#' Read fars data file
#' 
#' This function checks if a string passed as argument is a existing csv file, 
#' extract it and returns a \code{tbl_df} data
#' 
#' @param filename String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#' 
#' @examples
#' \dontrun{fars_read("file.csv")}
#' 
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Generates a filename with a specified year
#' 
#' This function takes an object, try to pass it to an integer and return
#' a string using the received object
#' 
#' @param year Object containing numbers
#' 
#' @return A filename string with input received 
#' 
#' @examples
#' \dontrun{make_filename(2018)}
#' \dontrun{make_filename(c("2018", "2019"))}
#' 
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read files with fars data
#' 
#' This function gets an array of string or int with years
#' and returns a list of fars data corresponding to years inputed or
#' a warning that there is not a fars data to a specific year
#' 
#' @param years String containing the name of the csv file to be read
#' 
#' @return This function returns a list of \code{tbl_df}
#' 
#' @importFrom dplyr mutate, "%>%", select
#' 
#' @examples
#' \dontrun{fars_read_years(c(2013, 2014, 2015))}
#' \dontrun{fars_read_years("2014")}
#' \dontrun{fars_read_years(1910)}
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

#' Summarize fars data
#' 
#' This function gets an array of string or int with years
#' and returns how many fars data it happened by month of a year
#' 
#' @param years String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @importFrom dplyr bind_rows, group_by, summarize, n
#' @importFrom tidyr spread
#' 
#' @examples
#' \dontrun{fars_summarize_years(c(2014, 2015))}
#' 
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>% 
                dplyr::group_by(year, MONTH) %>% 
                dplyr::summarize(n = dplyr::n()) %>%
                tidyr::spread(year, n)
}

#' Print fars data in a plot
#' 
#' This function gets two strings representing state number and a year
#' check if state number is valid and plot fars data in map of state
#' 
#' @param state.num String containing a number of USA state
#' @param year String of a year
#' 
#' @return This function plots fars data in specified state
#' 
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#' 
#' @examples
#' \dontrun{fars_map_state(52, 2014)}
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
