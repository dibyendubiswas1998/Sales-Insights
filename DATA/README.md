## Data Descriptions:

**After a quick data exploration in MySQL, here are some initial findings:**<br>

* The database contains 5 tables: customers, date, markets, products, and transactions;
* There are 17 markets, 279 products, and 38 customers;
* The observation period is from january 2018 to june 2020;
* The total revenue in 2020 was $ 142,23 Mi, 42% less than 2019, which was $ 336,45 Mi;
* Most of the transactions data are in INR currency, but we have 4 records in U$ currency.
* And we got Paris and New York on the “sales markets” table. We’re going to deal with it in the ETL process.


### Dataset:
In **Sales** database, there are 5 tables are there:

#### customer:
It provide customer related informations.
* **customer_code:**
* **custmer_name**
* **customer_type**

#### date:
It provide date related information.
* **date:**
* **cy_date:**
* **year:**
* **month_name:**
* **date_yy_mmm:**

#### markets:
It provide markets related information.
* **markets_code:**
* **markets_name:**
* **zone:**

#### products:
It provide products related information.
* **product_code:**
* **product_type:**

#### transactions:
It provide transaction related information.
* **product_code:**
* **customer_code:**
* **markets_code:**
* **order_date:**
* **sales_qty:**
* **sales_amount:**
* **currency:**
* **profit_margin_percentage:**
* **profit_margin:**
* **cost_price:**
