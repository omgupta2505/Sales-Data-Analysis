1. Dataset Overview
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT invoice) AS invoices,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT stock_code) AS products,
    COUNT(DISTINCT country) AS countries,
    MIN(invoice_date) AS first_date,
    MAX(invoice_date) AS last_date
FROM retail_raw;

2. Total Revenue and Average Order Value
SELECT
    ROUND(SUM(quantity * price), 2) AS total_revenue,
    ROUND(
        SUM(quantity * price) /
        NULLIF(COUNT(DISTINCT invoice), 0), 2
    ) AS avg_order_value
FROM retail_raw;


3. Monthly Revenue and Orders
SELECT
    TO_CHAR(DATE_TRUNC('month', invoice_date), 'YYYY-MM') AS month,
    ROUND(SUM(quantity * price), 2) AS revenue,
    COUNT(DISTINCT invoice) AS orders
FROM retail_raw
GROUP BY 1
ORDER BY 1;


4. Country-wise Revenue Analysis
SELECT
    country,
    ROUND(SUM(quantity * price), 2) AS revenue,
    COUNT(DISTINCT customer_id) AS customers
FROM retail_raw
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;


 5. Top 10 Products by Units Sold
SELECT
    stock_code,
    description,
    SUM(quantity) AS units_sold
FROM retail_raw
GROUP BY stock_code, description
ORDER BY units_sold DESC
LIMIT 10;


 6. Top 10 Products by Revenue
SELECT
    stock_code,
    description,
    ROUND(SUM(quantity * price), 2) AS revenue
FROM retail_raw
GROUP BY stock_code, description
ORDER BY revenue DESC
LIMIT 10;


 7. Top 10 Customers by Spending
SELECT
    customer_id,
    ROUND(SUM(quantity * price), 2) AS spend,
    COUNT(DISTINCT invoice) AS orders
FROM retail_raw
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY spend DESC
LIMIT 10;


 8. Day-wise Sales Analysis
SELECT
    EXTRACT(DOW FROM invoice_date)::INT AS dow,
    TO_CHAR(invoice_date, 'Dy') AS day,
    COUNT(DISTINCT invoice) AS orders,
    ROUND(SUM(quantity * price), 2) AS revenue
FROM retail_raw
GROUP BY 1, 2
ORDER BY 1;


 9. Hour-wise Order Analysis
SELECT
    EXTRACT(HOUR FROM invoice_date)::INT AS hour,
    COUNT(DISTINCT invoice) AS orders
FROM retail_raw
GROUP BY 1
ORDER BY 1;


 10. Customer RFM Analysis
SELECT
    customer_id,
    MAX(invoice_date)::DATE AS last_purchase,
    COUNT(DISTINCT invoice) AS frequency,
    ROUND(SUM(quantity * price), 2) AS monetary
FROM retail_raw
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY monetary DESC;


 