
create or alter procedure silver.create_tables_Procedure
as 

BEGIN 

    begin try

set dateformat dmy;
--- cst_id	cst_key	cst_firstname	cst_lastname	cst_marital_status	cst_gndr	cst_create_date

-- Checking if the silver.crm_cust_info table exists and dropping it if it does
BEGIN TRY
if OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info; 
 
-- Creating the silver.crm_cust_info table with the specified columns and primary key constraint
create table silver.crm_cust_info (
    cst_id INT, 
    cst_key VARCHAR(100),
    cst_firstname VARCHAR(100),
    cst_lastname VARCHAR(100),
    cst_marital_status VARCHAR(100),
    cst_gndr VARCHAR(100),
    cst_create_date DATE
); 
print('silver.crm_cust_info table created successfully.')
END TRY
BEGIN CATCH
PRINT 'Error in creating crm_cust_info table: ' + ERROR_MESSAGE();
END CATCH






-- Checking if the silver.crm_prod_info table exists and dropping it if it does

--- prd_id	prd_key	prd_nm	prd_cost	prd_line	prd_start_dt	prd_end_dt

BEGIN TRY
if OBJECT_ID('silver.crm_prod_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prod_info;        


create table silver.crm_prod_info (
    prd_id int,
    cat_id VARCHAR(100),
    prd_key VARCHAR(100),
    prd_nm VARCHAR(100),
    prd_cost int, 
    prd_line VARCHAR(100),
    prd_start_dt DATE,
    prd_end_dt DATE
);

print('silver.crm_prod_info table created successfully.')
END TRY
 
 
BEGIN CATCH
PRINT 'Error in creating crm_prod_info table: ' + ERROR_MESSAGE();
END CATCH


--  sls_ord_num	sls_prd_key	sls_cust_id	sls_order_dt	sls_ship_dt	sls_due_dt	sls_sales	sls_quantity	sls_price


-- Checking if the silver.crm_sales_details table exists and dropping it if it does
BEGIN TRY
if OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

-- Creating the silver.crm_sales_details table with the specified columns and primary key constraint
create table silver.crm_sales_details (
    sls_ord_num varchar(100),
    sls_prd_key VARCHAR(100),
    sls_cust_id int,    
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales decimal(7,2),
    sls_quantity int,
    sls_price decimal(7,2)
);

print 'silver.crm_sales_details table created successfully.'
END TRY
BEGIN CATCH
PRINT 'Error in creating crm_sales_details table: ' + ERROR_MESSAGE();
END CATCH
 



-- Time to creat the tableS for the erp source system

-- CID	BDATE	GEN

-- Checking if the silver.erp_cust_az12 table exists and dropping it if it does
BEGIN TRY 
if object_id ('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

-- Creating the silver.erp_cust_az12 table with the specified columns and primary key constraint
create table silver.erp_cust_az12 ( 
    CID varchar(100),
    BDATE date,
    GEN VARCHAR(100)
)
print('silver.erp_cust_az12 table created successfully.')
END TRY 
BEGIN CATCH 
PRINT 'Error in creating erp_cust_az12 table: ' + ERROR_MESSAGE();
END CATCH





-- Checking if the silver.erp_loc_a101 table exists and dropping it if it does
-- CID	CNTRY

BEGIN TRY
if object_id('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

-- Creating the silver.erp_loc_a101 table with the specified columns and primary key constraint 
create table silver.erp_loc_a101 (
    CID varchar(100),
    CNTRY VARCHAR(100)
)
PRINT('silver.erp_loc_a101 table created successfully.')
END TRY
BEGIN CATCH
PRINT 'Error in creating erp_loc_a101 table: ' + ERROR_MESSAGE();
END CATCH




---------------------------------------------------------------------------------------------


-- ID	CAT	SUBCAT	MAINTENANCE

-- Checking if the silver.erp_px_cat_g1v2 table exists and dropping it if it does
BEGIN TRY
if object_id('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2 (
    ID varchar(100),
    CAT VARCHAR(100),
    SUBCAT VARCHAR(100),
    MAINTENANCE VARCHAR(100)
)
print('silver.erp_px_cat_g1v2 table created successfully.')
END TRY 
BEGIN CATCH
PRINT('Error in creating erp_px_cat_g1v2 table: ' + ERROR_MESSAGE());
END CATCH



    END TRY
    BEGIN CATCH
        PRINT 'Error in creating tables: ' + ERROR_MESSAGE();
    END CATCH
END







