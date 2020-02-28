#' "fars"
#' 
#' This script have functions to read and manipulate fars data.
#' 
#' Read file with fars data
#' 
#' This function checks if a string passed as argument is a existing csv file, 
#' extract it and returns a \code{tbl_df} data
#' 
#' @param filename String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @examples
#' fars_read("file.csv")
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
#' make_filename(2018)
#' make_filename("2018")
#' make_filename(c("2018", "2019"))
#' 
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read file with fars data
#' 
#' This function checks if a string passed as argument is a existing csv file, 
#' extract it and returns a \code{tbl_df} data
#' 
#' @param years String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @examples
#' fars_read_years()
#' fars_read_years()
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

#' Read file with fars data
#' 
#' This function checks if a string passed as argument is a existing csv file, 
#' extract it and returns a \code{tbl_df} data
#' 
#' @param years String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @examples
#' fars_summarize_years(years)
#' 
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>% 
                dplyr::group_by(year, MONTH) %>% 
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Read file with fars data
#' 
#' This function checks if a string passed as argument is a existing csv file, 
#' extract it and returns a \code{tbl_df} data
#' 
#' @param state.num String containing the name of the csv file to be read
#' @param year String containing the name of the csv file to be read
#' 
#' @return This function returns a data structure of type \code{tbl_df}
#' 
#' @examples
#' fars_map_state(state.num, year)
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
