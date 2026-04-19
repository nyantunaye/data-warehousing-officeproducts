# Data Warehousing Project — OfficeProducts

## Group Members
| Name |
|------|
| Antonius Dimitri Adhisatrio |
| Nyan Tun Aye |

---

## Project Overview

This project designs and implements a data warehouse solution for **OfficeProducts**, a major office products supplier operating both physical stores and an online platform nationwide. As the business shifts toward e-commerce, data-driven decision-making becomes essential for managing operations, client relationships, and delivery performance.

The data warehouse enables OfficeProducts to analyse client buying patterns, optimise delivery and shipping costs, evaluate promotions, and support targeted business strategies across all sales channels.

---

## Data Pipeline

The data pipeline handles both online and offline transaction data:

| Source | Method | Tool |
|--------|--------|------|
| Offline (in-store) transactions | Daily batch uploads | Airflow |
| Online transactions | Real-time streaming | Kafka + Python |

### Tools Used
- **Kafka** — Enterprise service bus for real-time, event-driven data streaming
- **Python** — Data transformation and normalisation of Kafka streams
- **Airflow** — Job scheduling, dependency management, monitoring and alerting

---

## Data Warehouse Schema

The warehouse is structured into four layers:

| Layer | Purpose | Access |
|-------|---------|--------|
| **Staging** | Raw, unprocessed data from source systems | Data Engineers only |
| **Integration** | Cleaned and transformed data combining multiple staging tables | Data Engineers only |
| **Access** | Summarised tables and dimension tables ready for querying | Permitted users |
| **Data Mart (DM)** | Business-specific reporting tables for high-level stakeholders | Selected business users |

---

## Entity Relationship Diagram (ERD)

The ERD covers the **Access layer** for the sales transactions domain and includes:

### Fact Tables
- `fact_transaction_header` — Transaction-level records (amount, status, channel, payment)
- `fact_transaction_line_items` — Line-item details per transaction (product, quantity, shipping, promotion)

### Dimension Tables
| Table | Description |
|-------|-------------|
| `dim_clients` | Client profiles and contact details |
| `dim_product` | Product catalogue and types |
| `dim_supplier` | Supplier information |
| `dim_channel` | Sales channels (online, in-store, event) |
| `dim_payment` | Payment types, terms, and fee structures |
| `dim_promotion` | Promotion codes, types, and validity periods |
| `dim_warehouse` | Warehouse locations |
| `dim_shipped_to` | Shipping destination addresses |
| `dim_postal_code` | Postal code reference data |
| `dim_calendar` | Date dimension for time-based analysis |

> All tables (except `dim_calendar` and `dim_postal_code`) include `created_timestamp` and `updated_timestamp` columns for data lineage and audit tracking.

---

## Analytical Use Cases

The data warehouse supports the following analyses:

- **Client Retention & Engagement** — Cohort analysis to identify inactive clients and re-engage them
- **Transaction Channel Optimisation** — Identify best-performing channels and improve others
- **Day-by-Day Analysis** — Analyse transaction patterns across weekdays, weekends, and public holidays
- **Similar Product Sales** — Compare performance of similar products to improve underperforming lines
- **Payment Provider Partnerships** — Identify popular payment methods for joint promotional opportunities
- **Payment Method Strategy** — Encourage large corporate orders through instalment payment options
- **Client Growth Tracking** — Monitor new client acquisition over time using `created_timestamp`
- **Shipping Cost Optimisation** — Estimate and optimise delivery costs based on warehouse and destination
- **Promotion Strategy** — Evaluate promotion code usage, reach, and revenue impact
- **Delivery SLA Monitoring** — Identify SLA breaches to reduce client churn

---

## Repository Structure

```
data-warehousing-officeproducts/
├── docs/
│   └── dwh_project_v1.docx       # Full project report
├── sql/
│   ├── ddl_fact_tables.sql        # CREATE TABLE scripts for fact tables
│   ├── ddl_dimension_tables.sql   # CREATE TABLE scripts for dimension tables
│   └── ddl_indexes.sql            # Index definitions
└── README.md
```

---

## Database

All SQL scripts are written for **Oracle SQL** using Oracle-specific data types (`VARCHAR2`, `NUMBER`, `DATE`, `TIMESTAMP`).

---

## Tools & Technologies

| Category | Tool |
|----------|------|
| Data Streaming | Apache Kafka |
| Data Transformation | Python |
| Workflow Orchestration | Apache Airflow |
| Database | Oracle SQL |
| ERD Design | Visual Paradigm |
| Documentation | Microsoft Word |
