/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'bronze' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Bronze Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


-------------------CUSTOMERS-------------------

SELECT * FROM bronze.crm_cust_info

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
    cst_id,
    COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check the unwanted spaces

SELECT cst_firstname, cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname)


-- Check the standarization for marital status and gender

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info


-------------------PRODUCTS-------------------

SELECT * FROM bronze.crm_prd_info;



-- Check the nulls value in prd_cost

SELECT * FROM bronze.crm_prd_info
WHERE prd_cost IS NULL


-- Check the standarization for prd_line

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check the validation date for prd_start_dt and prd_end_dt

SELECT * FROM bronze.crm_prd_info
WHERE   prd_start_dt > prd_end_dt


-------------------SALES-------------------

SELECT * FROM bronze.crm_sales_details

-- Check the validation of the amount of sales is real

SELECT * FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * ABS(sls_price)

-- Check the the quantity is negatif

SELECT * FROM bronze.crm_sales_details
WHERE sls_quantity < 1

-- Check the validation of the price is real

SELECT * FROM bronze.crm_sales_details
WHERE sls_price != sls_sales / sls_quantity



-------------------CUST_AZ12-------------------


SELECT * FROM bronze.erp_cust_az12


-- Check invalid values for birthdate

SELECT * FROM bronze.erp_cust_az12
WHERE bdate > GETDATE()

-- Data standarization

SELECT DISTINCT gen FROM bronze.erp_cust_az12


WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), ''))) IN ('F', 'FEMALE') THEN 'Female'



-------------------LOCA101-------------------


SELECT * FROM bronze.erp_loc_a101


-- Check the standarization for countries

SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101


-------------------PX_CAT_G1V2-------------------


SELECT * FROM bronze.erp_px_cat_g1v2


-- Standarization of columns cat, subcat, maintenance

SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2


