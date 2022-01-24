/*Написать запрос для получения средних значений по регионам (area_id) следующих величин: compensation_from, compensation_to,
среднееарифметическоеfromиto*/

SELECT
	area_id,
	avg(compensation_from) AS average_compensation_from,
	avg(compensation_to) AS average_compensation_to,
	avg((compensation_from + compensation_to)/ 2) AS average_of_average
FROM
	vacancy
GROUP BY
	area_id
ORDER BY
	area_id;
