source("best.R")

reduce.df <- function(dataframe, col.names, cols) {
  tmp.df <- data.frame(dataframe[,cols])
  names(tmp.df) <- col.names
  tmp.df
}

sort.cols <- function(dataframe, main.col, sub.col) {
  dataframe[order(dataframe[[main.col]], dataframe[[sub.col]]), ]
}

## 'state': 2-character state or territory abbreviation
## 'outcome': one of 'heart attack', 'heart failure', 'pneumonia'
## 'num': one of 'best', 'worst', or an integer rank
rankhospital <- function(state, outcome, num = "best") {
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
  data <- prep.cols(data, 7, as.factor)
  
  ## Check that state and outcome are valid
  if (!(state %in% data$State))
    stop("invalid state")
  if (!(outcome %in% names(outcome.cols)))
    stop("invalid outcome")

  ## Return hospital name in that state with the given rank 30-day death rate
  # get state data
  state.data <- subset(data, State == state)
  # reduce the data frame to state, hospital, and requested outcome stats
  state.data <- reduce.df(state.data,
                          c("state", "hospital", outcome),
                          c(7, 2, outcome.cols[outcome]))
  # make sure we only have entries without NAs
  state.data <- state.data[complete.cases(state.data), ]
  # order state data
  #state.data <- state.data[order(state.data[[outcome]], state.data[["hospital"]]), ]
  state.data <- sort.cols(state.data, outcome, "hospital")

  result = NA
  result <- if (is.character(num)) switch(num,
                                          best = state.data[1, ][["hospital"]],
                                          worst = state.data[nrow(state.data), ][["hospital"]])
            else if (is.numeric(num)) state.data[num, ][["hospital"]]
  result
}
