
-- Initial query: retrieves all bookings along with the user details, property details, and payment details

SELECT * FROM bookings
INNER JOIN users on bookings.user_id = users.user_id
INNER JOIN properties on properties.property_id = bookings.property_id
INNER JOIN payments on payments.booking_id = bookings.booking_id;


-- Query performance
EXPLAIN ANALYZE SELECT * FROM bookings
INNER JOIN users on bookings.user_id = users.user_id
INNER JOIN properties on properties.property_id = bookings.property_id
INNER JOIN payments on payments.booking_id = bookings.booking_id;

-- Output
-- Hash Join  (cost=3.44..24.44 rows=780 width=540) (actual time=0.144..0.149 rows=4 loops=1)
--   Hash Cond: (payments.booking_id = bookings.booking_id)
--   ->  Seq Scan on payments  (cost=0.00..17.80 rows=780 width=76) (actual time=0.006..0.006 rows=4 loops=1)
--   ->  Hash  (cost=3.35..3.35 rows=7 width=464) (actual time=0.084..0.085 rows=7 loops=1)
--         Buckets: 1024  Batches: 1  Memory Usage: 11kB
--         ->  Hash Join  (cost=2.22..3.35 rows=7 width=464) (actual time=0.061..0.071 rows=7 loops=1)
--               Hash Cond: (bookings.property_id = properties.property_id)
--               ->  Hash Join  (cost=1.14..2.23 rows=7 width=288) (actual time=0.035..0.042 rows=7 loops=1)
--                     Hash Cond: (bookings.user_id = users.user_id)
--                     ->  Seq Scan on bookings  (cost=0.00..1.07 rows=7 width=100) (actual time=0.003..0.004 rows=7 loops=1)
--                     ->  Hash  (cost=1.06..1.06 rows=6 width=188) (actual time=0.009..0.010 rows=6 loops=1)
--                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                           ->  Seq Scan on users  (cost=0.00..1.06 rows=6 width=188) (actual time=0.003..0.004 rows=6 loops=1)
--               ->  Hash  (cost=1.04..1.04 rows=4 width=176) (actual time=0.010..0.010 rows=4 loops=1)
--                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                     ->  Seq Scan on properties  (cost=0.00..1.04 rows=4 width=176) (actual time=0.003..0.004 rows=4 loops=1)
-- Planning Time: 1.327 ms
-- Execution Time: 0.263 ms



-- Refactored Query: Optimized query with indexing and filtering

CREATE INDEX idx_user_id ON users(user_id);
CREATE INDEX idx_booking_booking_id on bookings(booking_id);

EXPLAIN ANALYZE SELECT b.booking_id, u.user_id, u.first_name, p.property_id, p.name, pay.payment_id, pay.amount
 FROM bookings b
INNER JOIN users u on b.user_id = u.user_id
INNER JOIN properties p on p.property_id = b.property_id
INNER JOIN payments pay on pay .booking_id = b.booking_id
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31'; 


-- Nested Loop  (cost=4.18..16.01 rows=111 width=160) (actual time=0.042..0.101 rows=4 loops=1)
--   ->  Nested Loop  (cost=0.00..3.33 rows=1 width=112) (actual time=0.023..0.058 rows=10 loops=1)
--         Join Filter: (b.user_id = u.user_id)
--         Rows Removed by Join Filter: 13
--         ->  Nested Loop  (cost=0.00..2.19 rows=1 width=80) (actual time=0.015..0.035 rows=10 loops=1)
--               Join Filter: (b.property_id = p.property_id)
--               Rows Removed by Join Filter: 9
--               ->  Seq Scan on bookings b  (cost=0.00..1.10 rows=1 width=48) (actual time=0.008..0.012 rows=10 loops=1)
--                     Filter: ((start_date >= '2024-01-01'::date) AND (start_date <= '2024-12-31'::date))
--                     Rows Removed by Filter: 9
--               ->  Seq Scan on properties p  (cost=0.00..1.04 rows=4 width=48) (actual time=0.001..0.001 rows=2 loops=10)
--         ->  Seq Scan on users u  (cost=0.00..1.06 rows=6 width=48) (actual time=0.001..0.001 rows=2 loops=10)
--   ->  Bitmap Heap Scan on payments pay  (cost=4.18..12.64 rows=4 width=64) (actual time=0.003..0.003 rows=0 loops=10)
--         Recheck Cond: (booking_id = b.booking_id)
--         Heap Blocks: exact=4
--         ->  Bitmap Index Scan on idx_payment_booking_id  (cost=0.00..4.18 rows=4 width=0) (actual time=0.002..0.002 rows=1 loops=10)
--               Index Cond: (booking_id = b.booking_id)
-- Planning Time: 1.141 ms
-- Execution Time: 0.189 ms