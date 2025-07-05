# Performance Monitoring Report

This report shares findings and suggestions for improving the performance of SQL queries by using indexes, writing more efficient queries, and applying other database optimization techniques.

---

## File: `aggregations_and_window_functions.sql`

- The query `SELECT count(booking_id), user_id FROM bookings GROUP BY user_id;` would run faster if there is an index on the `user_id` column in the `bookings` table.
- A query that ranks properties based on the number of bookings joins the `bookings` and `properties` tables. To speed this up, indexes should be added on:
  - `properties.property_id`
  - `bookings.property_id`

---

## File: `joins_queries.sql`

- The **inner join** between `users` and `bookings` (`users.user_id = bookings.user_id`) will perform better if both `users.user_id` and `bookings.user_id` have indexes.
- The **left join** between `properties` and `reviews` (`reviews.property_id = properties.property_id`) can be improved with indexes on:
  - `reviews.property_id`
  - `properties.property_id`
- The **full outer join** between `users` and `bookings` should also have indexes on:
  - `users.user_id`
  - `bookings.user_id`

---

## File: `subqueries.sql`

- The query that finds properties with an average rating greater than 4.0 will run faster with an index on `property_id` in the `reviews` table.
- The query that finds users with more than 3 bookings can be improved with an index on `user_id` in the `bookings` table.

---

## General Recommendations

- Create indexes on key columns:
  - `users.user_id`
  - `bookings.user_id`
- Only select the columns you actually need in your queries. Avoid using `SELECT *`.
- For large tables with date fields (like `start_date`), consider partitioning by date to make queries faster.