## Indexing Performance Report

This report explains the effects of adding indexes to the `users`, `bookings`, and `properties` tables. It compares how fast the database ran certain queries before and after the indexes were added. We also tested what happens when we force the database to use the index, even if it doesn't want to.

### Users Table (Filtering by `email`)

* **Before Index**: The database used a sequential scan and filtered out 5 rows.
* **After Index**: Still used a sequential scan, unless we forced it to use the index.
* **When Forced to Use Index**:

  * Query time got slower: from about 0.034 ms to 0.085 ms.
  * This happened because the table is very small (only 6 rows), and using an index adds extra work that isn't needed for such a small amount of data.

### Bookings Table (Filtering by `property_id`)

* **Before Index**: Sequential scan removed 3 rows and returned 4.
* **After Index**: The database still used a sequential scan.
* **When Forced to Use Index**:

  * Query time increased slightly: from about 0.036 ms to 0.081 ms.
  * Again, the table is small, so using an index takes more time than just scanning through the rows.


### Properties Table (Filtering by `property_id`)

* **Before Index**: Used a sequential scan and removed 3 rows.
* **After Index**: Still used a sequential scan by default.
* **When Forced to Use Index**:

  * Query time went up: from about 0.034 ms to 0.098 ms.
  * The small size of the table made the index less useful.

## Key Findings

* Indexes do not help much with small tables.
* The database chooses sequential scans because they are faster for small amounts of data.
* Forcing the database to use indexes made the queries slower.
* Planning time for the queries stayed very low. The extra time came from running the queries, not planning them.

## Conclusion

This test shows that indexes are not helpful on small tables and can even slow things down. However, it is still a good idea to add indexes early. As your database grows and has more rows, indexes will help make searches faster.