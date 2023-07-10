/*Q1: Who is the senior most employee based on job title?*/

select * from employee
order by levels desc
limit 1;


/*Q2: Which country has the most invoices?*/

select billing_country as Country_name, count(billing_country) as Total_bill_count from invoice
group by billing_country
order by count(billing_country) desc;


/*Q3: What are top 3 values of total invoice?*/

select total as Top_3_invoice_values
from invoice
order by total desc
limit 3;


/*Q4: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals.*/

select billing_city as city, sum(total) 
from invoice
group by billing_city
order by sum(total) desc
limit 1;


/*Q5: Who is the best customer? 
The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money*/

select c.customer_id, c.first_name, c.last_name, sum(i.total) as Total_money_spent
from customer c
left join invoice i
on c.customer_id = i.customer_id
group by c.customer_id
order by Total_money_spent desc
limit 1;


/*Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A*/

select Distinct(cu.email), cu.first_name, cu.last_name
from customer cu
join invoice inv on cu.customer_id = inv.customer_id
join invoice_line il on inv.invoice_id = il.invoice_id
join track tr on il.track_id = tr.track_id
join genre ge on tr.genre_id = ge.genre_id
where ge.name = 'Rock'
order by email;


/*Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands*/

Select a.artist_id, a.name, count(t.track_id) as Total_track
from artist a
join album al on a.artist_id = al.artist_id
join track t on al.album_id = t.album_id
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock'
group by a.artist_id
order by Total_track desc
limit 10;


/*Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first*/

select name, milliseconds
from track
where milliseconds > 
	(select avg(milliseconds) from track)
order by milliseconds desc;


/*Q9: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent*/

Select cu.customer_id, cu.first_name as customer_first_name, cu.last_name as customer_last_name, 
a.name as artist_name, sum(il.unit_price * il.quantity) as Total_spent
From customer cu
join invoice inv on cu.customer_id = inv.customer_id
join invoice_line il on inv.invoice_id = il.invoice_id
join track tr on il.track_id = tr.track_id
join album al on tr.album_id = al.album_id
join artist a on al.artist_id = a.artist_id
group by 1,2,3,4
order by Total_spent desc;


/*Q10: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres*/

with most_popular_genre as 
(select cu.country, count(ge.name) as total_purchase, ge.name as genre_name, ge.genre_id,
ROW_NUMBER() OVER(PARTITION BY cu.country ORDER BY COUNT(il.quantity) DESC) AS RowNo
from customer cu
join invoice inv on cu.customer_id = inv.customer_id
join invoice_line il on inv.invoice_id = il.invoice_id
join track tr on il.track_id = tr.track_id
join genre ge on tr.genre_id = ge.genre_id
group by cu.country, genre_name, ge.genre_id
order by cu.country, total_purchase desc)

select * from most_popular_genre where rowno = 1;


/*Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount*/

with customer_who_spent_most_amount as
(Select cu.customer_id, cu.first_name, cu.last_name, cu.country, sum(i.total),
row_number() over(partition by cu.country order by sum(i.total) desc) as RowNo
from customer cu
join invoice i on cu.customer_id = i.customer_id 
group by 1,2,3,4
order by cu.country, sum(i.total) desc)

select * from customer_who_spent_most_amount where rowno = 1;

