# Import required packages and functions
library(shiny)
library(tm)
library(ggplot2)
library(ggdark)
library(wordcloud2)
source("./nextWord.R")

# Define the server functions
shinyServer(function(input, output) {
    
    # Generate suggested words
    word_df <- eventReactive(eventExpr=input$goButton, valueExpr={ nextWord(input$inp_txt) })
    numWords <- reactive({ dim(word_df())[1] })
    output$suggested_word <- renderText({ word_df()[1, 1] })
    output$word_cloud_title <- renderText({ paste(numWords(), "Word(s) are Found!") })
    
    # Visualizations
    output$histogram <- renderPlot({
        if (input$showHist) {
            ggplot(word_df()[1:max(1, min(numWords(), 30)), ], aes(reorder(Word, -Counts), Counts)) + 
                dark_mode(theme_classic())  + 
                labs(title="Most Common Words Frequency", x="Suggested Words", y="Frequency") + 
                theme(text=element_text(size=18, color="white"), 
                      axis.text.y=element_text(size=16), 
                      axis.text.x=element_text(angle=45, size=16, vjust=0.6), 
                      plot.title=element_text(size=32, hjust=0.5)) + 
                geom_bar(stat="identity", fill="navy") } }, bg="black", execOnResize=T)
    output$word_cloud <- renderWordcloud2({ 
        if (input$showCloud) { 
            if (numWords() < 10) cloudSize <- 0.5
            else if (numWords() < 50) cloudSize <- 0.4
            else cloudSize <- 0.3
            wordcloud2(data=word_df(), size=cloudSize, shape='circle', color='random-light', 
                       backgroundColor="black") } }) })
