#Main UI, A Fluid Page
shinyUI(fluidPage(
  #Page Title
  titlePanel("BMI (Body Mass Index) Calculator"),

  #Left Sidebar (For User Input)
  sidebarLayout(
    sidebarPanel(width=3,
      textInput("height", textOutput("heightLabel")), #Height Input
      textInput("weight", textOutput("weightLabel")), #Weight Input
      checkboxInput("isMetric", "Use metric system?", TRUE), #Is Metric Input
      br(),
      verbatimTextOutput("bmi"), #BMI Explanation Output
      br(),
      #Help Text Explaining BMI
      helpText(
        p("Body Mass Index is a measure of relative weight based on an individual's mass and height."),
        p(
          "Reference: ",
          a("http://en.wikipedia.org/wiki/Body_mass_index", href="http://en.wikipedia.org/wiki/Body_mass_index")
        )
      )
    ),

    #Left Main Panel (For Diagrams)
    mainPanel(
      fluidRow(
        #Scatter Plot For Height VS. Weight Statistics, User Value Is X
        column(6,
          h3("Height vs. Weight Scatter", align="center"),
          plotOutput('scatter')
        ),
        #Histogram For BMI, User Value Is A Line
        column(6,
         h3("BMI Histogram", align="center"),
         plotOutput('histogram')
        )
      )
   )
  )
))
