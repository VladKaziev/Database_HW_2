--Создание таблицы customer
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    gender VARCHAR,
    DOB DATE,
    job_title VARCHAR,
    job_industry_category VARCHAR,
    wealth_segment VARCHAR,
    deceased_indicator VARCHAR,
    owns_car VARCHAR,
    address VARCHAR,
    postcode VARCHAR,
    state VARCHAR,
    country VARCHAR,
    property_valuation INT
);

--Создание таблицы transaction
CREATE TABLE transaction (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    transaction_date DATE,
    online_order VARCHAR,
    order_status VARCHAR,
    brand VARCHAR,
    product_line VARCHAR,
    product_class VARCHAR,
    product_size VARCHAR,
    list_price FLOAT,
    standard_cost FLOAT
);


--Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
SELECT DISTINCT brand
FROM transaction
WHERE standard_cost > 1500;


--Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно
SELECT *
FROM transaction
WHERE order_status = 'Approved'
  AND transaction_date BETWEEN '2017-04-01' AND '2017-04-09';
 

--Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'  
SELECT DISTINCT job_title
FROM customer c
JOIN transaction t ON c.customer_id = t.customer_id
WHERE (job_industry_category = 'IT' OR job_industry_category = 'Financial Services')
  AND job_title LIKE 'Senior%';

 
--Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
SELECT DISTINCT t.brand
FROM transaction t
JOIN customer c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'Financial Services';


--Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN transaction t ON c.customer_id = t.customer_id
WHERE t.online_order = 'True'
  AND t.brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
LIMIT 10;


--Вывести всех клиентов, у которых нет транзакций.
SELECT *
FROM customer
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM transaction);


--Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью
WITH MaxStandardCost AS (
  SELECT MAX(standard_cost) AS max_standard_cost
  FROM transaction t
  JOIN customer c ON t.customer_id = c.customer_id
  WHERE c.job_industry_category = 'IT'
)
SELECT c.*
FROM customer c
JOIN transaction t ON c.customer_id = t.customer_id
JOIN MaxStandardCost m ON t.standard_cost = m.max_standard_cost
WHERE c.job_industry_category = 'IT';

--Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'
SELECT DISTINCT c.*
FROM customer c
JOIN transaction t ON c.customer_id = t.customer_id
WHERE (c.job_industry_category = 'IT' OR c.job_industry_category = 'Health')
  AND t.order_status = 'Approved'
  AND t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17';
