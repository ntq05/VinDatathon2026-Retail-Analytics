import duckdb

conn = duckdb.connect(
    "data/warehouse/retail.duckdb",
    read_only = True
)

print(conn.execute("""
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'bronze'
    ORDER BY table_name
""").df())

print(conn.execute("""
    SELECT *
    FROM bronze.orders
    LIMIT 5
""").df())

conn.close()