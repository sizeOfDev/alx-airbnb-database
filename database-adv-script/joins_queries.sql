-- INNER JOIN: Bookings with Users
SELECT 
    u.first_name, 
    u.last_name,
    b.start_date, 
    b.end_date, 
    b.status, 
    b.total_price
FROM users u
INNER JOIN bookings b ON u.user_id = b.user_id;

-- LEFT JOIN: Properties with Reviews
SELECT 
    p.name, 
    p.description, 
    p.location, 
    p.price_per_night,
    r.comment, 
    r.rating
FROM properties p
LEFT JOIN reviews r ON r.property_id = p.property_id
ORDER BY r.rating DESC NULLS LAST;

-- FULL OUTER JOIN: Users and Bookings
SELECT 
    u.first_name, 
    u.last_name,
    b.start_date, 
    b.end_date, 
    b.status, 
    b.total_price
FROM users u
FULL OUTER JOIN bookings b ON u.user_id = b.user_id;
