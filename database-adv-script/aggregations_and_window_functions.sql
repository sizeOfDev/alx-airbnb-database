-- Query 1: Total number of bookings made by each user
SELECT 
    user_id,
    COUNT(*) AS total_bookings
FROM 
    bookings
GROUP BY 
    user_id;

-- Query 2: Rank properties based on total number of bookings
WITH property_booking_counts AS (
    SELECT 
        property_id,
        COUNT(*) AS total_bookings
    FROM 
        bookings
    GROUP BY 
        property_id
)

SELECT 
    property_id,
    total_bookings,
    RANK() OVER (ORDER BY total_bookings DESC) AS property_rank
FROM 
    property_booking_counts;
