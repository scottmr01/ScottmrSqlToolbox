USE ReportServer;
GO

WITH RankedReports
AS
(
 SELECT 
  c.Name
 ,c.ItemID
 ,e.UserName
 ,c.Path
 ,e.TimeStart
 ,RANK() OVER (PARTITION BY ReportID ORDER BY TimeStart DESC) AS iRank
 FROM Catalog as c
  LEFT JOIN ExecutionLog as e on c.ItemID = e.ReportID
)

SELECT *
FROM RankedReports as r
WHERE R.iRank = 1

ORDER BY TimeStart;