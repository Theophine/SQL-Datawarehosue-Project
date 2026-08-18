
-- Silver Database quality check for the silver.crm_cust_info table

-- Ensuring that the primary keys have not nulls and/or duplicates
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
-- Ensuring that the date columns have valid date formats and are within expected ranges


-- Check that the primary keys do not contain nulls and duplicate values 

select cst_id, count(*) as duplicate_count from silver.crm_cust_info where cst_id is not null  group by cst_id having count(*) > 1;


-- Check that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
select * from silver.crm_cust_info 
where cst_firstname <> TRIM(cst_firstname)
or cst_lastname <> TRIM(cst_lastname)
or cst_marital_status <> TRIM(cst_marital_status)
or cst_gndr <> TRIM(cst_gndr);

-- check for data standardization in the cst_marital_status and cst_gndr columns. For example, you can run the following queries to identify any inconsistent values in these columns:
select DISTINCT cst_marital_status from silver.crm_cust_info;
select DISTINCT cst_gndr from silver.crm_cust_info;


-- Check that the date columns have valid date formats and are within expected ranges
select * from silver.crm_cust_info 
where ISDATE(cast(cst_create_date as VARCHAR(50))) = 1;



-- -- Silver Database quality check for the silver.crm_prod_info table

-- Ensuring that the primary keys have not nulls and/or duplicates
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to
-- uppercase/lowercase)
-- Ensuring that the date columns have valid date formats and are within expected ranges

-- Check that the primary keys do not contain nulls and duplicate values
select prd_id, count(*) as duplicate_count from silver.crm_prod_info where prd_id is not null  group by prd_id having count(*) > 1;


-- check for white spaces in the string columns

select * from silver.crm_prod_info 
where prd_key <> TRIM(prd_key)
or prd_nm <> TRIM(prd_nm)
or prd_line <> TRIM(prd_line);

-- check for data inconsitency in categorical columns; prd_line for example
select DISTINCT prd_line from silver.crm_prod_info;

-- check that the numeric columns do not contain negative values or null 
select * from silver.crm_prod_info 
where prd_cost < 0 or prd_cost is null;

-- check that the date columns have valid date formats and are within expected ranges
select * from silver.crm_prod_info 
where isdate(cast(prd_start_dt as VARCHAR(50))) = 0;

-- check that the start date is always greater than the end date
select * from silver.crm_prod_info 
where prd_start_dt > prd_end_dt;



-- Silver Database quality check for the silver.crm_sales_details table
-- Ensuring that the primary keys have not nulls and/or duplicates
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
-- Ensuring that the date columns have valid date formats and are within expected ranges                        
-- Check that the primary keys do not contain nulls and duplicate values

-- check for invalid date orders in the sales details table, such as order date being after the ship date or due date

select * from silver.crm_sales_details 
where sls_order_dt > sls_ship_dt
or sls_order_dt > sls_due_dt 
or sls_ship_dt > sls_due_dt;   

-- check for negative or null values in the sales, quantity, and price columns
select * from silver.crm_sales_details 
where sls_quantity < 0 or sls_quantity is null  
or sls_sales < 0 or sls_sales is null
or sls_price < 0 or sls_price is null;

-- check for white spaces in the string columns
select * from silver.crm_sales_details 
where sls_prd_key <> TRIM(sls_prd_key)
or sls_ord_num <> TRIM(sls_ord_num);

-- check for iinconsitency in the numeric columns; for example, check that the sales amount is equal to the quantity multiplied by the price
select * from silver.crm_sales_details 
where sls_sales <> sls_quantity * sls_price;




-- Silver Database quality check for the silver.erp_cust_az12 table 
-- Ensuring that the primary keys have not nulls and/or duplicates  
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
-- Ensuring that the date columns have valid date formats and are within expected ranges
-- Check that the primary keys do not contain nulls and duplicate values

select CID, count(*) as duplicate_count from silver.erp_cust_az12 where CID is not null  group by CID having count(*) > 1;

-- check for white spaces in the string columns
select * from silver.erp_cust_az12 
where CID <> TRIM(CID)  or GEN <> TRIM(GEN);

-- check for data inconsitency in categorical columns; GEN for example
select DISTINCT GEN from silver.erp_cust_az12;

-- check that the date columns have valid date formats and are within expected ranges
select * from silver.erp_cust_az12 
where ISDATE(cast(BDATE as VARCHAR(50))) = 0;

-- check that the birth date is not in the future
select * from silver.erp_cust_az12 
where BDATE > GETDATE();



-- Silver Database quality check for the silver.erp_loc_a101 table 
-- Ensuring that the primary keys have not nulls and/or duplicates
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
-- Check that the primary keys do not contain nulls and duplicate values        

select CID, count(*) as duplicate_count from silver.erp_loc_a101 where CID is not null  group by CID having count(*) > 1;   

-- check for white spaces in the string columns
select * from silver.erp_loc_a101 
where CID <> TRIM(CID)  or CNTRY <> TRIM(CNTRY);

-- check for consistency in the country column 
select distinct CNTRY from silver.erp_loc_a101 



-- Silver Database quality check for the silver.erp_px_cat_g1v2 table 
-- Ensuring that the primary keys have not nulls and/or duplicates
-- Ensuring that the string columns have consistent formatting (e.g., trimming whitespace, converting to uppercase/lowercase)
-- Check that the primary keys do not contain nulls and duplicate values

select ID, count(*) as duplicate_count from silver.erp_px_cat_g1v2 where ID is not null  group by ID having count(*) > 1;

-- check for white spaces in the string columns
select * from silver.erp_px_cat_g1v2 
where ID <> TRIM(ID)  or CAT <> TRIM(CAT) 
OR SUBCAT <> TRIM(SUBCAT) OR MAINTENANCE <> TRIM(MAINTENANCE); 

-- check for data inconsitency in categorical columns; MAINTENANCE for example
select DISTINCT MAINTENANCE from silver.erp_px_cat_g1v2;

