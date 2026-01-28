# MSSQL-Server-Scripts4 Public

## Overview
**EcommerceDB** – A normalized SQL database schema for an e‑commerce system.  
Includes tables for sellers, customers, products, categories, orders, and suppliers, with proper relationships and constraints.

The repository contains two main script files:

---

### 1. `EcommerceDB_Schema.sql`
- Contains only the **CREATE TABLE** statements.  
- Defines the normalized database structure with:
  - Sellers (`Saticilar`)
  - Customers (`Musteriler`)
  - Products (`Mehsullar`)
  - Categories (`Kategoriyalar`)
  - Orders (`Sifarishler`) and Order Details (`SifarishDetallari`)
  - Suppliers (`Techizatcilar`) and Product-Supplier mapping (`MehsulTechizatcilar`)
- All primary keys, foreign keys, and constraints are included to ensure data integrity.

---

### 2. `EcommerceDB_DataAndQueries.sql`
- Extends the schema with:
  - **Sample data inserts** for categories, customers, sellers, suppliers, and products  
  - **Mappings** between products and suppliers  
  - **Analytical queries**:
    - Total orders per customer
    - Customers with spending above thresholds
    - Order totals vs calculated amounts
    - Category-level sales and quantities
    - Most ordered category per customer
  - **View definition**: `CustomerOrderSummary`  
    - Shows each customer’s total orders, total spending, and most ordered category
