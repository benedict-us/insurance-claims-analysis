-- Databricks notebook source
-- DBTITLE 1,file path
/Volumes/dfa_final_project_storage/dfa_insurance_project/dfa_insurance_project_raw_dataset

-- COMMAND ----------

-- DBTITLE 1,create a table
create or replace table dfa_insurance_project_raw_dataset
as
select *
from read_files(
  '/Volumes/dfa_final_project_storage/dfa_insurance_project/dfa_insurance_project_raw_dataset/dfa_insurance_project_raw_dataset.csv' ,
  format => 'csv',
  header => true,
  inferSchema => true
 );

-- COMMAND ----------

-- DBTITLE 1,preview the table/dataset
select
  *
from
  dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,check total rows
select  
  count(*) as total_records
from
  dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,count distinct customers, policies, and claim id
select
  count(distinct customer_id) as total_customers,
  count(distinct policy_id) as total_policies,
  count(distinct claim_id) as total_claims
from dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,sum of claim amount
select
  round(
    sum(try_cast(regexp_replace(trim(claim_amount), '[^0-9.-]', '') as double)),
    2
  ) as total_claim_amount
from dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,sum of premium amount
select  
  round(
    sum(
    try_cast(regexp_replace(trim(premium_amount), '[^0-9.-]', '') as double)),
    2
    ) as total_premium_amount  
from dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,claims by policy tupe
select
  policy_type,
  count(distinct claim_id) as total_claims
from dfa_insurance_project_raw_dataset
group by policy_type
order by total_claims desc;

-- COMMAND ----------

-- DBTITLE 1,average of claim amount by policy type
select
  policy_type,
  round(
    avg(try_cast(regexp_replace(trim(claim_amount), '[^0-9.-]', '') as double)),
    2
  ) as avg_claim_amount
from dfa_insurance_project_raw_dataset
group by policy_type
order by avg_claim_amount desc;

-- COMMAND ----------

-- DBTITLE 1,fraud vs non-fraud
select
  fraud_flag,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by fraud_flag
order by total_records desc;

-- COMMAND ----------

-- DBTITLE 1,claims per location/province
select
  province,
  count(distinct claim_id) as total_claims
from dfa_insurance_project_raw_dataset
group by province
order by total_claims desc;

-- COMMAND ----------

-- DBTITLE 1,see table
select
  * 
  from
  dfa_insurance_project_raw_dataset
  limit 5;

-- COMMAND ----------

-- DBTITLE 1,claim trends over time
select
  claim_date,
  count(distinct(claim_id)) as claim_id,
  sum(
    round(try_cast(regexp_replace(trim(claim_amount), '[^0-9.-1]', '') as double), 
  2
  )
   ) as claim_amount
from
  dfa_insurance_project_raw_dataset
  group by claim_date
  order by claim_date desc;

-- COMMAND ----------

-- DBTITLE 1,claim trend over time amendment
select  
  coalesce(
    try_to_date(claim_date, 'yyyy-MM-dd'),
    try_to_date(claim_date, 'MM/dd/yyyy'),
    try_to_date(claim_date, 'yyyy/MM/dd'),
    try_to_date(Claim_Date, 'dd-MMM-yyyy')
  )
  as claim_date,
  count(distinct(claim_id)) as total_claims,
  round(sum(try_cast(regexp_replace(trim(Claim_Amount), '[^0-9.-]', '') as double)),2) as total_claim_amount
  from dfa_insurance_project_raw_dataset

  where coalesce(
    try_to_date(claim_date, 'yyyy-MM-dd'),
    try_to_date(claim_date, 'MM/dd/yyyy'),
    try_to_date(claim_date, 'yyyy/MM/dd'),
    try_to_date(Claim_Date, 'dd-MMM-yyyy')
  ) is not null

  group by claim_date
  order by claim_date;

-- COMMAND ----------

-- DBTITLE 1,top 5 claims
select
  claim_id,
  customer_id,
  policy_id,
  Policy_Type,
  round(try_cast(regexp_replace(trim(Claim_Amount), '[^0-9.-]', '') as double),2) as high_claim_Amount
from dfa_insurance_project_raw_dataset
order by high_claim_Amount desc
limit 5;

-- COMMAND ----------

-- DBTITLE 1,checking duplicate customer id records
select 
  customer_id,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by customer_id
having count(*) > 1
order by total_records desc;

-- COMMAND ----------

-- DBTITLE 1,checking duplicate claim id records
select
  claim_id,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by claim_id
having count(*) > 1
order by total_records desc;

-- COMMAND ----------

select 
  policy_id,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by policy_id
having count(*) > 1
order by total_records desc;

-- COMMAND ----------

select count(*) as total_rows,
count(*) as distinct_rows
from (
  select distinct *
  from dfa_insurance_project_raw_dataset
);

-- COMMAND ----------

-- DBTITLE 1,check negative claim amounts
select
  count(*) as negative_claims
from dfa_insurance_project_raw_dataset
where try_cast(regexp_replace(trim(claim_amount), '[^0-9.-]', '') as double
) < 0;

-- COMMAND ----------

-- DBTITLE 1,checking for negative records
select
  claim_id,
  customer_id,
  policy_id,
  claim_amount
  from dfa_insurance_project_raw_dataset
  where try_cast(regexp_replace(trim(claim_amount), '[^0-9.-]', '') as double) < 0;

-- COMMAND ----------

select  
  *
  from dfa_insurance_project_raw_dataset
  limit 20;

-- COMMAND ----------

select
  policy_status,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by policy_status
order by total_records desc;

-- COMMAND ----------

select
  gender,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by gender
order by total_records desc;

-- COMMAND ----------

select
  claim_status,
  count(*) as total_records
from dfa_insurance_project_raw_dataset
group by claim_status
order by total_records desc;