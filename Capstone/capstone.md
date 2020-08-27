

Johns Hopkins Data Science Capstone Project Pitch
========================================================
author: Jon Ting
date: 22/08/2020
autosize: true
transition: fade

This is the capstone project of the *Data Science specialization* offered by *Johns Hopkins University*. The project involves building a Shiny application to **predict the subsequent word of a short phrase**. The application will be the highlight in this presentation. 

About the Dataset
========================================================
type: sub-section
incremental: true
The English [Swiftkey dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) is employed to create this application. It contains blog entries, news entries, and twitter feeds collected from publicly available sources by webcrawlers.  

The whole English dataset is rather large, consisting of more than **3 million** entries in total. *Twitter feeds* dominate the dataset while *news entries* contributes the least to the collection.  

To produce a practical Shiny application, only **1%** of the whole English dataset has been employed to create the training set corpus, which simply means a dictionary of words.  

About the Application
========================================================
type: prompt
 - The application should load within 5 seconds, depending on your internet speed.  
 - Simply key in a **phrase in English** into the text box on the upper left and click the submit button.
 - A suggested **word in lime colour** will appear within 3 seconds after the phrase is submitted.  
 - A *histogram* and *word cloud* will be generated if the database contains similar phrases as the input text.  
 - The prediction of the current model is far from perfect due to the small set of n-grams used. However, there are a lot of potential ways to improve the application, including *error-handling*, *increasing the scope of dictionary* in the database, and *fixing minor problems in the display of results*.

About the Algorithm
========================================================
type: prompt
 - The *corpus created from the English data subset is cleaned* by removing URLs and non-alphabets,  converting the characters to lower case, filtering out English stop words and profane words, stemming each word and removing excessive spaces.  
 - The corpus was then *tokenised into n-grams* for n ranging from **2 to 6** and stored as separate files.  
 - A **backoff-model** was then implemented based on the n-grams. An input text has to undergo similar transformation before it is searched for in the n-grams database. The word found to be **most frequently occurring after the input phrase** will be returned as the suggested word.
 - Since only up to 6-grams stored, the model can only take the context of at most 5 non-English stop words prior to the word to be suggested into consideration during prediction. 

Give it a Go
========================================================
incremental: true
Try Out the [app](http://jon-ting.shinyapps.io/nextWord) hosted on *shinyapps.io*!

The codes are documented a GitHub [repository](http://github.com/Jon-Ting/10_Data_Science_Capstone) if you are interested.

Hints:  
 - The input text box only accepts a text of **at least 2 words** long (although sometimes adding a space after a word fools the model into accepting it). Otherwise, an *error* will be returned.  
 - Click on the **tabs** to switch between histograms and word clouds for frequency visualisation. Feel free to *omit* the histogram and/or word cloud if you are not interested in them.  
 - **Try** these out: "Hello t", "The man is", "Come here now"...
