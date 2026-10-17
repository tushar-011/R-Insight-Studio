# 📊 R-Insight Studio

> **An Offline Interactive Data Analysis and Visualization Application built with R, Shiny, ggplot2, DT, readr, and readxl.**

R-Insight Studio is a college mini-project designed to make basic data analysis easier through an interactive offline application. It allows users to **upload datasets, inspect them, clean missing or duplicate values, perform data operations, calculate statistics, create visualizations, study correlation, run linear regression, perform hypothesis testing, and export the cleaned dataset as CSV**.

The application runs locally using **R and Shiny**, so no external server or database is required.

---

## ✨ Highlights

- 📂 Upload CSV, XLS, and XLSX datasets
- 🏠 Dashboard with rows, columns, missing values, duplicates, and dataset preview
- 🔍 Dataset explorer with summary and optional technical structure
- 🧹 Show and clean missing-value rows
- ♻️ Replace missing values using mean, median, or mode
- 👯 Detect and remove duplicate records
- 🔄 Restore the original uploaded dataset
- ⚙️ Filter, sort, add, delete, rename, and convert columns
- 📊 Descriptive statistics for numeric columns
- 📈 Histogram, bar chart, box plot, scatter plot, line chart, and pie chart
- 🔗 Pearson correlation with interpretation and trend visualization
- 📉 Simple linear regression with equation, R², and fitted line
- 🧪 One-sample t-test with p-value, conclusion, and critical-region graph
- 💾 Export the current cleaned / modified dataset as CSV
- 🧩 Modular Shiny project structure
- 🖥️ Runs locally through RStudio and a browser
- 🌐 Git and GitHub workflow

---

# 📌 Table of Contents

