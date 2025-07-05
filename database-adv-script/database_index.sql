

EXPLAIN ANALYZE SELECT * FROM users
WHERE email='alx@example.com';


CREATE INDEX idx_email ON users(email);


EXPLAIN ANALYZE SELECT * FROM users
WHERE email='alx@example.com';



SET enable_seqscan = OFF;


EXPLAIN ANALYZE SELECT * FROM bookings
WHERE property_id = 'd4e5f6a7-b8c9-0123-4567-890abcdef123';



CREATE INDEX idx_booking_property_id on bookings(property_id);


EXPLAIN ANALYZE SELECT * FROM bookings
WHERE property_id = 'd4e5f6a7-b8c9-0123-4567-890abcdef123';



SET enable_seqscan = OFF;


EXPLAIN ANALYZE SELECT * FROM properties
WHERE property_id = 'd4e5f6a7-b8c9-0123-4567-890abcdef123';



CREATE INDEX idx_properties_property_id on properties(property_id);


EXPLAIN ANALYZE SELECT * FROM properties
WHERE property_id = 'd4e5f6a7-b8c9-0123-4567-890abcdef123';




SET enable_seqscan = OFF;
