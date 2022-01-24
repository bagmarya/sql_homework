/*Написать запрос для получения месяца с наибольшим количеством вакансий и месяца с наибольшим количеством резюме*/
SELECT(
	SELECT to_char(create_datе, 'Month') AS month_of_many_vacancy
	FROM vacancy
	GROUP BY 1
	ORDER BY count(*) DESC
	LIMIT 1
), (
	SELECT to_char(create_datе, 'Month') AS month_of_many_resume
	FROM resume
	GROUP BY 1
	ORDER BY count(*) DESC
	LIMIT 1
);
