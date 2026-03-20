# NSE Stock Performance Analysis — FY 2024-25

## 📌 Project Overview
An end-to-end SQL analysis of three major Nifty 50 stocks —
ICICI Bank, Reliance Industries, and TCS — benchmarked against
the Nifty 50 index across the full fiscal year (April 2024 – March 2025).

The project follows a professional analyst workflow: raw data ingestion,
data cleaning, corporate action adjustment, and multi-dimensional analysis
culminating in a structured investment brief.

---

## 🎯 Business Questions Answered
- How did each stock trend over FY 2024-25?
- Which stock delivered the best risk-adjusted return?
- Which months were most volatile and why?
- Does high trading volume correlate with price movement?
- How did each stock perform relative to the Nifty 50 benchmark?
- What does VWAP tell us about buying and selling pressure each month?

---

## 📊 Dataset
- **Source:** NSE India (nseindia.com)
- **Period:** April 1, 2024 – March 31, 2025 (FY 2024-25)
- **Stocks Analyzed:** ICICI Bank, Reliance Industries, TCS
- **Benchmark:** Nifty 50 Index
- **Records:** 249 trading days per stock

---

## 🔑 Key Findings

| Stock | Annual Return | Volatility | Avg Daily Volume | Yearly Low | Yearly High |
|---|---|---|---|---|---|
| **ICICI Bank** | **+22.62%** 🏆 | 5.86% | 13.7M | ₹1,055 | ₹1,358 |
| Nifty 50 | +4.71% | 4.26% | — | — | — |
| TCS | -7.93% | 6.47% | 2.4M | ₹3,483 | ₹4,554 |
| Reliance | -14.12% | 8.38% | 9.4M | ₹1,162 | ₹1,601 |

- **ICICI Bank** was the standout performer — delivering +22.62% with the
  lowest volatility (5.86%), outperforming the Nifty 50 by ~18 percentage
  points. A textbook example of strong risk-adjusted returns.

- **Reliance and TCS** both underperformed the index, suggesting sector-specific
  headwinds in energy and IT respectively during FY25.

- **October 2024** marked a broad market correction — all stocks and the index
  fell simultaneously, consistent with heavy FII outflows during that period.

- **February 2025** was the worst month of the year — TCS fell 14.48% in a
  single month while the Nifty 50 dropped 5.78%.

- **A 1:1 Bonus Issue** was identified in Reliance on October 28, 2024. All
  pre-split prices were adjusted by dividing by 2 to ensure accurate
  year-on-year comparisons.

- **March 2025** showed strong recovery across all stocks — ICICI leading at
  +11.78% — suggesting the correction phase may be ending.

---

## ⚙️ Data Challenges Solved
- Handled BOM characters in NSE-generated CSV files
- Cleaned comma-formatted numbers during PostgreSQL import
- Used `psql \copy` command to bypass server-level permission restrictions
- Identified and adjusted for Reliance 1:1 bonus issue (October 28, 2024)
- Validated TCS and ICICI for corporate actions using daily % change analysis

---

## 💼 Business Impact
- Identifies which sectors outperformed in FY25
- Quantifies risk vs return trade-offs across stocks
- Detects corporate actions that distort raw price data
- Provides a data-driven basis for investment allocation decisions
- Demonstrates how market-wide events affect individual stock performance

---

## 🛠️ Tech Stack
- **Database:** PostgreSQL 17
- **Query Interface:** pgAdmin 4
- **Command Line:** psql (for data import)
- **Visualization:** Power BI *(coming soon)*
- **Data Source:** NSE India

---

## ▶️ How to Run

### 1. Install PostgreSQL
Download from postgresql.org — includes pgAdmin 4

### 2. Create Database
```sql
CREATE DATABASE nse_analysis;
```

### 3. Import CSV Files
Use psql \copy command:
```sql
\copy icicibank_raw FROM 'path/to/ICICIBANK.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');
```

### 4. Run SQL File
Open `analysis_queries.sql` in pgAdmin and run all queries in order.
