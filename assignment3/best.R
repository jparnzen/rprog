## FIXME global variable for simple caching of the loaded dataset
g.data <- NULL

read.data <- function(dataset.filename) {
  if (is.null(g.data)) {
    g.data <<- read.csv(dataset.filename,
                        colClasses = "character",
                        comment.char = "")
  }
  g.data
}

prep.cols <- function(data, cols, type.func) {
  for(c in cols) {
    data[,c] <- suppressWarnings(type.func(data[,c]))
  }
  data
}

## best() finds the hospital in the state with the lowest mortality rate
## for the specified outcome
## 'state' is 2-character abbreviation of US state or territory
## 'outcome' is one of: 'heart attack', 'heart failure', 'pneumonia'
## returns the name of the hospital from the dataset
## NOTE in case of a tie, the first lexicographically sorted hospital name
## will be returned

best <- function(state, outcome) {
  ## Read outcome data
  data <- read.data("outcome-of-care-measures.csv")

  ## columns of interest:
  ##   Hospital.Name [, 2]
  ##   State [, 7]
  ##   Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack [, 11]
  ##   Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure [, 17]
  ##   Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia [, 23]

  outcome.cols <- c(11, 17, 23)
  names(outcome.cols) <- c("heart attack", "heart failure", "pneumonia")
  
  ## prep data cols by to make sure they're numeric and not chars or factors
  data <- prep.cols(data, outcome.cols, as.numeric)
  
  ## Check that state and outcome are valid
  if (!(state %in% data$State))
    stop("invalid state")
  if (!(outcome %in% names(outcome.cols)))
    stop("invalid outcome")
  
  ## Return hospital name in that state with lowest 30-day death rate
  state.data <- subset(data, State == state)
  state.data[which.min(state.data[,outcome.cols[outcome]]), ]$Hospital.Name
}