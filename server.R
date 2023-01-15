# server.R
library(plumber)

# function to read all records
read_all <- function(){
  return(data)
}

# function to read a single record
read_one <- function(id){
  return(data[id,])
}

# create function that exist user is already in database
create <- function(name, age, email){
  # check if user already exists
  existing_user <- data[data[,"email"] == email,]
  if(nrow(existing_user) > 0){
    return(list(status = "error", message = "User already exists"))
  }
  new_id <- nrow(data) + 1
  data[new_id,] <- c(name, age, email)
  return(list(status = "success", data = data[new_id,]))
}

# function to update a record
update <- function(id, name, age, email){
  existing_user <- data[data[,"email"] == email,]
  if(nrow(existing_user) > 0){
    if(existing_user[1,] != data[id,]){
      return(list(status = "error", message = "User already exists"))
    }
  }
  data[id,] <- c(name, age, email)
  return(list(status = "success", data = data[id,]))
}

# function to delete a record
delete <- function(id){
  data <- data[-id,]
  return("Record deleted")
}

# plumber API definition
#' @get /read_all
#' @get /read_one/:id
#' @post /create name=character age=numeric
#' @put /update/:id name=character age=numeric
#' @delete /delete/:id

api <- plumb("server.R")
api$run(port=8000)
