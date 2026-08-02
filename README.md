# insurance-claims-analysis

# Customer Risk & Claims Analysis for an Insurance Company (Ubuntu Insurance Ltd)

## 1. Project Overview
This project was completed as part of the Data Analytics Foundations Programme offered by DataForge Africa.
This project simulates a real-world business scenarion for Ubuntu Insurance Ltd, where increasing claim costs, suspected fraudulent claims, and customer retention challenges were negetively affecting profitability.

As a Junior Data Analyst, my role was to analyse customer, policy, and claims data to uncover business insights and recommend strategies to reduce risk, improve profitability, and strengthen fraud prevention.

## 2. Business Problem
Ubuntu Insurance Ltd was experiencing:
* Increasing claims costs
* Suspected fraudulent claims
* Low customer retention
* Profitability concerns caused by claims exceeding premium income

Management required a data-driven analysis to identify risk patterns and support business decision-making.

## 3. Project Objectives
The objectives of this project were to:
* Explore and understand insurance claims data using SQL
* Clean and prepare raw data for analysis
* Build interactive dashboards in Power BI
* Identify fraud trends and high-risk customer segments
* Provide business recommendations to improve profitability and reduce risk

## 4. Dataset
The dataset contains information relating to:
* Customer demographics
* Insurance policies
* Premium amounts
* Claims information
* Claim status
* Fraud indicators

## 5. Tools Used
Databricks (SQL),
Power BI,
CSV/ Excel Spreadsheet,
PowerPoint (Data Storytelling),
GitHub (Project Documentation)

## 6. Project Overflow
#### a) Data Exploration
Performed exploratory analysis using SQL to answer key business questions:
* Total customers, policies, and claims.
* Total claim amount
* Claims by policy type
* Fraud versus non-fraud claims
* Top claim amounts
* Claims by location
* Claim trends over time

#### b) Data Cleaning
The raw dataset contained several data quality issues which were addressed using SQL on Databricks:
* Remove duplicate records
* Standardised categorical values
* Handled null values
* Corrected inconsistent text values
* Standardised fraud indicators
* Removed invalid records
* Created a clean analytical dataset
Final cleaned table: clean_insurance_data

#### c) Dashboard Development
Developed an interactive Power BI dashboard containing:

###### KPI Cards
* Total customers
* Total claims
* Total claim amount
* Fraud cases
* Loss ratio
###### Claims Analysis
* Claims by policy type
* Claims status breakdown
* Claims over time
###### Fraud Analysis
* Fraud vs non-fraud
* Fraud by policy type
* Fraud by location
###### Customer Insights
* Premium vs claims
* Claims by age group
* Claims by gender

## 7. Key Findings
#### a) Financial Risk
* Total claims amounted to approximately R11.61 million while premium income was approximately R0.69 million.
* Claims therefore exceeded premium income by approximately R10.92 million, creating a significant underwriting deficit.
* Claims were approximately 16.76 times higher than premiums earned, resulting in an exceptionally high loss ratio of approximately 1675,71%. This indicates a significant imbalance between premiums and claims and raises concerns about the sustainability of the current pricing and risk management approach.
#### b) Most Risky Policy Types
* Auto and health insurance recorded the highest claim volumes.
* Home insurance recorded the highest fraud## incidence.
#### c) Fraud Insights
Fraud was concentrated within specific provinces:
* KwaZulu-Natal
* Free State
* Western Cape
#### d) High-Risk Customer Segments
* Customers aged 25-60 represented the largest proportion of claims. This group also represents the insurer's largest and most active customer base.
* Health, auto, and life policies generated the highest claim activity.
* The combination of customer age, policy type, and location increased risk exposure.

## 8. Business Recommendations
#### a) Improve Pricing and Profitability
* Review premium pricing and underwriting policies for health and auto insurance, which generated the highest claims.
* Implement risk-based pricing by considering claim history, policy type, fraud exposure, and geographic location.
* Conduct regular profitability reviews to ensure premium income aligns more closely with claim costs and supports long-term sustainability.
### b) Strengthen Fraud Prevention
* Enhance fraud detection and investigation processes in KwaZulu-Natal, Free State, and Western Cape.
* Introduce additional verification checks for home insurance claims, where fraud incidence is highest.
#### C) Enhance Customer Risk Management
* Develop customer risk profiles using claim history, policy type, and location rather than relying on age alone.
* Introduce no-claim rewards or premium discounts to encourage responsible claim behaviour.
* Monitor claim trends within the working-age customer segment to identify emerging risks while maintaining strong customer relationships.
#### d) Strengthen Operational Monitoring
* Use Power BI dashboards to monitor claims, fraud trends, policy performance, and financial exposure.
* Conduct regular claims reviews to identify emerging risks and measure the effectiveness of fraud prevention and pricing strategies.

## 9. Author
- Name: Kopano Mofokeng
- Profession: Data Analyst
- Email: kopanom012@gmail.com
- LinkedIn: www.linkedin.com/in/kopanomofokeng/

