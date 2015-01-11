library(shiny)

shinyUI(navbarPage("BMI",
   tabPanel(title="Calculator",       
        sidebarLayout(
            sidebarPanel(
                strong(
                    p("BMI is a measurement which determines which weight category a person belongs to. Depending on his/her height and weight, a person can belong to one of the following weight categories:"),                         
                    
                    tags$ul(
                        tags$li("underweight (BMI < 18.5)"), 
                        tags$li("normal weight (18.5 <= BMI <= 24.9)"), 
                        tags$li("overweight (25.0 <= BMI <= 29.9)"),
                        tags$li("obese (BMI >= 30.0)")
                    ),
                    
                    p("This BMI Calculator is based on US weight and height metrics, and applies to adults only. Once you enter your weight and height, and click the Submit button, your BMI will be calculated and displayed on the right."),
                    
                    p("You can also click on the Adult Obesity Prevalence In US tab at the top to see the latest US obesity prevalence information.")                
                ),
                
                br(),                       
                
                numericInput('weightFld', 'Please enter your weight in pounds:', 0, min = 0, max = 300, step = 1),            
                p("Please enter your height in feet and inches:"),
                numericInput('feetFld', 'Height in feet', 0, min = 0, max = 7, step = 1),
                numericInput('inchFld', 'and inches', 0, min = 0, max = 100, step = 1),
                submitButton('Submit')            
            ),
            
            mainPanel(                                                               
                 h4('You entered height in feet'),
                 verbatimTextOutput("ofeet"),
                 h4('You entered height in inches'),
                 verbatimTextOutput("oinch"),
                 h4('You entered weight'),
                 verbatimTextOutput("oweight"),
                 h4('Your BMI is'),
                 verbatimTextOutput("obmi"),
                 h4('Your weight status is'),
                 verbatimTextOutput("ostatus")                                                
                )
            )           
            
   ),  
   
   tabPanel(title="Adult Obesity Prevalence in US",
        sidebarLayout(
            sidebarPanel(
                
                h2("Adult Obesity Facts"),
                
                tags$ul(
                    tags$li("More than one-third (34.9% or 78.6 million) of US adults are obese."),                     
                    tags$li("Obesity-related conditions include heart disease, stroke, type 2 diabetes and certain types of cancer, some of the leading causes of preventable death."),                    
                    tags$li("The estimated annual medical cost of obesity in the U.S. was $147 billion in 2008 U.S. dollars; the medical costs for people who are obese were $1,429 higher than those of normal weight.")                  
                ),
                
                div(
                    "The data shown in the plots is based on self-reported obesity prevalence rate for each state among U.S. adults in 2013, collected by Centers for Disease Control and Prevention.",
                    "The data is available at this",
                    a("link.", href="http://www.cdc.gov/obesity/data/table-adults.html", target="_blank")
                ),
                
                br(),
                
                p("Below are data for the first 10 states and summary information:"),
                verbatimTextOutput("ohead"),               
                verbatimTextOutput("osummary"),  
                
                p("On the right side, a histogram of the obesity prevalence rate is shown, followed by a US states map color-filled by the range of prevalence rate.")
                
            ),
            
            mainPanel(
                plotOutput("prevHist"),
                plotOutput("prevMap")
            )
        )         
)))