
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
      
      cat("Subject ID:", unique(x$id), "\n")
      
    } else if ("Room" %in% class(x) ){
      
        cat( "ID:", unique(x$id),
            "\nVisit:", unique(x$visit),
            "\nRoom:", unique(x$room), "\n" )
      
    } else if( any(grepl("summary", class(x))) ){
      
      cat("ID:", x$id, "\n")
      print(x$values)
      
    } else{
      
      cat("Longitudinal dataset with", length(unique(x$id)), "subjects\n")
      
    }
  } 
  else{
    cat("NULL\n")
  }
}

#subject: a generic function for extracting subject-specific information
subject <- function(x, y) UseMethod("subject")
subject.LongitudinalData <- function(df, id){
  object <- NULL
  if(id %in% df$id){
    object$id <- df$id[which(df$id == id)]
    object$visit <- df$visit[which(df$id == id)]
    object$room <- df$room[which(df$id == id)]
    object$value <- df$value[which(df$id == id)]
    object$timepoint <- df$visit[which(df$id == id)]
    class(object) <- c("Subject", "LongitudinalData")
    return(object)
  } else{
    NULL
  }
}
summary.Subject <- function(x){
  if ( "Subject" %in% class(x) ){
    object <- NULL
    object$id <- unique(x$id); values <- NULL
    visits <- unique(x$visit)
    rooms <- unique(x$room)[order( unique( x$room ) )]
    for(i in 1:length(visits)){
      values <- visits[i]
      for(j in 1:length(rooms)){
        values <- cbind(values, "room" = round( mean( 
          x$value[which( x$visit == visits[i] & x$room == rooms[j] ) ] ), 6 ))
        colnames(values)[ncol(values)] <- rooms[j]
      }
      object$values <- rbind(object$values, values)
      row.names(object$values)[i] <- i
      colnames(object$values)[1] <- "visit"
      object$values[is.nan(object$values)] <- NA
    }
    class(object) <- c("summary", "LongitudinalData")
    return(object)
  } else{
    NULL
  }
}


#visit: a generic function for extracting visit-specific information
visit <- function(x, y) UseMethod("visit")
visit.LongitudinalData <- function(df, id){
  object <- NULL
  if(id %in% df$visit){
    object$id <- df$id[which(df$visit == id)]
    object$visit <- df$visit[which(df$visit == id)]
    object$room <- df$room[which(df$visit == id)]
    object$value <- df$value[which(df$visit == id)]
    object$timepoint <- df$visit[which(df$visit == id)]
    class(object) <- c("Visit", "LongitudinalData")
    return(object)
  } else{
    NULL
  }
}


#room: a generic function for extracting room-specific information
room <- function(x, y) UseMethod("room")
room.LongitudinalData <- function(df, id){
  object <- NULL
  if(id %in% df$room){
    object$id <- df$id[which(df$room == id)]
    object$visit <- df$visit[which(df$room == id)]
    object$room <- df$room[which(df$room == id)]
    object$value <- df$value[which(df$room == id)]
    object$timepoint <- df$visit[which(df$room == id)]
    class(object) <- c("Room", "LongitudinalData")
    return(object)
  } else{
    NULL
  }
}
summary.Room <- function(x){
  object <- NULL
  if ( "Room" %in% class(x) ){
    object$id <- unique(x$id)
    object$values <- summary(x$value)
    class(object) <- c("summary", "LongitudinalData")
    return(object)
  }
}
