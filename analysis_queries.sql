-- ============================================================
-- NSE Stock Performance Analysis — FY 2024-25
-- Author: [Your Name]
-- Database: PostgreSQL 17
-- Description: End-to-end SQL analysis of ICICI Bank,
--              Reliance Industries, and TCS benchmarked
--              against the Nifty 50 index.
-- ============================================================


-- ============================================================
-- SECTION 1: CREATE TABLES
-- ============================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS reliance, tcs, icicibank, nifty50;
DROP TABLE IF EXISTS reliance_raw, tcs_raw, icicibank_raw, nifty50_raw;
DROP TABLE IF EXISTS reliance_adjusted;

-- Raw tables (import stage — all columns as TEXT)
CREATE TABLE reliance_raw (
    trade_date TEXT,
    series TEXT,
    open_price TEXT,
    high TEXT,
    low TEXT,
    prev_close TEXT,
    ltp TEXT,
    close_price TEXT,
    vwap TEXT,
    week52_high TEXT,
    week52_low TEXT,
    volume TEXT,
    trade_value TEXT,
    no_of_trades TEXT
);

CREATE TABLE tcs_raw (
    trade_date TEXT,
    series TEXT,
    open_price TEXT,
    high TEXT,
    low TEXT,
    prev_close TEXT,
    ltp TEXT,
    close_price TEXT,
    vwap TEXT,
    week52_high TEXT,
    week52_low TEXT,
    volume TEXT,
    trade_value TEXT,
    no_of_trades TEXT
);

CREATE TABLE icicibank_raw (
    trade_date TEXT,
    series TEXT,
    open_price TEXT,
    high TEXT,
    low TEXT,
    prev_close TEXT,
    ltp TEXT,
    close_price TEXT,
    vwap TEXT,
    week52_high TEXT,
    week52_low TEXT,
    volume TEXT,
    trade_value TEXT,
    no_of_trades TEXT
);

CREATE TABLE nifty50_raw (
    trade_date TEXT,
    open_price TEXT,
    high TEXT,
    low TEXT,
    close_price TEXT,
    shares_traded TEXT,
    turnover TEXT
);

-- Final cleaned tables
CREATE TABLE reliance (
    trade_date DATE,
    series VARCHAR(10),
    open_price NUMERIC,
    high NUMERIC,
    low NUMERIC,
    prev_close NUMERIC,
    ltp NUMERIC,
    close_price NUMERIC,
    vwap NUMERIC,
    week52_high NUMERIC,
    week52_low NUMERIC,
    volume BIGINT,
    trade_value NUMERIC,
    no_of_trades BIGINT
);

CREATE TABLE tcs (
    trade_date DATE,
    series VARCHAR(10),
    open_price NUMERIC,
    high NUMERIC,
    low NUMERIC,
    prev_close NUMERIC,
    ltp NUMERIC,
    close_price NUMERIC,
    vwap NUMERIC,
    week52_high NUMERIC,
    week52_low NUMERIC,
    volume BIGINT,
    trade_value NUMERIC,
    no_of_trades BIGINT
);

CREATE TABLE icicibank (
    trade_date DATE,
    series VARCHAR(10),
    open_price NUMERIC,
    high NUMERIC,
    low NUMERIC,
    prev_close NUMERIC,
    ltp NUMERIC,
    close_price NUMERIC,
    vwap NUMERIC,
    week52_high NUMERIC,
    week52_low NUMERIC,
    volume BIGINT,
    trade_value NUMERIC,
    no_of_trades BIGINT
);

CREATE TABLE nifty50 (
    trade_date DATE,
    open_price NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close_price NUMERIC,
    shares_traded BIGINT,
    turnover NUMERIC
);


-- ============================================================
-- SECTION 2: DATA CLEANING — RAW TO FINAL TABLES
-- ============================================================

-- NOTE: Import CSV files into raw tables first using psql:
-- \copy icicibank_raw FROM 'path/to/ICICIBANK.csv'
--   WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');
-- Repeat for reliance_raw, tcs_raw, nifty50_raw

-- Clean and insert into final tables
INSERT INTO icicibank
SELECT
    TO_DATE(trade_date, 'DD-Mon-YYYY'),
    series,
    REPLACE(open_price, ',', '')::NUMERIC,
    REPLACE(high, ',', '')::NUMERIC,
    REPLACE(low, ',', '')::NUMERIC,
    REPLACE(prev_close, ',', '')::NUMERIC,
    REPLACE(ltp, ',', '')::NUMERIC,
    REPLACE(close_price, ',', '')::NUMERIC,
    REPLACE(vwap, ',', '')::NUMERIC,
    REPLACE(week52_high, ',', '')::NUMERIC,
    REPLACE(week52_low, ',', '')::NUMERIC,
    REPLACE(volume, ',', '')::BIGINT,
    REPLACE(trade_value, ',', '')::NUMERIC,
    REPLACE(no_of_trades, ',', '')::BIGINT
