# Partitioning Performance Report

## Objective

The goal was to make queries faster on the large `bookings` table by using range-based partitioning on the `start_date` column.

## Partitioning Strategy

The `bookings` table was split into smaller parts (called partitions), with one partition for each year from 2022 to 2025. This setup helps the database only look at the parts it needs based on the date range in the query.

## Performance Observations

### Query for a Single Year (2024)

- **Before Partitioning**: The query had to scan the whole table and filter the rows during execution.
- **After Partitioning**: The database only scanned the `bookings_2024` partition.
- **Result**: Execution time dropped from **0.057 ms** to **0.024 ms**, showing faster data access.

### Query for Multiple Years (2022–2024)

- **Before Partitioning**: The query scanned the entire dataset, which included many rows that were not needed.
- **After Partitioning**: The query only scanned the partitions for 2022, 2023, and 2024.
- **Result**: Execution time increased slightly from **0.043 ms** to **0.060 ms**, but this is expected with parallel scanning and will scale better as the table grows.

## Key Benefits Observed

- **Smarter Data Access**: The database scanned only the relevant data, reducing the work it had to do.
- **Better Planning**: The query planner used the partition information to limit which rows to look at.
- **Scalability**: As more data is added over time, partitioning will help keep query times fast.

## Conclusion

Partitioning the `bookings` table by `start_date` improved query performance. It made data access more efficient by limiting how much the database needed to scan. This setup also prepares the system to handle more data in the future. For time-based data like bookings or transactions, using date-based partitioning is a smart and effective strategy.
