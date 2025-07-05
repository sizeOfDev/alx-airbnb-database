-- Query 1: Properties with Average Rating > 4.0
|SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.price_per_night
FROM properties p
WHERE (
    SELECT AVG(r.rating)
    FROM reviews r
    WHERE r.property_id = p.property_id
) > 4.0;

-- Query 2: Users with More Than 3 Bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM users u
WHERE (
    SELECT COUNT(*) 
    FROM bookings b 
    WHERE b.user_id = u.user_id
) > 3;
