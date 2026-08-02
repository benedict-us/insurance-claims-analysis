-- Databricks notebook source
-- DBTITLE 1,create a temporary table view
create or replace temp view clean_insurance_project_data as
select
  nullif(trim(customer_id), '') as customer_id,
  nullif(trim(policy_id), '') as policy_id,
  nullif(trim(claim_id), '') as claim_id,

  case
    when age is null or trim(age) = '' or lower(trim(age)) = 'N/A' then null
    else try_cast(trim(age) as int)
  end as age,

  case
    when gender is null or trim(gender) = '' then 'Unknown'
    when lower(trim(gender)) in ('male', 'm') then 'Male'
    when lower(trim(gender)) in ('female', 'f') then 'Female'
    else 'unknown'
  end as gender,

  case
    when province is null or trim(province) = '' then 'Unknown'
    when lower(trim(province)) in ('gp', 'gauteng') then 'Gauteng'
    when lower(trim(province)) in ('wc', 'western cape') then 'Western Cape'
    when lower(trim(province)) in ('ec', 'eastern cape') then 'Eastern Cape'
    when lower(trim(province)) in ('nw', 'north west') then 'North West'
    when lower(trim(province)) in ('fs', 'free state') then 'Free State'
    when lower(trim(province)) in ('kzn', 'kwazulu-natal', 'kwazulu natal') then 'KwaZulu-Natal'
    when lower(trim(province)) in ('mp', 'mpumalanga') then 'Mpumalanga'
    when lower(trim(province)) in ('lp', 'limpopo') then 'Limpopo'
    when lower(trim(province)) in ('nc', 'northern cape') then 'Northern Cape'
    else initcap(trim(province))
  end as province,

  case
    when monthly_income is null or trim(monthly_income) = '' or lower(trim(monthly_income)) = 'N/A' then null
    else try_cast(regexp_replace(trim(monthly_income), '[^0-9.-]', '') as double)
  end as monthly_income,

  coalesce(
    try_to_date(trim(join_date), 'yyyy-MM-dd'),
    try_to_date(trim(join_date), 'dd/MM/yyyy'),
    try_to_date(trim(join_date), 'MM/dd/yyyy'),
    try_to_date(trim(join_date), 'yyyy/MM/dd'),
    try_to_date(trim(join_date), 'dd-MMM-yyyy'),
    try_to_date(trim(join_date), 'MM-dd-yyyy')
  ) as join_date,

  case
    when policy_type is null or trim(policy_type) = '' then 'Unknown'
    when lower(trim(policy_type)) in ('auto', 'motor') then 'Auto'
    when lower(trim(policy_type)) in ('health', 'medical') then 'Health'
    when lower(trim(policy_type)) = 'life' then 'Life'
    when lower(trim(policy_type)) in ('home', 'property') then 'Home'
    when lower(trim(policy_type)) = 'funeral' then 'Funeral'
    else initcap(trim(policy_type))
  end as policy_type,

  case
    when premium_amount is null or trim(premium_amount) = '' or lower(trim(premium_amount)) = 'N/A' then null
    else try_cast(regexp_replace(trim(premium_amount), '[^0-9.-]', '') as double)
  end as premium_amount,

  case
    when policy_status is null or trim(policy_status) = '' then 'Unknown'
    when lower(trim(policy_status)) = 'active' then 'Active'
    when lower(trim(policy_status)) in ('cancelled', 'canceled') then 'Cancelled'
    when lower(trim(policy_status)) in ('lapsed', 'dormant') then 'Lapsed'
    else initcap(trim(policy_status))
  end as policy_status,

  coalesce(
    try_to_date(trim(claim_date), 'yyyy-MM-dd'),
    try_to_date(trim(claim_date), 'dd/MM/yyyy'),
    try_to_date(trim(claim_date), 'MM/dd/yyyy'),
    try_to_date(trim(claim_date), 'yyyy/MM/dd'),
    try_to_date(trim(claim_date), 'dd-MMM-yyyy'),
    try_to_date(trim(claim_date), 'MM-dd-yyyy')
  ) as claim_date,

  case
    when claim_amount is null or trim(claim_amount) = '' or lower(trim(claim_amount)) = 'N/A' then null
    else try_cast(regexp_replace(trim(claim_amount), '[^0-9.-]', '') as double)
  end as claim_amount,

  case
    when claim_status is null or trim(claim_status) = '' then 'Unknown'
    when lower(trim(claim_status)) = 'approved' then 'Approved'
    when lower(trim(claim_status)) in ('rejected', 'declined') then 'Rejected'
    when lower(trim(claim_status)) in ('pending', 'in review') then 'Pending'
    else initcap(trim(claim_status))
  end as claim_status,

  case
    when fraud_flag is null or trim(fraud_flag) = '' then 'Unknown'
    when lower(trim(fraud_flag)) in ('yes', 'y', '1') then 'Yes'
    when lower(trim(fraud_flag)) in ('no', 'n', '0') then 'No'
    else 'unknown'
  end as fraud_flag,

  case
    when customer_id is null or trim(customer_id) = '' then 'Missing Customer ID'
    else 'Valid Customer ID'
  end as customer_id_status,

  case
    when claim_id is null or trim(claim_id) = '' then 'Missing Claim ID'
    else 'Valid Claim ID'
  end as claim_id_status

