
-- Below I want to create a dynamic SQL statement, which I can then execute. Firstly, I want to create a stored 
-- procure called dbo.test_dynamic_sql and then within it, create and execute a view called dbo.test_view

create or alter procedure dbo.test_dynamic_sql as

begin
-- Creating the test_view
    EXECUTE(
        'create or alter view dbo.test_view as select * from bronze.crm_cust_info'
    );

 -- Creating the gold.dim_customer view which is a combination of the silver.crm_cust_info, silver.erp_cust_az12 and silver.erp_loc_a101 tables
    EXEc(
        'create or alter view dbo.dim_customer as

    select 
        ROW_NUMBER() over (order by c.cst_id) as customer_key,
        c.cst_id as customer_id, 
        c.cst_key as customer_number,
        c.cst_firstname as first_name,
        c.cst_lastname as last_name,
        c.cst_marital_status as marital_status,
        replace(c.cst_gndr, ''n/a'', GEN) as gender,
        cl.CNTRY as country,
        ce.BDATE as birthdate
    from silver.crm_cust_info c
    left join silver.erp_loc_a101 cl on c.cst_key = cl.CID
    left join silver.erp_cust_az12 ce on c.cst_key = ce.CID'
    );

end 

-- Executing the stored procedure
exec dbo.test_dynamic_sql;