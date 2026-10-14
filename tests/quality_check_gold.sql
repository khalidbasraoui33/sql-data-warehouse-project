/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results


SELECT
    customer_number_unique,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_number_unique
HAVING COUNT(*) > 1;


-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results


SELECT
    product_number_unique,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_number_unique
HAVING COUNT(*) > 1;



-- Check the data model connectivity between fact and dimensions


SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_number_unique = f.customer_number_unique
LEFT JOIN gold.dim_products p
ON p.product_number_unique = f.product_number_unique
