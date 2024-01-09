--DBW624 Assignment 5
--I write the script below based on the schema in A2.

use DBW624;

--1. Row compression
--Implementing row-level compression on the Salesrep_dimension table reduces storage requirements
--and may improve query performance. It reduces storage space, and cost, by storing fixed-length data
--types in variable length storage.
ALTER TABLE Salesrep_dimension
REBUILD WITH (DATA_COMPRESSION = ROW);

EXEC sp_spaceused 'Salesrep_dimension';
SELECT @@ERROR AS ErrorCode, @@ROWCOUNT AS RowsAffected;
--original: 10 rows, 72kb reserved, 8kb data, 8kb index_size, 56kb unused

--2. Range partitioning
--Range partitioning allows breaking down a logical table into multiple physical storage objects
--Each corresponds to a partition, and partition boundaries correspond to specifical value ranges
--This allows partition elimination during SQL processing
--Allows optimized roll-in or roll-out processing
--Allows divide and conquer table management

--drop foreign key and constraint to enable clustered index
ALTER TABLE dbo.Customers_dimension
DROP CONSTRAINT PK__Customer__A4AE64B8ABD37FCA;

--I choose CustDOB as the partition criterion
CREATE PARTITION FUNCTION [CustDOB_PF](date) AS RANGE LEFT FOR
VALUES (N'1950-02-28', N'1976-12-15')

CREATE PARTITION SCHEME [CustDOB_PS] AS PARTITION [CustDOB_PF]
TO ([PRIMARY], [PRIMARY], [PRIMARY])

CREATE CLUSTERED INDEX [PK__Customer__A4AE64B8ABD37FCA] ON [dbo].[Customers_dimension]
([CustDOB]) with (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [CustDOB_PS]([CustDOB]);

-- List all partition functions
SELECT 
    name AS PartitionFunctionName,
    type_desc AS Type,
    function_id AS FunctionID
FROM 
    sys.partition_functions;

-- List all partition schemes
SELECT 
    name AS PartitionSchemeName,
    type_desc AS Type,
    function_id AS FunctionID
FROM 
    sys.partition_schemes;

-- Check for clustered index on Customers_dimension table
SELECT
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ic.index_column_id AS ColumnOrder,
    col.name AS ColumnName
FROM
    sys.indexes i
INNER JOIN
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN
    sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
WHERE
    i.object_id = OBJECT_ID('Customers_dimension') AND
	--i.object_id = OBJECT_ID('sales_fact') AND
    i.type_desc = 'CLUSTERED';

SELECT @@ERROR AS ErrorCode, @@ROWCOUNT AS RowsAffected;

--clean up code
drop partition scheme CustDOB_PS
drop partition function CustDOB_PF

--3. Indexing
--Index improves the speed of data retrieval operations on a database table
--Indices can locate data quickly without the need to search every row in a table during each access
--As shown below, an index is based one or more columns of a table for random lookups and efficient
--access of ordered records

CREATE NONCLUSTERED INDEX idx_Products_SKU
ON Products_dimension(SKU);

--check out indices
EXEC sp_helpindex 'Products_dimension';

--sample
SELECT *
FROM Products_dimension
WHERE SKU = 1001;

SELECT @@ERROR AS ErrorCode, @@ROWCOUNT AS RowsAffected;

--clean up code
drop index if exists idx_Products_SKU on products_dimension

--4. Summary table
--A summary table is also called an aggregated table that store data at higher levels than it was stored
--when the data was initially captured and saved. It is important for speeding up performance for answering common
--business queries. While it is smaller than fact tables, it responds more quickly for navigation purposes.
use DBW624;
--from Assignment 4, query 6c
CREATE TABLE SalesRep_Summary (
    Year INT,
    Quarter INT,
    SalesRepName VARCHAR(255),
    SalesRevenue DECIMAL(10, 2),
    PRIMARY KEY (Year, Quarter, SalesRepName)
);

INSERT INTO SalesRep_Summary (Year, Quarter, SalesRepName, SalesRevenue)
SELECT
    d.Year,
    d.Quarter,
    sr.SalesRepName,
    SUM(sf.Revenue) AS SalesRevenue
FROM Sales_fact sf
JOIN Date_dimension d ON sf.DateID = d.DateID
JOIN Salesrep_dimension sr ON sf.SalesRepID = sr.SalesRepID
GROUP BY d.Year, d.Quarter, sr.SalesRepName;

select * from SalesRep_Summary ORDER BY SalesRevenue DESC;

SELECT @@ERROR AS ErrorCode, @@ROWCOUNT AS RowsAffected;
--clean up code
truncate table salesrep_summary;
drop table SalesRep_Summary;

--5. Index compression
--Index compression can reduce the storage space required for indexes while still maintaining query performance.
--It's a technique to compress the index key or an entire index page. The significance is it can save space,
--especially for larger tables, optimize query performances, and raise effectiveness for reading-intensive tasks.
CREATE NONCLUSTERED INDEX idx_Salesrep
ON Salesrep_dimension(SalesRepID);

ALTER INDEX idx_Salesrep
ON Salesrep_dimension
REBUILD WITH (DATA_COMPRESSION = PAGE);

--Check for indexes on the Salesrep_dimension table
SELECT 
    TableName = t.name,
    IndexName = ind.name,
    IndexType = ind.type_desc
FROM 
    sys.indexes ind
INNER JOIN 
    sys.tables t ON ind.object_id = t.object_id
WHERE 
    t.name = 'Salesrep_dimension';

SELECT @@ERROR AS ErrorCode, @@ROWCOUNT AS RowsAffected;

--clean up
drop index idx_Salesrep ON Salesrep_dimension;