from dfa_insurance_project_raw_dataset;

-- COMMAND ----------

-- DBTITLE 1,show table
select
  *
  from clean_insurance_project_data;

-- COMMAND ----------

-- DBTITLE 1,gender
select
  gender,
  count(*) as total_records
from clean_insurance_project_data
group by gender
order by total_records desc;

-- COMMAND ----------

-- DBTITLE 1,fraud flag
select
  fraud_flag,
  count(*) as total_records
from clean_insurance_project_data
group by fraud_flag
order by total_records desc;

-- COMMAND ----------

-- DBTITLE 1,provinces
select
  province,
  count(*) as total_records
from clean_insurance_project_data
group by province
order by total_records desc;

-- COMMAND ----------

select
  policy_type,
  count(*) as total_records
from clean_insurance_project_data
group by policy_type
order by total_records desc;

-- COMMAND ----------

select 
  policy_status,
  count(*) as total_records
from clean_insurance_project_data
group by policy_status
order by total_records desc;

-- COMMAND ----------

select 
  claim_status,
  count(*) as total_records
from clean_insurance_project_data
group by claim_status
order by total_records desc;

-- COMMAND ----------

select
  sum(case 
    when gender = 'unknown' then 1 else 0 end) as unknown_gender_after_cleaning,

  sum(case
    when province = 'unknown' then 1 else 0 end) as unknown_province_after_cleaning,

  sum(case
    when age is null then 1 else 0 end) as null_age_after_cleaning,

  sum(case
    when age < 18 or age > 100 then 1 else 0 end) as invalid_age_after_cleaning,

  sum(case
    when join_date is null then 1 else 0 end) as null_join_date_after_cleaning,

  sum(case
    when premium_amount is null then 1 else 0 end) as null_premium_amount_after_cleaning,

  sum(case
    when claim_amount is null then 1 else 0 end) as null_claim_amount_after_cleaning,

  sum(case
    when fraud_flag = 'unknown' then 1 else 0 end) as unknown_fraud_flag_after_cleaning

from clean_insurance_project_data;

-- COMMAND ----------

describe clean_insurance_project_data;

-- COMMAND ----------

-- DBTITLE 1,negative claims
select
  *
from
  clean_insurance_project_data
where claim_amount < 0;

-- COMMAND ----------

select
  *
from
  clean_insurance_project_data
where claim_amount is null;

-- COMMAND ----------

select 
  customer_id,
  count(*) as total_records
