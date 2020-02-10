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
                 timepoint = df$timepoint), 
                 class = c("LongitudinalData") )
  class(object$id) <- c("Subject", class(object))
  class(object$room) <- c("Room", class(object))
  class(object$visit) <- c("Visit", class(object))
  object
}

## First, S3

print.LongitudinalData <- function(x){
  
  if ( "LongitudinalData" %in% class(x) ) {
    
    if ("Subject" %in% class(x)){
      
      if("Summary" %in% class(x)){
        
      } else{
      paste("Subject ID: ", X)
      }
      
    } else if ("Room" %in% class(x) ){
      
      if("Summary" %in% class(x)){
        
      } else{
        cat("ID: ", X$id, "\nVisit: ", x$visit, "\nRoom: ", x$room)
      }
    } else{
      paste("Longitudinal dataset with", length(unique(x$id)), "subjects")
    }
  } 
  else{
    print(NULL)
  }
}

#subject: a generic function for extracting subject-specific information
subject <- function(x) UseMethod("subject")
subject.Subject <- function(df, id){
  if(id %in% df$id){
    class(id) <- c("Subject", "LongitudinalData")
    id
  } else{
    NULL
  }
}
summary.Subject <- function(id){
  if ("Subject" %in% class(id)){
    
  } else{
    NULL
  }
}



#visit: a generic function for extracting visit-specific information
visit <- function(){

}



#room: a generic function for extracting room-specific information
room <- function(){
    
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




## RC classes assign methods inside class declaration
make_LD_RC <- function(df){
  setRefClass("LongitudinalData",
              fields = list(id = "numeric",
                        visit = "numeric",
                        room = "character",
                        value = "numeric",
                        timepoint = "numeric")),
              methods = list(
                print = function(x){
                  if (class(x) == "LongitudinalData"){
                    paste()
                  } else if (class(x) == "Subject"){
                    paste("ID: ", X)
                  } else if (class(x) == "Visit"){
                    
                  } else if (class(x) == "Room"){
                    
                  } else{
                    
                  }
                },
                summary = function(x){},
                subject
                
                visit
                
                room
              )
  
}
