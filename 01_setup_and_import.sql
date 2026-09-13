-- =====================================================================
-- NHS Cancer Waiting Times Analysis
-- STEP 01: Database & Schema Setup, Import & Initial Verification
-- File: sql/01_setup_and_import.sql
--
-- Purpose:
--   Create the project database, document the Python import process,
--   and perform initial checks on the imported CWT data.
--
-- Reproducibility:
--   1. Create the MySQL database.
--   2. Run the Python import script provided in this project.
--   3. Run the verification queries below.
--
-- Note:
--   The table is created/replaced by pandas.to_sql() during import.
--   Therefore, an explicit CREATE TABLE definition is not required here.
-- =====================================================================


-- =====================================================================
-- 1. DATABASE SETUP
-- =====================================================================

CREATE DATABASE IF NOT EXISTS nhs_cancer_db;
USE nhs_cancer_db;


-- =====================================================================
-- 2. DATA IMPORT
-- =====================================================================
-- The Excel files were converted/loaded into MySQL using Python,
-- pandas and SQLAlchemy.
--
-- CWT-1.xlsx creates/replaces the master table.
-- CWT-2.xlsx is then appended to the master table.
--
-- Python import script:
--
-- import pandas as pd
-- from sqlalchemy import create_engine
--
-- engine = create_engine(
--     'mysql+pymysql://root:YOUR_PASSWORD@localhost/nhs_cancer_db'
-- )
--
-- # Load first file
-- df = pd.read_excel(
--     'CWT-1.xlsx',
--     sheet_name=0
-- )
--
-- df.to_sql(
--     'cancer_waiting_times',
--     con=engine,
--     if_exists='replace',
--     index=False
-- )
--
-- print(f"Successfully loaded {len(df)} rows into MySQL!")
--
-- # Load second file
-- df2 = pd.read_excel(
--     'CWT-2.xlsx',
--     sheet_name=0
-- )
--
-- df2.to_sql(
--     'cancer_waiting_times',
--     con=engine,
--     if_exists='append',
--     index=False
-- )
--
-- print(f"Successfully appended {len(df2)} rows into MySQL!")
--
-- IMPORTANT:
-- Do not publish database credentials or passwords to GitHub.
-- Replace YOUR_PASSWORD with your local MySQL password.


-- =====================================================================
-- 3. VERIFY ALL UNIQUE REPORTING PERIODS
-- =====================================================================

SELECT
    PERIOD,
    COUNT(*) AS row_count
FROM cancer_waiting_times
GROUP BY PERIOD
ORDER BY PERIOD;


-- =====================================================================
-- 4. VERIFY TOTAL ROW COUNT AND DATE/PERIOD RANGE
-- =====================================================================

SELECT
    COUNT(*) AS total_rows,
    MIN(PERIOD) AS earliest_period,
    MAX(PERIOD) AS latest_period
FROM cancer_waiting_times;


-- =====================================================================
-- 5. CHECK DISTRIBUTION ACROSS MONTHS
-- =====================================================================

SELECT
    MONTH,
    COUNT(*) AS records
FROM cancer_waiting_times
GROUP BY MONTH
ORDER BY MONTH;


-- =====================================================================
-- 6. OPTIONAL STAGING-TABLE APPEND
-- =====================================================================
-- If CWT-2 was loaded into a staging table called `cancer2`, it can
-- alternatively be appended using:
--
-- INSERT INTO cancer_waiting_times
-- SELECT *
-- FROM cancer2;
--
-- DROP TABLE cancer2;
--
-- This is an alternative workflow. It should NOT be run if the
-- Python script has already appended CWT-2 to the master table,
-- otherwise the second dataset could be duplicated.


-- =====================================================================
-- 7. PRE-ANALYSIS INTEGRITY VERIFICATION
-- =====================================================================

SELECT
    YEAR,
    COUNT(*) AS total_rows,
    SUM(TOTAL_TREATED) AS cumulative_volume
FROM cancer_waiting_times
GROUP BY YEAR
ORDER BY YEAR;


-- =====================================================================
-- 8. BASIC SCHEMA HEALTH: NULL CHECKS
-- =====================================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN `ORG CODE` IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_org_codes,
    SUM(
        CASE
            WHEN TOTAL_TREATED IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_totals
FROM cancer_waiting_times;


-- =====================================================================
-- 9. INITIAL RECONCILIATION CHECK
-- =====================================================================
-- Every record should satisfy:
--
-- TOTAL_TREATED = WITHIN_STANDARD + BREACHES
--
-- Any result greater than zero indicates a record requiring review.

SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN TOTAL_TREATED = `WITHIN STANDARD` + BREACHES THEN 0
            ELSE 1
        END
    ) AS reconciliation_errors
FROM cancer_waiting_times;


-- =====================================================================
-- END OF STEP 01
-- =====================================================================
