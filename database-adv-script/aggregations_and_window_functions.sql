
-- Total number of bookings made by each user

SELECT count(booking_id), user_id FROM bookings
GROUP BY user_id;


-- Rank properties based on the total number of bookings they have received

SELECT *, 
  RANK() OVER (ORDER BY total_bookings DESC) as rank_no,
  ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_no
From(
    SELECT  properties.name, COUNT(bookings.property_id) AS total_bookings
    FROM bookings
    INNER JOIN properties on properties.property_id = bookings.property_id
    GROUP BY  properties.name
) AS sub;