FROM icicibank_raw;

INSERT INTO reliance
SELECT
    TO_DATE(trade_date, 'DD-Mon-YYYY'),
    series,
    REPLACE(open_price, ',', '')::NUMERIC,
    REPLACE(high, ',', '')::NUMERIC,
    REPLACE(low, ',', '')::NUMERIC,
    REPLACE(prev_close, ',', '')::NUMERIC,
    REPLACE(ltp, ',', '')::NUMERIC,
    REPLACE(close_price, ',', '')::NUMERIC,
    REPLACE(vwap, ',', '')::NUMERIC,
    REPLACE(week52_high, ',', '')::NUMERIC,
    REPLACE(week52_low, ',', '')::NUMERIC,
    REPLACE(volume, ',', '')::BIGINT,
    REPLACE(trade_value, ',', '')::NUMERIC,
    REPLACE(no_of_trades, ',', '')::BIGINT
FROM reliance_raw;

INSERT INTO tcs
SELECT
    TO_DATE(trade_date, 'DD-Mon-YYYY'),
    series,
    REPLACE(open_price, ',', '')::NUMERIC,
    REPLACE(high, ',', '')::NUMERIC,
    REPLACE(low, ',', '')::NUMERIC,
    REPLACE(prev_close, ',', '')::NUMERIC,
    REPLACE(ltp, ',', '')::NUMERIC,
    REPLACE(close_price, ',', '')::NUMERIC,
    REPLACE(vwap, ',', '')::NUMERIC,
    REPLACE(week52_high, ',', '')::NUMERIC,
    REPLACE(week52_low, ',', '')::NUMERIC,
    REPLACE(volume, ',', '')::BIGINT,
    REPLACE(trade_value, ',', '')::NUMERIC,
    REPLACE(no_of_trades, ',', '')::BIGINT
FROM tcs_raw;

INSERT INTO nifty50
SELECT
    TO_DATE(trade_date, 'DD-MON-YYYY'),
    REPLACE(open_price, ',', '')::NUMERIC,
    REPLACE(high, ',', '')::NUMERIC,
    REPLACE(low, ',', '')::NUMERIC,
    REPLACE(close_price, ',', '')::NUMERIC,
    REPLACE(shares_traded, ',', '')::BIGINT,
    REPLACE(turnover, ',', '')::NUMERIC
FROM nifty50_raw;


-- ============================================================
-- SECTION 3: CORPORATE ACTION ADJUSTMENT — RELIANCE BONUS ISSUE
-- ============================================================

-- Verify the bonus issue date (October 28, 2024)
-- Price dropped ~50% overnight confirming 1:1 bonus issue
SELECT trade_date, open_price, close_price, prev_close
FROM reliance
WHERE trade_date BETWEEN '2024-10-24' AND '2024-10-31'
ORDER BY trade_date;

-- Check TCS and ICICI for corporate actions
SELECT trade_date, close_price, prev_close,
    ROUND((close_price - prev_close) / prev_close * 100, 2) AS pct_change
FROM tcs
WHERE ABS((close_price - prev_close) / prev_close * 100) > 20
ORDER BY trade_date;

SELECT trade_date, close_price, prev_close,
    ROUND((close_price - prev_close) / prev_close * 100, 2) AS pct_change
FROM icicibank
WHERE ABS((close_price - prev_close) / prev_close * 100) > 20
ORDER BY trade_date;

-- Create adjusted Reliance table
-- All prices before October 28 divided by 2
DROP TABLE IF EXISTS reliance_adjusted;

CREATE TABLE reliance_adjusted AS
SELECT
    trade_date,
    series,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(open_price / 2, 2) ELSE open_price END AS open_price,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(high / 2, 2) ELSE high END AS high,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(low / 2, 2) ELSE low END AS low,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(prev_close / 2, 2) ELSE prev_close END AS prev_close,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(ltp / 2, 2) ELSE ltp END AS ltp,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(close_price / 2, 2) ELSE close_price END AS close_price,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(vwap / 2, 2) ELSE vwap END AS vwap,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(week52_high / 2, 2) ELSE week52_high END AS week52_high,
    CASE WHEN trade_date < '2024-10-28' THEN ROUND(week52_low / 2, 2) ELSE week52_low END AS week52_low,
    volume,
    trade_value,
    no_of_trades
