# Zepto Inventory & Sales Data Analysis (SQL)

Exploratory data analysis and data cleaning project on a Zepto (Indian quick-commerce) product inventory dataset, written in PostgreSQL.

## Overview

This project involves:
- Setting up a `zepto` table with product-level data (category, MRP, discount %, stock status, weight, etc.)
- Data exploration (row counts, null checks, duplicate detection, category listing)
- Data cleaning (removing zero-price entries, converting paise to rupees)
- Business analysis via SQL queries

## Tech Stack

- PostgreSQL

## Table Schema

| Column | Type | Description |
|---|---|---|
| sku_id | SERIAL (PK) | Unique product ID |
| Category | VARCHAR(120) | Product category |
| name | VARCHAR(150) | Product name |
| mrp | NUMERIC(8,2) | Maximum retail price |
| discountPercent | NUMERIC(5,2) | Discount percentage |
| availableQuantity | INTEGER | Units available |
| discountedSellingPrice | NUMERIC(8,2) | Price after discount |
| weightInGms | INTEGER | Product weight in grams |
| outOfStock | BOOLEAN | Stock status |
| quantity | INTEGER | Order quantity |

## Business Questions Answered

1. Top 10 best-value products based on discount percentage
2. Products with high MRP that are out of stock
3. Estimated revenue per category
4. Products with MRP > ₹500 and discount < 10%
5. Top 5 categories by average discount percentage
6. Price-per-gram analysis for products above 100g
7. Weight-based product segmentation (Low / Medium / Bulk)
8. Total inventory weight per category

## How to Run

1. Create a PostgreSQL database.
2. Run `new_project.sql` in order — it creates the table, loads exploration/cleaning queries, and the analysis queries.

## Author

Ronak