- [About the Project](#-about-the-project)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Application Flow](#-application-flow)
- [Main Application Modules](#-main-application-modules)
- [Requirements](#-requirements)
- [Installing Required Packages](#-installing-required-packages)
- [Running the Application](#️-running-the-application)
- [Dataset Support](#-dataset-support)
- [Testing Checklist](#-testing-checklist)
- [Current Scope](#-current-scope)
- [Future Improvements](#-future-improvements)
- [GitHub Setup](#-github-setup)
- [Project Status](#-project-status)
- [Author](#-author)

---

# 📖 About the Project

**R-Insight Studio** is an offline R Shiny application for dataset analysis and visualization.

The application allows a user to:

- Upload CSV or Excel datasets
- Preview uploaded records
- View rows, columns, missing values, and duplicates
- Explore dataset structure
- Clean missing values
- Remove duplicate records
- Reset the working dataset
- Filter and sort rows
- Add, delete, rename, and convert columns
- Calculate descriptive statistics
- Create multiple graph types
- Measure correlation between numeric variables
- Perform simple linear regression
- Run a one-sample t-test
- Export the final modified dataset as CSV

The project demonstrates how **R can be used for importing, cleaning, transforming, analyzing, visualizing, and exporting data through an interactive application**.

---

# 🚀 Features

## 📂 Dataset Import

Supported formats:

- CSV
- XLS
- XLSX

After upload, the dataset becomes the shared working dataset used by all modules.

---

## 🏠 Dashboard

The dashboard provides:

- Total rows
- Total columns
- Missing-value count
- Duplicate-row count
- Interactive dataset preview

---

## 🔍 Data Explorer

The Data Explorer provides a simple summary of:

- Total rows
- Total columns
- Numeric columns
- Text / categorical columns
- Missing values
- Duplicate rows

The technical R structure is kept inside a collapsible section so normal users do not have to read it unless needed.

---

## 🧹 Data Cleaning

### Inspection

- Show rows containing missing values
- Show duplicate rows
- Show all records

### Cleaning

- Replace missing values with mean
- Replace missing values with median
- Replace missing values with mode
- Remove rows containing missing values
- Remove duplicate rows
- Reset dataset to the original uploaded version

---

## ⚙️ Data Operations

Available operations:

- Filter rows
- Add a new column
- Delete a column
- Rename a column
- Change column datatype
- Sort ascending
- Sort descending

Example:

```text
Column    = Final_Marks
Condition = Greater than or equal to
Value     = 60
```

---

## 📊 Descriptive Statistics

For numeric columns, the project currently calculates:

- Mean
- Median
- Minimum
- Maximum
- Variance
- Standard deviation

---

## 📈 Data Visualization

Available charts:

- Histogram
- Bar Chart
- Box Plot
- Scatter Plot
- Line Chart
- Pie Chart

Example uses:

```text
Histogram:
Final_Marks

Scatter Plot:
Attendance_Percent vs Final_Marks

Pie Chart:
Department

Line Chart:
Age vs Average Final_Marks
```

---

## 🔗 Correlation Analysis

The Correlation module uses **Pearson correlation**.

### Output

- Correlation coefficient
- Relationship strength
- Relationship direction
- Scatter plot
- Trend line

Interpretation:

```text
r close to +1 = Strong positive relationship
r close to  0 = Weak / no linear relationship
r close to -1 = Strong negative relationship
```

---

## 📉 Linear Regression

The user selects:

- Independent variable (X)
- Dependent variable (Y)

### Output

- Regression equation
- R² value
- Scatter plot
- Regression line
- Confidence area
- Optional full R regression output

---

## 🧪 Hypothesis Testing

R-Insight Studio includes a **one-sample t-test**.

The user selects:

- Numeric column
- Hypothesized mean
- Significance level

### Output

- Sample mean
- P-value
- Statistical decision
- Full t-test output
- T-distribution density graph
- Critical / rejection regions
- Critical-value boundaries
- Calculated test statistic

---

## 💾 Export Dataset

The current working dataset can be downloaded as CSV after cleaning and modification.

Example output:

```text
R-Insight-Cleaned-Data-2026-10-17.csv
```

---

# 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Main Programming Language | R |
| Application Framework | R Shiny |
| Data Manipulation | Base R / dplyr |
| Data Visualization | ggplot2 |
| Interactive Tables | DT |
| CSV Import | readr |
| Excel Import | readxl |
| Development IDE | RStudio |
| Interface Runtime | Local Web Browser |
| Version Control | Git |
| Repository Hosting | GitHub |
| Target Platform | Local / Offline Desktop Usage |

---

# 📁 Project Structure

```text
R-Insight-Studio/
│
├── app.R
├── README.md
│
├── R/
│   ├── data_import.R
│   ├── data_cleaning.R
│   ├── data_operations.R
│   ├── statistics.R
│   ├── visualization.R
│   ├── correlation.R
│   ├── regression.R
│   ├── hypothesis_testing.R
│   └── helpers.R
│
├── modules/
│   ├── mod_dashboard.R
│   ├── mod_explorer.R
│   ├── mod_cleaning.R
│   ├── mod_operations.R
│   ├── mod_statistics.R
│   ├── mod_visualization.R
│   ├── mod_correlation.R
│   ├── mod_regression.R
│   ├── mod_testing.R
│   └── mod_export.R
│
├── www/
│   └── style.css
│
└── sample_data/
    └── sample.csv
```

`app.R` stays small and mainly loads libraries, loads modules, creates shared reactive datasets, connects the modules, and starts the application.

---

# 🔄 Application Flow

```text
User
 │
 ▼
Launch R-Insight Studio
 │
 ▼
Upload CSV / Excel Dataset
 │
 ▼
Original Dataset Stored
 │
 ▼
Current Reactive Dataset
 │
 ├───────────────┬─────────────────┬─────────────────┐
 ▼               ▼                 ▼                 ▼
Explore        Clean            Operations        Statistics
 │               │                 │                 │
 └───────────────┴─────────┬───────┴─────────────────┘
                           ▼
                  Current Modified Dataset
                           │
            ┌──────────────┼───────────────┐
            ▼              ▼               ▼
      Visualization    Correlation     Regression
                           │               │
                           └───────┬───────┘
                                   ▼
                          Hypothesis Testing
                                   │
                                   ▼
                            Export as CSV
```

---

# 🧩 Main Application Modules

```text
R-Insight Studio
│
├── Dashboard
│   ├── Upload Dataset
│   ├── Rows
│   ├── Columns
│   ├── Missing Values
│   ├── Duplicates
│   └── Dataset Preview
│
├── Data Explorer
│   ├── Dataset Summary
│   └── Technical Structure
│
├── Data Cleaning
│   ├── Show Missing Rows
│   ├── Show Duplicates
│   ├── Replace Missing Values
│   ├── Remove Missing Rows
│   ├── Remove Duplicates
│   └── Reset Dataset
│
├── Data Operations
│   ├── Filter Rows
│   ├── Add Column
│   ├── Delete Column
│   ├── Rename Column
│   ├── Change Datatype
│   └── Sort Dataset
│
├── Statistics
│   └── Descriptive Statistics
│
├── Visualization
│   ├── Histogram
│   ├── Bar Chart
│   ├── Box Plot
│   ├── Scatter Plot
│   ├── Line Chart
│   └── Pie Chart
│
├── Correlation
│   └── Pearson Correlation
│
├── Regression
│   └── Simple Linear Regression
│
├── Hypothesis Testing
│   └── One-Sample T-Test
│
└── Export
    └── CSV Download
```

---

# ✅ Requirements

## R

Check the installed R version:

```r
R.version.string
```

## RStudio

RStudio is recommended for development and running the application.

## Git

Check Git:

```powershell
git --version
```

---

# 📦 Installing Required Packages

Run once in the RStudio Console:

```r
install.packages(c(
  "shiny",
  "dplyr",
  "ggplot2",
  "DT",
  "readxl",
  "readr"
))
```

Main libraries used by the application:

```r
library(shiny)
library(DT)
library(readr)
library(readxl)
library(ggplot2)
```

---

# ▶️ Running the Application

## Option 1 — RStudio

1. Open the `R-Insight-Studio` project in RStudio.
2. Open `app.R`.
3. Click **Run App**.
4. The Shiny application opens in the Viewer or browser.
5. Upload a CSV or Excel dataset.

## Option 2 — R Console

From inside the project folder:

```r
shiny::runApp()
```

The app opens at a local address similar to:

```text
http://127.0.0.1:xxxx
```

The port may change each time.

---

# 📄 Dataset Support

R-Insight Studio currently accepts:

```text
.csv
.xls
.xlsx
```

Datasets may contain:

- Numeric values
- Text values
- Categorical values
- Missing values
- Duplicate records

For best results, column names should be unique and the dataset should contain at least one numeric column.

---

# 🧪 Testing Checklist

Before demonstration or submission, test:

- Application launch
- CSV upload
- XLS / XLSX upload
- Dashboard row count
- Dashboard column count
- Missing-value count
- Duplicate count
- Dataset preview
- Dataset summary
- Technical dataset structure
- Show missing-value rows
- Show duplicate records
- Replace missing values using mean
- Replace missing values using median
- Replace missing values using mode
- Remove missing rows
- Remove duplicate rows
- Reset dataset
- Filter rows
- Add column
- Delete column
- Rename column
- Change datatype
- Sort ascending
- Sort descending
- Descriptive statistics
- Histogram
- Bar chart
- Box plot
- Scatter plot
- Line chart
- Pie chart
- Correlation result
- Correlation plot
- Regression equation
- Regression R²
- Regression plot
- Full regression output
- One-sample t-test
- P-value result
- Hypothesis-test decision
- T-distribution critical-region graph
- Export modified dataset as CSV
- Open exported CSV and verify modifications
- Navigation between all application tabs

---

# 🎯 Current Scope

R-Insight Studio is intentionally kept simple for an academic mini-project.

The current version focuses on:

- Dataset importing
- Dataset exploration
- Data cleaning
- Data manipulation
- Descriptive statistics
- Data visualization
- Correlation
- Simple linear regression
- Basic hypothesis testing
- CSV export

The project does **not** currently require:

- Database integration
- User authentication
- Cloud deployment
- Machine learning
- Multiple linear regression
- Advanced statistical models
- Remote APIs
- Separate backend services

---

# 🔮 Future Improvements

Possible future additions include:

- Excel export
- PDF reports
- Word reports
- Downloadable graph images
- Multiple linear regression
- Polynomial regression
- ANOVA
- Chi-square testing
- Two-sample t-test
- Paired t-test
- Correlation heatmap
- Outlier tools
- Undo / redo
- Save and reload analysis sessions
- Dataset comparison
- Dataset merging
- Advanced filtering
- Machine-learning models
- Automatic chart recommendations
- Desktop packaging

These are outside the current mini-project scope.

---

# 🌐 GitHub Setup

Useful Git commands:

```powershell
git status
git add .
git commit -m "Your commit message"
git push
```

For the completed functional version:

```powershell
git add .
git commit -m "Complete R-Insight Studio core features"
git push
```

For README updates:

```powershell
git add README.md
git commit -m "Add project README"
git push
```

Check repository status:

```powershell
git status
```

Expected result:

```text
nothing to commit, working tree clean
```

---

# 🏁 Project Status

### ✅ Core mini-project development complete

R-Insight Studio currently demonstrates:

- R programming
- Shiny application development
- Modular R programming
- Reactive programming
- Dataset importing
- CSV handling
- Excel handling
- Data frames
- Missing-value handling
- Duplicate detection
- Data filtering
- Column operations
- Datatype conversion
- Sorting
- Descriptive statistics
- Data visualization
- ggplot2
- Pearson correlation
- Linear regression
- One-sample t-test
- Statistical interpretation
- Interactive data tables
- CSV export
- Local offline application execution
- Git and GitHub workflow

The project is now in its **final documentation, GitHub, testing, and academic submission stage**.

---

# 👨‍💻 Development Notes

R-Insight Studio was created as an academic mini-project with emphasis on building a practical data-analysis application using R.

It is intended for:

- Academic demonstration
- College mini-project submission
- Learning R
- Learning Shiny
- Practicing data cleaning
- Practicing statistical analysis
- Practicing data visualization
- Portfolio use

The project was intentionally designed with a modular structure so each major feature remains easier to understand and maintain.

---

<div align="center">

## 📊 R-Insight Studio

**Import • Explore • Clean • Analyze • Visualize • Export**

Built with **R + Shiny + ggplot2**

</div>

---

# 👨‍💻 Author

### Tushar Thakur

**MCA Data Science**  
**Chandigarh University**

[![GitHub](https://img.shields.io/badge/GitHub-tushar--011-181717?logo=github)](https://github.com/tushar-011)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Tushar%20Thakur-0A66C2?logo=linkedin)](https://www.linkedin.com/in/tushar-thakur-8848a7396)

[![Email](https://img.shields.io/badge/Email-artificial.thakur%40gmail.com-EA4335?logo=gmail)](mailto:artificial.thakur@gmail.com)