from clean_insurance_project_data
group by customer_id
having count(*) > 1
order by total_records desc;

-- COMMAND ----------

select count(*) as total_rows,
count(*) as distinct_rows
from (
  select distinct *
  from clean_insurance_project_data
);

-- COMMAND ----------

select
  *
  from
  clean_insurance_project_data;

-- COMMAND ----------

select
  customer_id,
  policy_id,
  claim_id,
  claim_amount,
  count(*) as total_records
from
  clean_insurance_project_data
group by
  customer_id,
  policy_id,
  claim_id,
  claim_amount
  having count(*) > 1;

-- COMMAND ----------

-- DBTITLE 1,create another view to replace the other one
create or replace temp view clean_insurance_data_view as
with deduped as (
  select
    *,
    row_number() over (
      partition by
        customer_id,
        policy_id,
        claim_id,
        claim_amount
      order by customer_id
    ) as rn
  from clean_insurance_project_data
)

select
  customer_id,
  policy_id,
  claim_id,
  age,
  gender,
  province,
  monthly_income,
  join_date,
  policy_type,
  premium_amount,
  policy_status,
  claim_date,
  claim_amount,
  claim_status,
  fraud_flag,
  customer_id_status,
  claim_id_status
from deduped
where rn = 1
  and (claim_amount is null or claim_amount >= 0);

-- COMMAND ----------

select
  *
from
  clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,comfirm no duplicates
select
  customer_id,
  policy_id,
  claim_id,
  claim_amount,
  count(*) as total_records
from clean_insurance_data_view
group by
  customer_id,
  policy_id,
  claim_id,
  claim_amount
having count(*) > 1;

-- COMMAND ----------

-- DBTITLE 1,confirm no negative claims
select 
  count(*) as negative_claims
  from clean_insurance_data_view
  where claim_amount < 0;

-- COMMAND ----------

select 
  count(*) as total_rows
from clean_insurance_data_view;

-- COMMAND ----------

select
  sum(case 
    when gender = 'unknown' then 1 else 0 end) as unknown_gender_after_cleaning,

  sum(case
    when province = 'unknown' then 1 else 0 end) as unknown_province_after_cleaning,

  sum(case
    when age is null then 1 else 0 end) as null_age_after_cleaning,

  sum(case
    when age < 18 or age > 100 then 1 else 0 end) as invalid_age_after_cleaning,

  sum(case
    when join_date is null then 1 else 0 end) as null_join_date_after_cleaning,

  sum(case
    when premium_amount is null then 1 else 0 end) as null_premium_amount_after_cleaning,

  sum(case
    when claim_amount is null then 1 else 0 end) as null_claim_amount_after_cleaning,

  sum(case
    when fraud_flag = 'unknown' then 1 else 0 end) as unknown_fraud_flag_after_cleaning

from clean_insurance_data_view;

-- COMMAND ----------

 select
  customer_id,

  count(*) as total_records
from clean_insurance_data_view
group by
  customer_id

having count(*) > 1;

-- COMMAND ----------

select
  
  policy_id,
 
  count(*) as total_records
from clean_insurance_data_view
group by
  
  policy_id
  
having count(*) > 1;

-- COMMAND ----------

select
  
  claim_id,
 
  count(*) as total_records
from clean_insurance_data_view
group by
 
  claim_id
  
having count(*) > 1;

-- COMMAND ----------

select  
  *
  from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,duplicates or not?
select *
from clean_insurance_data_view
where customer_id in ('CUST1044', 'CUST1501')
order by claim_id, claim_amount;

-- COMMAND ----------

-- DBTITLE 1,duplicates or not?
select *
from clean_insurance_data_view
where policy_id in ('POL5044', 'POL5501')
order by claim_amount;

-- COMMAND ----------

-- DBTITLE 1,duplicates
select *
from clean_insurance_data_view
where claim_id in ('CLM9044', 'null')
order by claim_amount;


-- COMMAND ----------

