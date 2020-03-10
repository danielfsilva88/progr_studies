#' Import, read csv files and displays the data set
#'
#' This function will read csv data files and will return a tbl_df wrapper for a quick view of the data.
#' Additionaly an error message will be displayed if no csv file is found by the function
#'
#' @param filename  a csv file
#'
#' @return a dplyr tbl_df, from the csv file.
#'     An error message will be displayed if no csv file is found by the function.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @source accident_year.csv.bz2
#'
#' @examples
#'      data <- fars_read("accident_2013.csv.bz2")

fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}


#' Creates a filename
#'
#' Creates a file name for fars data by year.
#'
#' @param year year, four digits lenght. 
#'
#' @return a filename in the format of 'accident_year.csv.bz2'.
#'
#' @examples
#'      make_filename(year = "2013")
#'      file <- make_filename(year = 2013)

make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' reads specifics years from the main dataset
#'
#' This function selects specific years from the main data set and creates a specific dataset for each year. 
#' An error will be returned if the specified year isn't present
#'
#' @param years one or more years as a value or a list
#'
#' @return creates one or more datasets based on year number. An invalid year message will be returned in case of error.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @examples
#'      fars_read_years(2013)
#'      fars_read_years(as.list(2013, 2014, 2015))
#'      fars_read_years(2013:2015)
#' }

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

#' data summary by year
#'
#' Provides a summary by month and year of the fars data
#'
#' @param years one or more years as a value or a list
#'
#' @return a data frame of counts by month and year.
#'
#' @importFrom  dplyr bind_rows
#' @importFrom  dplyr group_by
#' @importFrom  dplyr summarize
#' @importFrom  tidyr spread
#'
#' @examples
#'      fars_summarize_years(2013)
#'      fars_summarize_years(as.list(2013, 2014, 2015))
#'      fars_summarize_years(2013:2015)
#' }

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>% 
                dplyr::group_by(year, MONTH) %>% 
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Create a map to display fars data
#'
#' Produces a map based on the state number, year and displays the data based on latitude and longitude.
#'
#'
#' @param state.num state number
#' @param year year, a four digit number
#'
#' @return A plot map based on latitude and longitude from the dataset.
#'      If an invalid state number is introduced an error message will be displayed.
#'      A message with no accidents to plot will also be displayed if there is no accidents recorded.        
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#'      fars_map_state(1, 2013)
#'      fars_map_state(39, 2013)


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
