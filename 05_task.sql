
/*Написать запрос для получения id и title вакансий, которые собрали больше 5 откликов в первую неделю после публикации*/

SELECT r.vacancy_id, v.title
FROM response r INNER JOIN vacancy v ON r.vacancy_id = v.vacancy_id 
WHERE  ( r.create_datе - v.create_datе ) <= 7
GROUP BY r.vacancy_id, v.title
HAVING count(*) > 5;
