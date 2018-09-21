SELECT 
	kind,
	type_desc,
	count(*) AS count
FROM (
	SELECT 
		SUBSTRING(
			name,
			1, 
			PATINDEX(
				'%[_]%', 
				SUBSTRING(
					name, 
					PATINDEX('%[_]%', name)  + 1 , 
					LEN(name)
					)
				) + PATINDEX('%[_]%', name) -1
			) AS kind,
		type_desc
	FROM sys.all_objects 
	WHERE name LIKE 'dm[_]%'
) AS dmv
GROUP BY kind, type_desc
ORDER BY 1