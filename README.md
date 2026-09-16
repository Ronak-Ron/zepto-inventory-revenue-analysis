# Zepto Inventory & Revenue Analysis (SQL)

An end-to-end SQL analysis of Zepto's e-commerce product inventory dataset — covering data cleaning, exploratory analysis, and advanced business-focused queries using window functions and CTEs.

## Problem Statement

Zepto lists thousands of products across dozens of categories, each with its own pricing, discounting, and stock-availability pattern. This project analyzes that catalog to answer a practical business question: **which categories and products actually drive revenue, where is pricing inconsistent, and where is inventory at risk?**

## Dataset

- Source: Kaggle — Zepto e-commerce inventory dataset
- Grain: one row per SKU
- Key fields: `category`, `name`, `mrp`, `discountPercent`, `availableQuantity`, `discountedSellingPrice`, `weightInGms`, `outOfStock`, `quantity`

## Tools Used

- PostgreSQL
- SQL (joins, aggregation, CTEs, window functions)

## Project Structure

```
zepto-inventory-revenue-analysis/
│
├── README.md
├── zepto_analysis.sql          # data cleaning + Q1–Q8 (core exploratory analysis)
├── advanced_analysis.sql       # Q9–Q13 (window functions, CTEs, anomaly detection)
└── zepto_v2.csv                # raw dataset (if included)
```

## Approach

### 1. Data Cleaning
- Removed products with ₹0 MRP or selling price (invalid rows)
- Converted prices from paise to rupees
- Checked for null values and duplicate product names

### 2. Exploratory Analysis (`zepto_analysis.sql`, Q1–Q8)
- Best-value products by discount %
- High-MRP products that are out of stock
- Estimated revenue per category
- Products with high MRP but low discount
- Top categories by average discount
- Price-per-gram value analysis
- Weight-tier segmentation (Low / Medium / Bulk)
- Total inventory weight per category

### 3. Advanced Analysis (`advanced_analysis.sql`, Q9–Q13)
- **Q9** — Ranked products by discount *within* each category (`RANK() OVER (PARTITION BY ...)`), not just overall
- **Q10** — Each category's % contribution to total revenue (`SUM() OVER ()`)
- **Q11** — Data-quality check: products where discounted price exceeds MRP
- **Q12** — Top 3 highest-revenue products per category (`ROW_NUMBER() OVER (PARTITION BY ...)`)
- **Q13** — Cumulative running-total revenue across categories (Pareto-style analysis)

## Key Insights

> Replace the bracketed values below with your actual query results.

- **Revenue concentration:** The top **[N]** categories account for roughly **[X]%** of total estimated revenue, despite making up only **[Y]%** of listed SKUs.
- **Best discounts by category:** The highest-ranked products by discount are concentrated in **[category names]**, offering discounts of **[X]%+**.
- **Data quality issue found:** **[N]** products were found with a discounted selling price higher than their MRP — a pricing inconsistency worth flagging.
- **Stock-out risk:** **[N]** products with an MRP above ₹300 are currently out of stock, representing an estimated **₹[X]** in unavailable inventory value.
- **Top products per category:** The highest-revenue products cluster in **[category names]**, suggesting these should be prioritized for restocking.

## How to Run

1. Create a PostgreSQL database and run `zepto_analysis.sql` to create the table, clean the data, and run the core exploratory queries.
2. Run `advanced_analysis.sql` for the window-function and CTE-based business analysis.
3. Review the outputs against the Key Insights section above.

## Author

**Ronak Gupta**
[LinkedIn](https://www.linkedin.com/in/ronak-gupta-27a392179) · ronakg772@gmail.com
