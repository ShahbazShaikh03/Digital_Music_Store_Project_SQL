Q1: Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1

Q2: Which country has the most invoices?

select billing_country as Country_name, count(billing_country) as Total_bill_count from invoice
group by billing_country
order by count(billing_country) desc