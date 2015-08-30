source("rankhospital.R")

rankall <- function(outcome, num = "best") {
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
  
  ## Check that outcome is valid
  if (!(outcome %in% names(outcome.cols)))
    stop("invalid outcome")
  
  ## For each state, find the hospital of the given rank
  # create a smaller dataframe of only the essential columns
  data <- reduce.df(data,
                    c("state", "hospital", outcome),
                    c(7, 2, outcome.cols[outcome]))
  # get the complete cases for each state (doesn't need to be by state)
  data <- lapply(split(data, data$state), function(x) x[complete.cases(x), ])
  # sort each state by outcome and hospital
  data <- lapply(data, function(x) x[order(x[[outcome]], x[["hospital"]]), ])
  # get the requested ranking for each state
  # tmp5 <- lapply(tmp4, function(x) x[num, ])
  data <- if (is.character(num)) switch(num,
                                        best = lapply(data, function(x) x[1, ]),
                                        worst = lapply(data, function(x) x[nrow(x), ]))
          else if (is.numeric(num)) lapply(data, function(x) x[num, ])
  # compose the new dataframe
  # tmp6 <- data.frame(hospital = do.call(rbind, lapply(tmp5, function(x) x$hospital)),
  #                    state = names(tmp5))
  data <- data.frame(hospital = do.call(rbind, lapply(data, function(x) x$hospital)),
                     state = names(data))
  ## Return a data frame with the hospital names and the (abbreviated) state name
  data
}
