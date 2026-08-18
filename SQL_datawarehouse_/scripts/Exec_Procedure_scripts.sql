
-- Run the procedure to create tables in the bronze layer

Exec bronze.create_tables_Procedure;
GO

-- Run the procedure to create tables in the silver layer
Exec silver.create_tables_Procedure;
GO


-- Run the procedure to perform data quality checks on the bronze layer
Exec bronze.data_quality_checks_Procedure;
GO


-- run the procedure to transform the data in the bronze layer into the silver layer
Exec silver.Transform_and_load_into_silver_table;
GO


