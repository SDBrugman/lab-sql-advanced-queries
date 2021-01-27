USE sakila;

-- 1 --
-- List each pair of actors that have worked together.--
-- Using joins --
SELECT f1.film_id, concat(a1.first_name, ' ', a1.last_name)  AS actor1, concat(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor f1
	inner join film_actor f2 on f1.actor_id > f2.actor_id
	and f1.film_id = f2.film_id
    join actor a1 on f1.actor_id = a1.actor_id
    join actor a2 on f2.actor_id = a2.actor_id
order by f1.film_id, actor1, actor2;

-- Using Subqueries --
WITH cte_actor1 as (
	SELECT f1.film_id, f1.actor_id as actor1, concat(a1.first_name, ' ', a1.last_name) AS name_actor1
		FROM film_actor f1
			join actor a1 on f1.actor_id = a1.actor_id
)
SELECT cte.film_id, cte.name_actor1, concat(a2.first_name, ' ', a2.last_name) AS name_actor2
FROM cte_actor1 cte
	join film_actor as f2 on cte.film_id = f2.film_id
		and actor1 > f2.actor_id
	join actor as a2 on f2.actor_id = a2.actor_id
order by cte.film_id, cte.actor1, name_actor2;

-- 2 --
-- For each film, list actor that has acted in more films.
-- step 1 --
select actor_id, count(film_id) as nr_of_films
	from film_actor
	group by actor_id
	order by nr_of_films DESC;

-- step 2 --
select actor_id from (
	select actor_id, count(film_id) as nr_of_films
	from film_actor
	group by actor_id
	order by nr_of_films DESC
) sub1;

-- step 3 --
SELECT f.film_id, f.title, fa.actor_id, concat(a.first_name, ' ', a.last_name) AS name_actor 
FROM film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where fa.actor_id in (
	select actor_id from (
		select actor_id, count(film_id) as nr_of_films
		from film_actor
		group by actor_id
		order by nr_of_films DESC
        ) sub1
	)
order by actor_id;