-- DBTITLE 1,show duplicates remaining
select
  customer_id,
  policy_id,
  claim_id,
  claim_amount
from clean_insurance_data_view
where (customer_id, policy_id, claim_id) in (
  select
    customer_id,
    policy_id,
    claim_id
  from clean_insurance_data_view
  group by
    customer_id,
    policy_id,
    claim_id
  having count(*) > 1
)
order by policy_id, claim_id, claim_amount;

-- COMMAND ----------

-- DBTITLE 1,deduping the table
create or replace temp view clean_insurance_data_view as
with deduped as (
  select
    *,
    row_number() over (
      partition by
        customer_id,
        policy_id,
        claim_id
      order by claim_amount desc
    ) as rn
  from clean_insurance_project_data
)

select *
from deduped
where rn = 1
  and (claim_amount is null or claim_amount >= 0);

-- COMMAND ----------

select
  *
from
  clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,total records
select 
  count(*) as total_records
from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,checking null or duplicate fixed
select *
from clean_insurance_data_view
where claim_id in ('CLM9044', 'null')
order by claim_amount;


-- COMMAND ----------

select
  customer_id,
  policy_id,
  claim_id,
  claim_amount,
  count(*) as total_records
from
  clean_insurance_data_view
group by
  customer_id,
  policy_id,
  claim_id,
  claim_amount
  having count(*) > 1;

-- COMMAND ----------

select
  customer_id,
  policy_id,

  claim_amount,
  count(*) as total_records
from
  clean_insurance_data_view
group by
  customer_id,
  policy_id,
 
  claim_amount
  having count(*) > 1;

-- COMMAND ----------

select
count(*) as cleaned_rows,
count(distinct claim_id) as unique_claim_ids,
count(distinct policy_id) as unique_policy_ids,
count(distinct customer_id) as unique_customer_ids,
count(distinct province) as unique_provinces,

  sum(case
    when age is null then 1 else 0 end) as null_age_after_cleaning,

  sum(case
    when age < 18 or age > 100 then 1 else 0 end) as invalid_age_after_cleaning,

  sum(case
    when join_date is null then 1 else 0 end) as null_join_date_after_cleaning,

  sum(case
    when premium_amount is null then 1 else 0 end) as null_premium_amount_after_cleaning,

  sum(case
    when claim_amount is null then 1 else 0 end) as null_claim_amount_after_cleaning,

  sum(case
    when fraud_flag = 'unknown' then 1 else 0 end) as unknown_fraud_flag_after_cleaning

from clean_insurance_data_view;

-- COMMAND ----------

select count(*) as null_claim_ids
from clean_insurance_data_view
where claim_id is null;

-- COMMAND ----------

-- DBTITLE 1,final dedup
create or replace temp view clean_insurance_data_view as
with prepared_data as (
  select
    *
  from clean_insurance_project_data
  where claim_id is not null
    and policy_id is not null
    and customer_id is not null
    and (claim_amount is null or claim_amount >= 0)
),

deduped_data as (
  select
    *,
    row_number() over (
      partition by
        customer_id,
        policy_id,
        claim_id
      order by
        claim_amount desc,
        claim_date desc
    ) as rn
  from prepared_data
)

select
  customer_id,
  policy_id,
  claim_id,
  age,
  gender,
  province,
  monthly_income,
  join_date,
  policy_type,
  premium_amount,
  policy_status,
  claim_date,
  claim_amount,
  claim_status,
  fraud_flag,
  customer_id_status,
  claim_id_status
from deduped_data
where rn = 1;

-- COMMAND ----------

select
  count(*) as cleaned_rows,
  count(distinct claim_id) as unique_claim_ids,
  count(distinct policy_id) as unique_policy_ids,
  count(distinct customer_id) as unique_customer_ids
from clean_insurance_data_view;

-- COMMAND ----------

select
  *
  from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,check null ids