FROM reliance;


-- ============================================================
-- SECTION 4: ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 4.1 Monthly Trend Comparison — All Stocks vs Index
-- ------------------------------------------------------------
SELECT
    TO_CHAR(i.trade_date, 'YYYY-MM') AS month,
    ROUND(AVG(i.close_price), 2) AS icici_avg,
    ROUND(AVG(r.close_price), 2) AS reliance_avg,
    ROUND(AVG(t.close_price), 2) AS tcs_avg,
    ROUND(AVG(n.close_price), 2) AS nifty50_avg
FROM icicibank i
JOIN reliance_adjusted r ON i.trade_date = r.trade_date
JOIN tcs t ON i.trade_date = t.trade_date
JOIN nifty50 n ON i.trade_date = n.trade_date
GROUP BY TO_CHAR(i.trade_date, 'YYYY-MM')
ORDER BY month;


-- ------------------------------------------------------------
-- 4.2 Annual Returns — First vs Last Trading Day
-- ------------------------------------------------------------
WITH icici_summary AS (
    SELECT
        'ICICI Bank' AS stock,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM icicibank)), 2) AS start_price,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM icicibank)), 2) AS end_price,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM icicibank)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM icicibank))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM icicibank)) * 100, 2) AS annual_return
    FROM icicibank
),
reliance_summary AS (
    SELECT
        'Reliance' AS stock,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM reliance_adjusted)), 2) AS start_price,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM reliance_adjusted)), 2) AS end_price,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM reliance_adjusted)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM reliance_adjusted))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM reliance_adjusted)) * 100, 2) AS annual_return
    FROM reliance_adjusted
),
tcs_summary AS (
    SELECT
        'TCS' AS stock,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM tcs)), 2) AS start_price,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM tcs)), 2) AS end_price,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM tcs)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM tcs))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM tcs)) * 100, 2) AS annual_return
    FROM tcs
),
nifty_summary AS (
    SELECT
        'Nifty 50' AS stock,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM nifty50)), 2) AS start_price,
        ROUND(MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM nifty50)), 2) AS end_price,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM nifty50)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM nifty50))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM nifty50)) * 100, 2) AS annual_return
    FROM nifty50
)
SELECT * FROM icici_summary
UNION ALL
SELECT * FROM reliance_summary
UNION ALL
SELECT * FROM tcs_summary
UNION ALL
SELECT * FROM nifty_summary;


-- ------------------------------------------------------------
-- 4.3 Volatility Analysis — Coefficient of Variation
-- ------------------------------------------------------------
SELECT
    'ICICI Bank' AS stock,
    ROUND(STDDEV(close_price), 2) AS price_stddev,
    ROUND(AVG(close_price), 2) AS avg_price,
    ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2) AS volatility_pct
FROM icicibank

UNION ALL

SELECT
    'Reliance',
    ROUND(STDDEV(close_price), 2),
    ROUND(AVG(close_price), 2),
    ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2)
FROM reliance_adjusted

UNION ALL

SELECT
    'TCS',
    ROUND(STDDEV(close_price), 2),
    ROUND(AVG(close_price), 2),
    ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2)
FROM tcs

UNION ALL

SELECT
    'Nifty 50',
    ROUND(STDDEV(close_price), 2),
    ROUND(AVG(close_price), 2),
    ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2)
FROM nifty50;


