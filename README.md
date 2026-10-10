# Retail Transaction Analytics Pipeline


![Dashboard Overview](Screenshot%202026-08-05%20184004_1.png)

Welcome to my retail data project! This repository contains the SQL scripts and Power BI dashboard I built to analyze over 2.5 million actual retail transactions from the Dunnhumby dataset. 

I put this together as part of project focus to prove out a full data pipeline—from raw, messy CSVs to a polished corporate dashboard. I purposely avoided overused, overly clean datasets because I wanted to tackle the kind of massive, relational data you actually see in a real business environment.

### The Stack I Used
* **Excel:** For the initial cleanup, handling missing values, and standardizing the smaller dimension tables (demographics and products).
* **MySQL:** Excel physically cannot handle 2.5 million rows, so I architected a relational database here. I utilized optimized `LOAD DATA INFILE` scripts to bulk-load the massive transaction logs without bottlenecking the system.
* **Power BI:** To connect to the database, build out the final Star Schema data model, and visualize the core business metrics. 

### How I Approached the Problem
Instead of just finding random numbers, I wanted to answer specific business questions: *Who is actually driving revenue, and what are they buying?* 
        
1. **Data Prep:** I started by standardizing text fields and handling missing demographic categories in Excel so they wouldn't break my SQL joins later.
2. **Database Architecture:** I built a standard fact/dimension schema in MySQL. I also wrote custom SQL scripts to convert the raw integer day data into a usable `YYYY-MM-DD` date format so I could track time-series trends.
3. **Modeling & Visualization:** I connected MySQL directly to Power BI, mapped a One-to-Many Star Schema, and wrote custom DAX measures to calculate metrics like Average Order Value (AOV). 

### What the Data Showed
*(Note: I am letting the data speak for itself here. Check out the dashboard PDF for the visual breakdown.)*

* **The Revenue Engine:** Households in the 50-74K income bracket are the heavy lifters when it comes to overall revenue generation. 
* **Seasonal Spikes:** There is a distinct jump in overall sales around May-November, driven almost entirely by the Grocery and Produce departments. 
* **The Cross-Sell Opportunity:** While the Deli department brings in consistent foot traffic, the Average Order Value is surprisingly low. A targeted cross-selling campaign bundling these items with high-performing grocery staples could easily lift the overall bottom line.

Feel free to poke around the SQL scripts in this repo or check out the final dashboard!
