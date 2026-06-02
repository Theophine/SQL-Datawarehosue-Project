
-- create a stored procedure called silver.table_transformation to transform the data in the bronze layer into the silver layer
-- Ensure to do error checks using the Begin try and begin catch statements

create or alter procedure silver.Transform_and_load_into_silver_table
     
as

BEGIN

    begin try
       

-- check for nulls or Duplicate values within the critical columns; cst_id and cst_key
-- For this, the windows function ROW_NUMBER() can be used to identify duplicates based on the cst_id and cst_key columns. The following query will help you identify any duplicate records in the bronze.crm_cust_info table:

-- Since its a batch load and Replace schema operation, we would truncate the silver.crm_cust_info table before inserting the transformed data from the bronze layer. 
--This ensures that we have a clean slate for the new data and prevents any potential issues with duplicate records or outdated information.

-- clean and load the crm_cust_info table 

TRUNCATE TABLE silver.crm_cust_info;

-- insert into the silver layer after applying the necessary transformations to clean the data and ensure consistency. The transformations include trimming leading and trailing spaces, standardizing the values in the cst_marital_status and cst_gndr columns, and selecting only the latest record for each customer based on the cst_create_date column.
Insert into silver.crm_cust_info 

select 
    cst_id, 
    cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    TRIM(case 
        when TRIM(cst_marital_status) in ('M', 'm') then 'Married'
        when TRIM(cst_marital_status) in ('S', 's') then 'Single'
        else 'n/a'             
    end) as cst_marital_status,
    TRIM(case 
        when TRIM(cst_gndr) in ('M', 'm') then 'Male'
        when TRIM(cst_gndr) in ('F', 'f') then 'Female'
        else 'n/a' 
    end) as cst_gndr,
    cst_create_date 
from (
select *, ROW_NUMBER() over (PARTITION BY cst_id order by cst_create_date desc) as rn
from bronze.crm_cust_info) t 
where cst_id is not null and rn = 1;  

END TRY 

BEGIN CATCH 
    PRINT ('Error in creating crm_cust_info table: ' + ERROR_MESSAGE());
END CATCH

-- check that your query has worked and the data has been transformed as expected by running a select statement on the silver.crm_cust_info table. This will allow you to verify that the transformations have been applied correctly and that the data is now clean and consistent.
-- select * from silver.crm_cust_info; 



-- clean and load the crm_prd_info table into the silver layer
-- select * from bronze.crm_prod_info; 

-- check for nulls or Duplicate values within the critical columns; prd_id and prd_key
-- For this, the windows function ROW_NUMBER() can be used to identify duplicates based on the
-- prd_id and prd_key columns. The following query will help you identify any duplicate records in the bronze.crm_prod_info table: 

BEGIN TRY

truncate table silver.crm_prod_info;

INSERT INTO silver.crm_prod_info 
(
    prd_id, 
    cat_id,
    prd_key, 
    prd_nm, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt
)

