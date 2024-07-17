-- 1. Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1


-- 2. Which country has most Invoices?

select count(*) as invoice_count, billing_country
from invoice
group by billing_country
order by invoice_count desc
limit 1

-- 3. What are the top 3 values of total invoice?

select total from invoice
order by total desc
limit 3
	

-- 4. which city has the best customers? We would like to throw a promosonal Music Festival
-- in the city we made the most money. Write a query that returns one city that has the highest
-- sum of invoice totals. Return both the city name & sum of all invoice totals.

select sum(total) as total_invoice, billing_city
from invoice
group by billing_city
order by total_invoice desc
	

-- 5. Who is the best customer? The customer who has spent the most money will be decleared the
-- best customer. Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1
	

-- 6. Write query to return the email, first name, last name and genre of all rock music listeners
-- Return your list ordered aphabetically by email starting with A

select DISTINCT email, first_name, last_name
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	JOIN genre ON track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email	

	
-- 7. Let's invite the artist who have written the most rock music in our dataset. Write a query
-- 	that returns the Artist name and total track count of top 10 rock bands.
	
select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10


-- 8. Return all track names that have a song length longer than the average song length. Return the
-- Name and Miliseconds of each track. Order by the song length with the longest songs listed first.

select name, milliseconds
from track
where milliseconds >(
	select AVG(milliseconds) AS avg_track_length
from track)
order by milliseconds Desc


-- 9. Find how much amount spent by each customers on artists? Write a query to return customer
-- name, artist name and total spent

WITH best_selling_artist AS(
	select artist.artist_id as artist_id, artist.name as artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	from invoice_line
	JOIN track on track.track_id = invoice_line.track_id
	JOIN album on album.album_id = track.album_id
	JOIN artist on artist.artist_id = album.artist_id
	GROUP by 1
	ORDER by 3 DESC
	LIMIT 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) AS amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 DESC


-- 10. Find out the most popular music Genre for each country. We determine the most popular genre
-- as the genre with the highest amount of purcheses.

with popular_genre as 
(
	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER (PARTITION by customer.country order by count(invoice_line.quantity) DESC) as RowNo
	From invoice_line
	Join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer ON customer.customer_id = invoice.customer_id
	join track ON track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 ASC, 1 DESC
)
select * from popular_genre where RowNo <= 1


-- 11. Write a query that determines the customer that has spent the most on music for each country.
-- write a query that returns the country along with the top customer and how much they spent.
-- for countries where the top amount spent is shared, provide all customers who spent this amount.

With Customer_with_country AS(
	Select customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	ROW_NUMBER() over(partition by billing_country order by SUM(total) DESC) AS RowNo
	from invoice
	Join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4 ASC, 5 DESC)
select * from customer_with_country where RowNo <= 1