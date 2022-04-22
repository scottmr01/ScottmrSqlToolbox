SELECT
 c.Name,
 s.Name,
 s.StartDate,
 s.NextRunTime,
 s.LastRunTime,
 s.EndDate,
 s.RecurrenceType,
 s.LastRunStatus,
 s.MinutesInterval,
 s.DaysInterval,
 s.WeeksInterval,
 s.DaysOfWeek,
 s.DaysOfMonth,
 s.[Month],
 s.MonthlyWeek
FROM ReportServer.dbo.catalog AS c WITH (nolock)
 INNER JOIN ReportServer.dbo.ReportSchedule AS rs
		ON rs.ReportID = c.ItemID
 INNER JOIN ReportServer.dbo.Schedule AS s WITH (nolock)
		ON rs.ScheduleID = s.ScheduleID

ORDER BY s.name;