select
prd_id, 
replace(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id, 
SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,
TRIM(prd_nm) as prd_nm, 
ISNULL(prd_cost, 0) as prd_cost,  
case 
    WHEN TRIM(prd_line) is null then 'n/a'
    when TRIM(prd_line) in ('S', 's') then 'Other Sales'
    when TRIM(prd_line) in ('M', 'm') then 'Mountain'
    when TRIM(prd_line) in ('R', 'r') then 'Road'
    when TRIM(prd_line) in ('T', 't') then 'Touring'
else 'n/a'
end as prd_line,
CASE 
    WHEN prd_start_dt > prd_end_dt THEN prd_end_dt
    ELSE prd_start_dt
END as prd_start_dt,
LEAD(dateadd(day, -1, (CASE 
    WHEN prd_start_dt > prd_end_dt THEN prd_end_dt 
    ELSE prd_start_dt
END))) over (partition by prd_key order by prd_start_dt asc) as prd_end_dt
from bronze.crm_prod_info; 

END TRY 

BEGIN CATCH
    PRINT ('Error in creating crm_prod_info table: ' + ERROR_MESSAGE());
END CATCH

-- check that your query has worked and the data has been transformed as expected by running a select statement on the silver.crm_prod_info table. This will allow you to verify that the transformations have been applied correctly and that the data is now clean and consistent.
--select * from silver.crm_prod_info;



BEGIN TRY 

-- clean and Load the crm_sales_details table into the silver layer

Truncate table silver.crm_sales_details;

Insert into silver.crm_sales_details 
(
    sls_ord_num, 
    sls_prd_key, 
    sls_cust_id,    
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

select 
sls_ord_num, 
sls_prd_key, 
sls_cust_id,
-- convert the date columns from int to date data type and handle any invalid date formats by replacing them with null values. 
-- This can be achieved using a CASE statement to check for valid date formats and then using the CONVERT function to convert the valid date strings to date data type. 
-- For example, you can use the following query to perform this transformation on the sls_order_dt, sls_ship_dt, and sls_due_dt columns:
CONVERT(date, CAST(
    case 
    WHEN len(nullif(sls_order_dt, 0)) != 8 then null
    else nullif(sls_order_dt, 0)
    END AS varchar(8)), 112) AS sls_order_dt,   
CONVERT(date, CAST(
    case 
    WHEN len(nullif(sls_ship_dt, 0)) != 8 then null
    else nullif(sls_ship_dt, 0)
    END AS varchar(8)), 112) AS sls_ship_dt,
CONVERT(date, CAST(
    case 
    WHEN len(nullif(sls_due_dt, 0)) != 8 then null
    else nullif(sls_due_dt, 0)
    END AS varchar(8)), 112) AS sls_due_dt, 
case 
    when ISNULL(sls_sales, 0) < 0 then abs(ISNULL(sls_sales, 0))
    else ISNULL(sls_sales, 0)  
end as sls_sales, 
sls_quantity,  
-- calculate the sls_price by dividing sls_sales by sls_quantity and handle any potential division by zero errors by using a CASE statement to check for zero values in the sls_quantity column and replacing them with null or a default value as needed.
case
    when round(ISNULL(sls_sales / sls_quantity, 0), 2) < 0 then abs(round(ISNULL(sls_sales / sls_quantity, 0), 2))
    else round(ISNULL(sls_sales / sls_quantity, 0), 2)  
end as sls_price  
from bronze.crm_sales_details; 

END TRY 

BEGIN CATCH
    PRINT ('Error in creating crm_sales_details table: ' + ERROR_MESSAGE());
END CATCH

-- check the result set 
-- select * from silver.crm_sales_details;



BEGIN TRY 

-- clean and Load the erp_cust_az12 table into the silver layer

Truncate table silver.erp_cust_az12;    

Insert into silver.erp_cust_az12 
(
    CID, 
    BDATE, 
    GEN
)

select
    case 
        when len(CID) > 10 then SUBSTRING(CID, 4, LEN(CID))
        else CID
    end as CID,
-- convert the BDATE column from int to date data type and handle any invalid date formats by replacing them with null values.
case 
    when BDATE > getdate() or BDATE < '1950-01-01' then null
    else BDATE
end as BDATE,
case 
    when TRIM(GEN) in ('M', 'm', 'Male') then 'Male'
    when TRIM(GEN) in ('F', 'f', 'Female') then 'Female'
    else 'n/a'  
end as GEN
from bronze.erp_cust_az12;

END TRY 

BEGIN CATCH
    PRINT ('Error in creating erp_cust_az12 table: ' + ERROR_MESSAGE());
END CATCH

-- check the result set
-- select * from silver.erp_cust_az12;


BEGIN TRY 

-- clean and load the erp_loc_a101 table into the silver layer

Truncate table silver.erp_loc_a101;

Insert into silver.erp_loc_a101 
(
    CID, 
    CNTRY
)

select
replace(CID, '-', '') as CID,
case 
    when TRIM(CNTRY) in ('US', 'USA', 'United States') then 'United States'
    when TRIM(CNTRY) in ('CA', 'CAN', 'Canada') then 'Canada'
    when TRIM(CNTRY) in ('DE', 'DEU', 'Germany') then 'Germany'
    when TRIM(CNTRY) in ('FR', 'FRA', 'France') then 'France'
    when TRIM(CNTRY) in ('UK', 'GBR', 'United Kingdom') then 'United Kingdom'
    when TRIM(CNTRY) in ('AU', 'AUS', 'Australia') then 'Australia'
    else 'n/a'  
end as CNTRY 
from bronze.erp_loc_a101; 

END TRY 

BEGIN CATCH
    PRINT ('Error in creating erp_loc_a101 table: ' + ERROR_MESSAGE());
END CATCH

-- check the result set
-- select * from silver.erp_loc_a101;



BEGIN TRY 
-- clean and load the bronze.erp_px_cat_g1v2 table into the silver layer

Truncate table silver.erp_px_cat_g1v2;

Insert into silver.erp_px_cat_g1v2 
(
    ID, 
    CAT, 
    SUBCAT, 
    MAINTENANCE
)

select 
    ID, 
    TRIM(CAT) as CAT, 
    TRIM(SUBCAT) as SUBCAT, 
    TRIM(MAINTENANCE) as MAINTENANCE 
from bronze.erp_px_cat_g1v2;

END TRY

BEGIN CATCH
    PRINT ('Error in creating erp_px_cat_g1v2 table: ' + ERROR_MESSAGE());
END CATCH

-- check for unwanted spaces in categorical columns 
-- select * from silver.erp_px_cat_g1v2

END 