-- ------------------------------------------------------------
-- 4.4 Monthly Returns — All Stocks
-- ------------------------------------------------------------
SELECT DISTINCT
    TO_CHAR(i.trade_date, 'YYYY-MM') AS month,
    ROUND((LAST_VALUE(i.close_price) OVER (PARTITION BY TO_CHAR(i.trade_date, 'YYYY-MM')
        ORDER BY i.trade_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) -
           FIRST_VALUE(i.close_price) OVER (PARTITION BY TO_CHAR(i.trade_date, 'YYYY-MM')
        ORDER BY i.trade_date)) /
           FIRST_VALUE(i.close_price) OVER (PARTITION BY TO_CHAR(i.trade_date, 'YYYY-MM')
        ORDER BY i.trade_date) * 100, 2) AS icici_monthly_return,
    ROUND((LAST_VALUE(r.close_price) OVER (PARTITION BY TO_CHAR(r.trade_date, 'YYYY-MM')
        ORDER BY r.trade_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) -
           FIRST_VALUE(r.close_price) OVER (PARTITION BY TO_CHAR(r.trade_date, 'YYYY-MM')
        ORDER BY r.trade_date)) /
           FIRST_VALUE(r.close_price) OVER (PARTITION BY TO_CHAR(r.trade_date, 'YYYY-MM')
        ORDER BY r.trade_date) * 100, 2) AS reliance_monthly_return,
    ROUND((LAST_VALUE(t.close_price) OVER (PARTITION BY TO_CHAR(t.trade_date, 'YYYY-MM')
        ORDER BY t.trade_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) -
           FIRST_VALUE(t.close_price) OVER (PARTITION BY TO_CHAR(t.trade_date, 'YYYY-MM')
        ORDER BY t.trade_date)) /
           FIRST_VALUE(t.close_price) OVER (PARTITION BY TO_CHAR(t.trade_date, 'YYYY-MM')
        ORDER BY t.trade_date) * 100, 2) AS tcs_monthly_return,
    ROUND((LAST_VALUE(n.close_price) OVER (PARTITION BY TO_CHAR(n.trade_date, 'YYYY-MM')
        ORDER BY n.trade_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) -
           FIRST_VALUE(n.close_price) OVER (PARTITION BY TO_CHAR(n.trade_date, 'YYYY-MM')
        ORDER BY n.trade_date)) /
           FIRST_VALUE(n.close_price) OVER (PARTITION BY TO_CHAR(n.trade_date, 'YYYY-MM')
        ORDER BY n.trade_date) * 100, 2) AS nifty_monthly_return
FROM icicibank i
JOIN reliance_adjusted r ON i.trade_date = r.trade_date
JOIN tcs t ON i.trade_date = t.trade_date
JOIN nifty50 n ON i.trade_date = n.trade_date
ORDER BY month;


-- ------------------------------------------------------------
-- 4.5 Volume Analysis — ICICI Bank
-- ------------------------------------------------------------
SELECT
    TO_CHAR(trade_date, 'YYYY-MM') AS month,
    ROUND(AVG(volume), 0) AS avg_daily_volume,
    ROUND(AVG(no_of_trades), 0) AS avg_daily_trades,
    ROUND(AVG(close_price), 2) AS avg_close
FROM icicibank
GROUP BY TO_CHAR(trade_date, 'YYYY-MM')
ORDER BY month;


-- ------------------------------------------------------------
-- 4.6 VWAP Analysis — ICICI Bank
-- ------------------------------------------------------------
SELECT
    TO_CHAR(trade_date, 'YYYY-MM') AS month,
    ROUND(AVG(close_price - vwap), 2) AS avg_close_vs_vwap,
    COUNT(CASE WHEN close_price > vwap THEN 1 END) AS days_above_vwap,
    COUNT(CASE WHEN close_price < vwap THEN 1 END) AS days_below_vwap
FROM icicibank
GROUP BY TO_CHAR(trade_date, 'YYYY-MM')
ORDER BY month;


-- ------------------------------------------------------------
-- 4.7 Final Scorecard — All Stocks Summary
-- ------------------------------------------------------------
WITH icici_summary AS (
    SELECT
        'ICICI Bank' AS stock,
        ROUND(MIN(close_price), 2) AS yearly_low,
        ROUND(MAX(close_price), 2) AS yearly_high,
        ROUND(AVG(volume), 0) AS avg_volume,
        ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2) AS volatility_pct,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM icicibank)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM icicibank))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM icicibank)) * 100, 2) AS annual_return
    FROM icicibank
),
reliance_summary AS (
    SELECT
        'Reliance' AS stock,
        ROUND(MIN(close_price), 2) AS yearly_low,
        ROUND(MAX(close_price), 2) AS yearly_high,
        ROUND(AVG(volume), 0) AS avg_volume,
        ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2) AS volatility_pct,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM reliance_adjusted)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM reliance_adjusted))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM reliance_adjusted)) * 100, 2) AS annual_return
    FROM reliance_adjusted
),
tcs_summary AS (
    SELECT
        'TCS' AS stock,
        ROUND(MIN(close_price), 2) AS yearly_low,
        ROUND(MAX(close_price), 2) AS yearly_high,
        ROUND(AVG(volume), 0) AS avg_volume,
        ROUND(STDDEV(close_price) / AVG(close_price) * 100, 2) AS volatility_pct,
        ROUND((MAX(close_price) FILTER (WHERE trade_date = (SELECT MAX(trade_date) FROM tcs)) -
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM tcs))) /
               MAX(close_price) FILTER (WHERE trade_date = (SELECT MIN(trade_date) FROM tcs)) * 100, 2) AS annual_return
    FROM tcs
)
SELECT * FROM icici_summary
UNION ALL
SELECT * FROM reliance_summary
UNION ALL
SELECT * FROM tcs_summary;
