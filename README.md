# NHS Cancer Waiting Times — SQL, Data Quality & Reporting Analysis

## 1. Project Overview

This portfolio project simulates the work of a **Cancer Pathway / Performance Data Analyst** using publicly available NHS cancer waiting-time data.

The objective is to assess:

- cancer waiting-time performance
- breaches of the relevant waiting-time standard
- variation between organisations and cancer pathways
- data-quality issues that could affect reporting
- areas that may require operational investigation

### Tools

**SQL → database analysis**  
**Excel / Power Query → validation and reconciliation**  
**Power BI → reporting and communication**

This is an independent portfolio project and does not represent direct employment or analytical work for an NHS Trust.

---

## 2. Business Context

Cancer services need reliable performance information to understand whether patients are being managed within the relevant waiting-time standards.

The key business question is:

> **Where is cancer waiting-time performance good or poor, where are breaches concentrated, and where should operational teams investigate further?**

Before reporting performance, the analyst must establish whether the underlying data is complete, internally consistent and suitable for analysis.

---

## 3. Key Business Questions

1. How does cancer waiting-time performance vary over time?
2. Which organisations have the highest reported breach pressure?
3. Which cancer types or pathways show weaker performance?
4. Where are breaches concentrated?
5. Are there data-quality issues that could affect interpretation?
6. Which areas should be prioritised for operational review?

---

## 4. Dataset

The dataset contains cancer waiting-time records with fields including:

| Field | Description |
|---|---|
| `PERIOD` | Reporting period |
| `YEAR` | Financial year |
| `MONTH` | Reporting month |
| `STANDARD` | Cancer waiting-time standard |
| `ORG CODE` | Organisation/provider code |
| `STAGE/ROUTE` | Cancer pathway or referral route |
| `TREATMENT MODALITY` | Treatment modality where applicable |
| `CANCER TYPE` | Cancer/pathway category |
| `TOTAL TREATED` | Total reported treated/relevant pathways |
| `WITHIN STANDARD` | Number within the applicable standard |
| `BREACHES` | Number outside the applicable standard |

### Important analytical point

The dataset contains a `STANDARD` field. Different waiting-time standards must therefore be treated separately. The project will not assume that every row has the same target or definition of success.

---

## 5. Business Definitions

### Performance

For a given standard and reporting group:

**Performance = within-standard pathways / total relevant pathways × 100**

A higher percentage generally indicates better reported performance against that applicable standard.

### Breach

A breach is a reported pathway that falls outside the applicable waiting-time standard.

### Data quality

Data quality means assessing whether the dataset is:

- complete
- internally consistent
- logically valid
- correctly structured
- sufficiently reliable for analysis

Examples include missing identifiers, duplicate business records, negative values and reconciliation errors.

---

## 6. End-to-End Analytical Workflow

### Phase 1 — Business Requirements

Define the business objective, stakeholder questions, KPIs and relevant standards.

### Phase 2 — Data Acquisition & Setup

Import the source Excel files into a local MySQL database using Python, pandas and SQLAlchemy.

Database: `nhs_cancer_db`

Master table: `cancer_waiting_times`

### Phase 3 — Data Quality & Validation

Use SQL to investigate:

- row counts
- reporting periods
- organisations
- standards
- missing values
- duplicate business records
- negative values
- count relationships
- `TOTAL_TREATED = WITHIN STANDARD + BREACHES`
- zero-volume records

This phase answers:

> **Can I trust the data enough to analyse it?**

### Phase 4 — SQL Performance Analysis

After validation, analyse:

- overall performance
- monthly trends
- organisation-level performance
- cancer-type performance
- breach volumes
- breach rates
- high-pressure pathways
- rankings and comparisons

Technical SQL skills demonstrated will include:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `CASE WHEN`
- aggregate functions
- joins
- CTEs
- window functions
- ranking

### Phase 5 — Excel / Power Query & Power BI

