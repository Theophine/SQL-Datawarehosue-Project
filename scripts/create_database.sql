

create or alter procedure bronze.create_tables_Procedure
as 

BEGIN 

    begin try

set dateformat dmy;
--- cst_id	cst_key	cst_firstname	cst_lastname	cst_marital_status	cst_gndr	cst_create_date

-- Checking if the bronze.crm_cust_info table exists and dropping it if it does
BEGIN TRY
if OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info; 
 
-- Creating the bronze.crm_cust_info table with the specified columns and primary key constraint
create table bronze.crm_cust_info (
    cst_id INT, 
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(5),
    cst_gndr VARCHAR(5),
    cst_create_date DATE
); 
print('bronze.crm_cust_info table created successfully.')
END TRY
BEGIN CATCH
PRINT 'Error in creating crm_cust_info table: ' + ERROR_MESSAGE();
END CATCH






-- Checking if the bronze.crm_prod_info table exists and dropping it if it does

--- prd_id	prd_key	prd_nm	prd_cost	prd_line	prd_start_dt	prd_end_dt

BEGIN TRY
if OBJECT_ID('bronze.crm_prod_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prod_info;        


create table bronze.crm_prod_info (
    prd_id int,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost int,
    prd_line VARCHAR(10),
    prd_start_dt DATE,
    prd_end_dt DATE 
);

print('bronze.crm_prod_info table created successfully.')
END TRY
 
 
BEGIN CATCH
PRINT 'Error in creating crm_prod_info table: ' + ERROR_MESSAGE();
END CATCH


--  sls_ord_num	sls_prd_key	sls_cust_id	sls_order_dt	sls_ship_dt	sls_due_dt	sls_sales	sls_quantity	sls_price


-- Checking if the bronze.crm_sales_details table exists and dropping it if it does
BEGIN TRY
if OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

-- Creating the bronze.crm_sales_details table with the specified columns and primary key constraint
create table bronze.crm_sales_details (
    sls_ord_num varchar(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id int,    
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);

print 'bronze.crm_sales_details table created successfully.'
END TRY
BEGIN CATCH
PRINT 'Error in creating crm_sales_details table: ' + ERROR_MESSAGE();
END CATCH
 



-- Time to creat the tableS for the erp source system

-- CID	BDATE	GEN

-- Checking if the bronze.erp_cust_az12 table exists and dropping it if it does
BEGIN TRY 
if object_id ('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

-- Creating the bronze.erp_cust_az12 table with the specified columns and primary key constraint
create table bronze.erp_cust_az12 ( 
    CID varchar(50),
    BDATE date,
    GEN VARCHAR(10)  
)
print('bronze.erp_cust_az12 table created successfully.')
END TRY 
BEGIN CATCH 
PRINT 'Error in creating erp_cust_az12 table: ' + ERROR_MESSAGE();
END CATCH





-- Checking if the bronze.erp_loc_a101 table exists and dropping it if it does
-- CID	CNTRY

BEGIN TRY
if object_id('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;

-- Creating the bronze.erp_loc_a101 table with the specified columns and primary key constraint 
create table bronze.erp_loc_a101 (
    CID varchar(50),
    CNTRY VARCHAR(50)
)
PRINT('bronze.erp_loc_a101 table created successfully.')
END TRY
BEGIN CATCH
PRINT 'Error in creating erp_loc_a101 table: ' + ERROR_MESSAGE();
END CATCH




---------------------------------------------------------------------------------------------


-- ID	CAT	SUBCAT	MAINTENANCE

-- Checking if the bronze.erp_px_cat_g1v2 table exists and dropping it if it does
BEGIN TRY
if object_id('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

create table bronze.erp_px_cat_g1v2 (
    ID varchar(10),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(10)
)
print('bronze.erp_px_cat_g1v2 table created successfully.')
END TRY 
BEGIN CATCH
PRINT('Error in creating erp_px_cat_g1v2 table: ' + ERROR_MESSAGE());
END CATCH



    END TRY
    BEGIN CATCH
        PRINT 'Error in creating tables: ' + ERROR_MESSAGE();
    END CATCH
END







