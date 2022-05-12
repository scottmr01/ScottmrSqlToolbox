DECLARE
  @input varchar(max)
 ,@xml xml = NULL;

 /*
 Original query from Erland Sommarskog  https://www.sommarskog.se/arrays-in-sql.html
	Added escape character handling and tweaked
 used to parse comma separated strings into a temp table so can be used by the outer procedure/query
 When using in other procedures/queries use the following rules:
	1. the procedure will output the list. it should be captured by a temp table in the calling procedure
	2. xml restricted characters will be converted to their escape character to avoid xml formation issues.
	   this will not affect the returned value. SQL will convert it back in the shredding process
*/

SET @input = REPLACE(@input,'&','&amp;');
SET @input = REPLACE(@input,'"','&quot;');
SET @input = REPLACE(@input,'<','&lt;');
SET @input = REPLACE(@input,'>','&gt;');
SET @input = REPLACE(@input,'''','&apos;');

SET @xml = '<Root><String string="' + 
		   replace(convert(varchar(MAX), @input), 
				  ',' COLLATE SQL_Latin1_General_CP1_CI_AS, '"/><String string="') + 
		   '"/></Root>';

SELECT X.Item.value('@string[1]', 'varchar(100)') AS "item"
FROM @xml.nodes('/Root/String') AS X(Item);