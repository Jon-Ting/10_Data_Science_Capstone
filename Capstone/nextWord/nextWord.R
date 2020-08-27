# Import required packages
library(tm)
library(SnowballC)

# Define helper functions
nGramsList <- c("./dtm2.rds", "./dtm3.rds", "./dtm4.rds", "./dtm5.rds", "./dtm6.rds")
unstemTrainCorp <- readRDS(file="./unstemTrainCorp.rds")
profaneWords <- read.delim(file="./badwords.txt", header=F)[, 1]
delPat <- function(strng, pat) gsub(pattern=pat, replacement=" ", x=strng)
txtTransfrom <- function(txt) { 
  txt <- delPat(strng=txt, pat="(f|ht)tp(s?)://(.*)[.][a-z]+")
  txt <- delPat(strng=txt, pat="[^a-zA-Z ]") 
  txt <- removePunctuation(x=txt)
  txt <- removeNumbers(x=txt)
  txt <- tolower(x=txt)
  txt <- removeWords(x=txt, words=stopwords(kind="en"))
  txt <- removeWords(x=txt, words=profaneWords)
  txt <- stemDocument(x=txt)
  txt <- stripWhitespace(x=txt)
  return(txt) }

# Implement backoff-model
nextWord <- function(inp_txt) { 
  
  # Extract usable parts from the input text
  inp_txt <- txtTransfrom(txt=inp_txt)
  phrase <- strsplit(x=inp_txt, split=" ")[[1]]
  if (length(phrase) == 0) { return("No text is detected after cleaning!") }
  else if ((length(unique(phrase)) == 1) & (unique(phrase)[1] == "")) { return("Only spaces left after cleaning!") }
  else if (length(phrase) > 5) {phrase <- phrase[1:5]}
  
  # Search for entries containing the phrase of length n in stored (n+1)-grams
  searchOrder <- length(phrase):1
  for (i in seq_along(searchOrder)) {
    phrase_str <- paste(phrase[i:length(phrase)], collapse=" ")
    docTermMat <- readRDS(file=nGramsList[searchOrder[i]])
    grams <- docTermMat$dimnames[["Terms"]]
    entries <- grams[grepl(pattern=phrase_str, x=grams, ignore.case=T)]
    if (length(entries) == 0) next else break }
  if (length(entries) == 0) { return("No similar phrase found in training data, sorry!") }
  
  # Create a corpus from the entries containing the phrase
  regex_str <- paste(phrase_str, "([^ ]+)")
  targetWords <- ''
  for (i in 1:length(entries)) { 
    match_idx <- regexec(pattern=regex_str, text=entries[i], ignore.case=T)
    targetWords <- c(targetWords, regmatches(x=entries[i], m=match_idx)[[1]][2]) }
  targetWords <- targetWords[(!is.na(targetWords)) & (targetWords != "")]
  if (length(targetWords) == 0) { return("No similar phrase found in training data, sorry!") }
  corp <- VCorpus(VectorSource(data.frame(targetWords)))
  
  # Compare probability for each unigram and return the most likely word
  targetDTM <- as.matrix(x=DocumentTermMatrix(corp))
  freq <- sort(colSums(x=targetDTM), decreasing=T)
  df <- data.frame(Word=names(freq), Counts=freq, Probability=freq/length(freq))
  rownames(df) <- 1:length(freq)
  numTopWords <- max(1, min(length(freq), 30))
  df[1:numTopWords, 1] <- stemCompletion(x=df[1:numTopWords, 1], dictionary=unstemTrainCorp, type="first")
  return(df) }
