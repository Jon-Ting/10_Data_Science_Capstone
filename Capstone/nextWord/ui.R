library(shiny)
library(shinythemes)
library(wordcloud2)

shinyUI(fluidPage(theme=shinytheme("cyborg"), 
  titlePanel(h1("WHAT IS THE NEXT WORD?", align = "center")),
  sidebarLayout(
    sidebarPanel(
      tags$head(tags$style('h3 {color:#2f9cd4;}')), 
      div(h3(textInput(inputId="inp_txt", label="Enter an English phrase: ", 
                   value="He has been working the whole day", width=NULL, 
                   placeholder="He has been working the whole day")), 
      tags$style(type="text/css", "#inp_txt {color:black; font-weight:bold}")), 
      actionButton(inputId="goButton", label="Suggest Next Word", width="100%", icon("paper-plane"), 
                   style="color:black; background-color:lime; border-color:#2f9cd4; font-weight:bold"), 
      checkboxInput(inputId="showHist", label="Show word count histogram", value=T, width=NULL), 
      checkboxInput(inputId="showCloud", label="Show word cloud", value=T, width=NULL), 
      h3("Data Description"), 
      helpText("The English Swiftkey dataset is employed to create this application. 
               It contains blog entries, news entries, and twitter feeds collected from 
               publicly available sources. Twitter feeds dominate the dataset while news 
               entries contributes the least to the collection", align="justify"), 
      h3("Documentation"), 
      helpText("A backoff-model has been implemented using n-grams for n up to 6. The 
               model only take at most 5 non-English stop words prior to the word to be suggested. 
               The predicion of the current model is far from perfect due to the small set of 
               n-grams used. However, further improvement could be expected as the training dataset 
               grows larger."), 
      helpText("The retrieval speed should be very fast, generation of suggested word requires 
               less than 3 seconds. Simply type in a phrase into the text box to try it out!")), 
    mainPanel( 
      tags$b(h2("The suggested word is:", align="center")),
      tags$b(h1(span(textOutput(outputId="suggested_word"), style="color:lime"), align="center")),
      tags$style(HTML(".nav>li>a {background-color:taupe; color:blush; font-weight:bold}")),
      tabsetPanel(
        tabPanel(div("Histogram"), 
                 plotOutput(outputId="histogram", height="490px")), 
        tabPanel(div("Word Cloud"), 
                 h4(textOutput(outputId="word_cloud_title"), align="center"), 
                 wordcloud2Output(outputId="word_cloud", height="445px")))))))
