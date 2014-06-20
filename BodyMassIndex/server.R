#Read Statistics File
stats = read.csv(header=TRUE, "Davis.csv")

#Adding BMI (Body Mass Index)
#Reference: http://en.wikipedia.org/wiki/Body_mass_index
stats$bmi = stats$weight / ((stats$height / 100) ^ 2)
#Adding Height In Inches Column
stats$heightInches = stats$height / 2.54
#Adding Weight In Pounds Column
stats$weightPounds = stats$weight / 0.453592

shinyServer(
  function(input, output) {

    #Height Label Output (Changes With IsMetric Input)
    output$heightLabel <- renderText({
      if(input$isMetric) {
        "Height (in centimeters)"
      } else {
        "Height (in inches)"
      }
    })

    #Weight Label Output (Changes With IsMetric Input)
    output$weightLabel <- renderText({
      if(input$isMetric) {
        "Weight (in kilograms)"
      } else {
        "Weight (in pounds)"
      }
    })

    #BMI Output (Changes With Any Input)
    output$bmi <- renderText({
      h = as.numeric(input$height)
      w = as.numeric(input$weight)
      if(input$isMetric) {
        bmi = round(w / ((h / 100) ^ 2), 2)
      } else {
        bmi = round(703.06957964 * w / (h ^ 2), 2)
      }

      #Check If BMI Is Not N/A
      if(!is.na(bmi)) { 
        if (bmi < 15){
          category = "Very severely underweight"
        } else if (bmi < 16) {
          category = "Severely underweight"
        } else if (bmi < 18.5) {
          category = "Underweight"
        } else if (bmi < 25) {
          category = "Normal (healthy weight)"
        } else if (bmi < 30) {
          category = "Overweight"
        } else if (bmi < 35) {
          category = "Obese Class I (Moderately obese)"
        } else if (bmi < 40) {
          category = "Obese Class II (Severely obese)"
        } else {
          category = "Obese Class III (Very severely obese)"
        }
        paste("BMI: ", bmi, "\nCategory: ", category)
      }
    })

    #Scatter Plot Output
    output$scatter <- renderPlot({
      if(input$isMetric) {
        plot(stats$weight, stats$height, xlab="Weight In Kilograms", ylab="Height In Centimeters", pch=20, cex=2, col="blue")
      } else {
        plot(stats$weightPounds, stats$heightInches, xlab="Weight In Pounds", ylab="Height In Inches", pch=20, cex=2, col="blue", main="Height Vs. Weight")
      }

      #If Height And Weight Exists, Draw User Point
      h = as.numeric(input$height)
      w = as.numeric(input$weight)
      if(! is.na(h) && ! is.na(w)) {
        points(w, h, pch = 4, cex = 4, lwd = 4, col="green")
      }
    })

    #Histogram Output
    output$histogram <- renderPlot({
      hist(stats$bmi, breaks=20, xlab="BMI", ylab="People Count", col="lightblue", main="BMI Histogram")

      h = as.numeric(input$height)
      w = as.numeric(input$weight)
      if(input$isMetric) {
        bmi = round(w / ((h / 100) ^ 2), 2)
      } else {
        bmi = round(703.06957964 * w / (h ^ 2), 2)
      }

      #If Height And Weight Exists, Draw User Line
      if(!is.na(bmi)) {
        lines(c(bmi, bmi), c(0, 200), col="red", lwd=5)
      }
    })

  }
)
