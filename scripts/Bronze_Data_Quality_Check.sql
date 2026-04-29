

-- BRONZE LAYER DATA QUALITY CHECKS

-- Data Completeness: Check for null values in critical columns, such as primary keys or foreign keys. For example, you can run a query like:
-- Schema Checks: Make sure your data is transferred into the correct schema and that the table structure matches your expectations. You can use queries like:

create or alter procedure bronze.data_quality_checks_Procedure
as 

BEGIN

        declare @start_time datetime2(6);
        declare @end_time DATETIME2(6);
        set @start_time = getdate();

        begin try

    select count(*) from bronze.crm_cust_info;
    select count(*) from bronze.crm_prod_info;
    select count(*) from bronze.crm_sales_details;
    select count(*) from bronze.erp_cust_az12;
    select count(*) from bronze.erp_loc_a101;
    select count(*) from bronze.erp_px_cat_g1v2; 
        
        end try 

        begin catch 
            print 'Error in counting records: ' + error_message();
        end catch

        begin try 
-- Check for data shift: Ensure that the values in the newly loaded table are in the right columns
select top 5 * from bronze.crm_cust_info;
select top 5 * from bronze.crm_prod_info;
select top 5 * from bronze.crm_sales_details;

        end try 

        begin catch 
            print 'Error in checking data shift: ' + error_message();
            print 'Please verify that the data is in the correct columns and that there are no shifts in the data structure.'
        end catch

    set @end_time = getdate();

    begin try
    Print('Duration of data quality checks: ' + cast(datediff(second, @start_time, @end_time) as varchar(10)) + ' seconds.');
    end TRY

    BEGIN CATCH
    PRINT 'Error in calculating duration: ' + ERROR_MESSAGE();
    END CATCH


END