select
  sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
  sum(case when policy_id is null then 1 else 0 end) as null_policy_id,
  sum(case when claim_id is null then 1 else 0 end) as null_claim_id
from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,check duplicates
select
  customer_id,
  policy_id,
  claim_id,
  count(*) as total_records
from clean_insurance_data_view
group by
  customer_id,
  policy_id,
  claim_id
having count(*) > 1;

-- COMMAND ----------

-- DBTITLE 1,see final temp table
select
  *
  from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,create final table
create or replace table clean_insurance_data as
select *
from clean_insurance_data_view;

-- COMMAND ----------

-- DBTITLE 1,see clean final table
select
  *
  from clean_insurance_data;

-- COMMAND ----------

-- DBTITLE 1,total customer
select
count(distinct customer_id) as total_customers,
count(distinct policy_id) as total_policies,
count(distinct claim_id) as total_claims
from clean_insurance_data;

-- COMMAND ----------

-- DBTITLE 1,sum of claim and premium amount
select 
round(sum(claim_amount), 2) as total_claim_amount,
round(sum(premium_amount), 2) as total_premium_amount
from clean_insurance_data;

-- COMMAND ----------

-- DBTITLE 1,claims by policy type
select
  policy_type,
  count(distinct claim_id) as total_claims
from clean_insurance_data
group by policy_type
order by total_claims desc;

-- COMMAND ----------

-- DBTITLE 1,average claim amount
select
  policy_type,
  round(avg(claim_amount), 2) as avg_claim_amount
from clean_insurance_data
group by policy_type
order by avg_claim_amount desc;

-- COMMAND ----------

-- DBTITLE 1,fraud vs non-fraud
select
  fraud_flag,
  count(distinct claim_id) as total_claims
from clean_insurance_data
group by fraud_flag
order by total_claims desc;

-- COMMAND ----------

-- DBTITLE 1,fraud by province
select
  province,
  count(distinct claim_id) as fraud_claims
from clean_insurance_data
where fraud_flag = 'Yes'
group by province
order by fraud_claims desc;

-- COMMAND ----------

-- DBTITLE 1,fraud by policy type
select
  policy_type,
  count(distinct claim_id) as fraud_claims
from clean_insurance_data
where fraud_flag = 'Yes'
group by policy_type
order by fraud_claims desc;

-- COMMAND ----------

-- DBTITLE 1,top 5 highest claim amounts
select
  claim_id,
  customer_id,
  policy_id,
  policy_type,
  province,
  claim_amount
from clean_insurance_data
order by claim_amount desc
limit 5;

-- COMMAND ----------

-- DBTITLE 1,claims per province
select
  province,
  count(distinct claim_id) as total_claims
from clean_insurance_data
group by province
order by total_claims desc;

-- COMMAND ----------

select
  policy_type,
  round(sum(premium_amount), 2) as total_premium_amount,
  round(sum(claim_amount), 2) as total_claim_amount,
  round(sum(claim_amount) - sum(premium_amount), 2) as claim_vs_premium_gap
from clean_insurance_data
group by policy_type
order by claim_vs_premium_gap desc;

-- COMMAND ----------

-- DBTITLE 1,loss ratio
select
  round(sum(claim_amount), 2) as total_claim_amount,
  round(sum(premium_amount), 2) as total_premium_amount,
  round(
    sum(claim_amount) / sum(premium_amount),
    4
  ) as loss_ratio
from clean_insurance_data;

-- COMMAND ----------

-- DBTITLE 1,which policy type is risky?
select
  policy_type,
  round(sum(claim_amount), 2) as total_claim_amount,
  round(sum(premium_amount), 2) as total_premium_amount,
  round(
    sum(claim_amount) / sum(premium_amount),
    2
  ) as loss_ratio
from clean_insurance_data
group by policy_type
order by loss_ratio desc;

-- COMMAND ----------

-- DBTITLE 1,download final clean dataset for power bi
select
  *
  from clean_insurance_data;