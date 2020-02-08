#You will need to design a class called "LongitudinalData" that
# characterizes the structure of this longitudinal dataset. You will
# also need to design classes to represent the concept of a subject, a visit, and a room.

#In addition you will need to implement the following functions

#make_LD: a function that converts a data frame into a LongitudinalData object
make_LD_S3 <- function(df){
  object <- structure(list(id = df$id,
                 visit = df$visit,
                 room = df$room,
                 value = df$value,
                 timepoint = df$timepoint), class = "LongitudinalData" )
  class(object$id) <- "Subject"
  class(object$room) <- "Room"
  class(object$visit) <- "Visit"
  object
}

## to S4 need to create class using "setClass"
setClass("LongitudinalData",
         slots = list(id = "numeric",
                      visit = "numeric",
                      room = "character",
                      value = "numeric",
                      timepoint = "numeric"))

make_LD_S4 <- function(df){
  new("LongitudinalData", id = df$id,
                          visit = df$visit,
                          room = df$room,
                          value = df$value,
                          timepoint = df$timepoint)
}




#subject: a generic function for extracting subject-specific information
## First, S3
subject <- function(x) UseMethod("subject")
subject <- function(df, id){
  ifelse(id %in% df$id, return(id), return(NULL))
}



#visit: a generic function for extracting visit-specific information
visit <- function(){

}



#room: a generic function for extracting room-specific information
room <- function(){
    
}

## RC classes assign methods inside class declaration
make_LD_RC <- function(df){
  setRefClass("LongitudinalData",
              fields = list(id = "numeric",
                        visit = "numeric",
                        room = "character",
                        value = "numeric",
                        timepoint = "numeric")),
              methods = list(
                subject
                
                visit
                
                room
              )
  
}
