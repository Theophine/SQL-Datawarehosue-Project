
-- write a sql script to create a stored procedure called gold.create_views_Procedure to create the views in the gold layer
Create or alter procedure gold.create_views_Procedure 
as 

begin 

    -- create the gold.dim_customer view which is a combination of the silver.crm_cust_info, silver.erp_cust_az12 and silver.erp_loc_a101 tables

    Execute(        
    'create or alter view gold.dim_customer as

    -- Creating the gold.dim_customer view which is a combination of the silver.crm_cust_info, silver.erp_cust_az12 and silver.erp_loc_a101 tables
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
    left join silver.erp_cust_az12 ce on c.cst_key = ce.CID');
    

    -- check that the view is created correctly
    --select * from gold.dim_customer;


    -- create the gold.dim_product view which is a combination of the silver.crm_prod_info and silver.erp_px_cat_g1v2 tables
   
   Execute(
       'create or alter view gold.dim_product as  


    select 
        ROW_NUMBER() over (order by p.prd_id) as product_key,
        p.prd_id as product_id,
        p.cat_id as category_id,
        p.prd_key as product_number,
        p.prd_nm as product_name,
        p.prd_cost as product_cost,
        p.prd_line as product_line,
        p.prd_start_dt as product_start_date,
        p.prd_end_dt as product_end_date,
        c.CAT as category,
        c.SUBCAT as subcategory, 
        c.MAINTENANCE as maintenance
    from silver.crm_prod_info p
    left join silver.erp_px_cat_g1v2 c on p.cat_id = c.ID
    where p.prd_end_dt is null');


    -- check that the view is created correctly
    --select * from gold.dim_product;



    -- create the gold.fact_sales which we get from the silver.crm_sales_details table. Get the surrogate keys from the gold.dim_customer and gold.dim_product views
    Execute( 'create or alter view gold.fact_sales as
    select 
        s.sls_ord_num as order_number,
        c.customer_key as customer_key,
        p.product_key as product_key,
        s.sls_order_dt as order_date,
        s.sls_ship_dt as shipping_date,
        s.sls_due_dt as due_date, 
        s.sls_sales as sales,
        s.sls_quantity as quantity,
        s.sls_price as price
    from silver.crm_sales_details s
    left join gold.dim_customer c on s.sls_cust_id = c.customer_id
    left join gold.dim_product p on s.sls_prd_key = p.product_number')
    
End 

-- 
--execute gold.create_views_Procedure;






