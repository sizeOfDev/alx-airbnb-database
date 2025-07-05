-- Create partitioned table

CREATE TABLE bookings_partitioned (
  booking_id uuid NOT NULL,
  PRIMARY KEY (booking_id, start_date),
  property_id uuid NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  start_date date NOT NULL,
  end_date date NOT NULL,
  total_price decimal NOT NULL,
  status booking_status NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CHECK (end_date > start_date)
)PARTITION BY RANGE (start_date);



CREATE TABLE bookings_2022 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

INSERT INTO bookings_partitioned
SELECT * FROM bookings;



-- Performance of queries

EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-29';


-- Seq Scan on bookings  (cost=0.00..1.10 rows=1 width=100) (actual time=0.011..0.015 rows=10 loops=1)
--   Filter: ((start_date >= '2024-01-01'::date) AND (start_date <= '2024-12-29'::date))
--   Rows Removed by Filter: 9
-- Planning Time: 0.441 ms
-- Execution Time: 0.057 ms



EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2022-01-01' AND '2024-12-29';


-- Seq Scan on bookings  (cost=0.00..1.10 rows=1 width=100) (actual time=0.011..0.015 rows=16 loops=1)
--   Filter: ((start_date >= '2022-01-01'::date) AND (start_date <= '2024-12-29'::date))
--   Rows Removed by Filter: 3
-- Planning Time: 0.479 ms
-- Execution Time: 0.043 ms

EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-29';


-- Seq Scan on bookings_2024 bookings_partitioned  (cost=0.00..19.45 rows=3 width=100) (actual time=0.005..0.007 rows=10 loops=1)
--   Filter: ((start_date >= '2024-01-01'::date) AND (start_date <= '2024-12-29'::date))
-- Planning Time: 0.540 ms
-- Execution Time: 0.024 ms


EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE start_date BETWEEN '2022-01-01' AND '2024-12-29';


-- Append  (cost=0.00..58.39 rows=9 width=100) (actual time=0.008..0.023 rows=16 loops=1)
--   ->  Seq Scan on bookings_2022 bookings_partitioned_1  (cost=0.00..19.45 rows=3 width=100) (actual time=0.007..0.008 rows=3 loops=1)
--         Filter: ((start_date >= '2022-01-01'::date) AND (start_date <= '2024-12-29'::date))
--   ->  Seq Scan on bookings_2023 bookings_partitioned_2  (cost=0.00..19.45 rows=3 width=100) (actual time=0.006..0.007 rows=3 loops=1)
--         Filter: ((start_date >= '2022-01-01'::date) AND (start_date <= '2024-12-29'::date))
--   ->  Seq Scan on bookings_2024 bookings_partitioned_3  (cost=0.00..19.45 rows=3 width=100) (actual time=0.003..0.004 rows=10 loops=1)
--         Filter: ((start_date >= '2022-01-01'::date) AND (start_date <= '2024-12-29'::date))
-- Planning Time: 1.105 ms
-- Execution Time: 0.060 ms