
-- Gold layer data quality check for the gold.dim_customer view
-- Ensuring that the primary keys have not nulls and/or duplicates

select customer_key, customer_number, count(*) as duplicate_count from gold.dim_customer where customer_key is not null and customer_number is not null  group by customer_key, customer_number having count(*) > 1;

-- check for white spaces in the string columns
select * from gold.dim_customer 
where customer_number <> TRIM(customer_number)  or first_name <> TRIM(first_name) or last_name <> TRIM(last_name) 
OR marital_status <> TRIM(marital_status) OR gender <> TRIM(gender) OR country <> TRIM(country);

-- check for data inconsitency in categorical columns; gender for example
select DISTINCT gender from gold.dim_customer;



-- Gold layer data quality check for the gold.dim_product view
-- Ensuring that the primary keys have not nulls and/or duplicates

select product_key, category_id, count(*) as duplicate_count from gold.dim_product where product_key is not null and category_id is not null  group by product_key, category_id having count(*) > 1;

-- check for white spaces in the string columns 
select * from gold.dim_product
where category_id <> TRIM(category_id) 
OR product_name <> TRIM(product_name) OR product_line <> TRIM(product_line)
or category <> TRIM(category) or subcategory <> TRIM(subcategory) or maintenance <> TRIM(maintenance);

-- check for data inconsitency in categorical columns; maintenance for example
select DISTINCT maintenance from gold.dim_product;



-- Gold layer data quality check for the gold.fact_sales view
-- The major check here is to ensure that you can connect the dimension views to the fact view and that everything matches correctly 

select * from gold.fact_sales f
left join gold.dim_customer c on f.customer_key = c.customer_key
left join gold.dim_product p on f.product_key = p.product_key
where f.customer_key is null or f.product_key is null;


select top 3 * from gold.dim_product; 