Excel / Power Query will be used for reconciliation, validation and ad-hoc investigation.

Power BI will communicate headline KPIs, trends, breach pressure, organisation/pathway comparisons and data-quality findings.

### Phase 6 — Insights & Recommendations

The final analysis will identify:

- what happened
- where it happened
- how large the issue is
- whether the pattern persists
- what should be investigated
- what action could be considered

Recommendations will be evidence-based and will avoid unsupported causal claims.

---

## 7. SQL Project Structure

```text
nhs-cancer-waiting-time-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_setup_and_import.sql
│   ├── 02_data_quality.sql
│   ├── 03_performance_analysis.sql
│   ├── 04_breach_analysis.sql
│   ├── 05_cte_analysis.sql
│   └── 06_window_functions.sql
│
├── python/
│   └── import_data.py
│
├── excel/
│   └── validation_and_reconciliation.xlsx
│
├── powerbi/
│   ├── executive_dashboard.png
│   └── data_quality_dashboard.png
│
└── report/
    └── executive_insights.pdf
```

---

## 8. Reproducibility

### Database setup

```sql
CREATE DATABASE IF NOT EXISTS nhs_cancer_db;
USE nhs_cancer_db;
```

### Data import

The Excel files are imported using Python:

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    'mysql+pymysql://root:YOUR_PASSWORD@localhost/nhs_cancer_db'
)

df = pd.read_excel('CWT-1.xlsx', sheet_name=0)

df.to_sql(
    'cancer_waiting_times',
    con=engine,
    if_exists='replace',
    index=False
)

df2 = pd.read_excel('CWT-2.xlsx', sheet_name=0)

df2.to_sql(
    'cancer_waiting_times',
    con=engine,
    if_exists='append',
    index=False
)
```

**Security:** never commit database passwords or other credentials to GitHub.

### SQL execution

Run the SQL scripts in numerical order:

```text
01_setup_and_import.sql
02_data_quality.sql
03_performance_analysis.sql
04_breach_analysis.sql
05_cte_analysis.sql
06_window_functions.sql
```

---

## 9. Data Quality Philosophy

The project deliberately separates **data quality** from **business performance**.

A provider may appear to have poor performance, but if the underlying records contain reconciliation errors or unexpected duplication, the analyst should investigate data quality before drawing a strong operational conclusion.

> **Reliable reporting depends on reliable underlying data.**

---

## 10. Limitations

- This is an independent portfolio project using publicly available data.
- The dataset is not patient-level clinical data.
- Aggregate waiting-time data can identify patterns and areas for investigation but cannot by itself explain the clinical or operational causes of a breach.
- Different cancer waiting-time standards have different definitions and must be analysed separately.
- Recommendations are therefore framed as areas for operational review rather than unsupported causal conclusions.

---

## 11. Skills Demonstrated

### SQL

Database setup, profiling, data-quality validation, aggregation, conditional logic, CTEs, joins, window functions, ranking and performance calculations.

### Excel / Power Query

Validation, reconciliation, data inspection and ad-hoc analysis.

### Power BI

KPI reporting, trend analysis, performance comparison, data-quality reporting and stakeholder-focused visualisation.

### Analytical skills

Business-question framing, healthcare performance analysis, data-quality assessment, interpretation, evidence-based recommendations and communication.

---

## 12. Final Deliverables

1. Reproducible SQL scripts
2. Validated MySQL dataset
3. Excel / Power Query reconciliation workbook
4. Power BI performance report
5. Data-quality report
6. Executive insights memo
7. GitHub documentation

---

## 13. Portfolio Positioning

This project demonstrates an end-to-end analytical workflow rather than isolated SQL exercises:

**Business problem → Data acquisition → Data quality → SQL analysis → Validation → Power BI → Insight → Operational recommendation**

The emphasis is on using SQL and analytical reasoning to answer a real healthcare performance question, rather than simply demonstrating SQL syntax.
