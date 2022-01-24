
/*Создать необходимые индексы (обосновать выбор столбцов)*/

/*Пользователь как правило хочет увидеть в выдаче вакансии для своей специализации в своем регионе.*/
EXPLAIN ANALYSE SELECT vacancy_id, title 
FROM vacancy 
WHERE 
specialization_id = (SELECT specialization_id FROM specialization WHERE specialization_name = '89849516747b668372cec610620c8547') 
AND 
area_id = (SELECT area_id FROM area WHERE area_name = 'bbe12a4cbc5c228ca4ebe9b195be9f37');

/*Создадим для этого случая индекс по столбцам area_id и specialization_id. Это дало увеличение скорости выполнения запроса в 20 раз*/
CREATE INDEX area_specialization_index ON vacancy (area_id, specialization_id);
/* этот запрос также последовательно просматривает строки таблиц specialization и area, но так как таблицы не большие, создание индексов 
 для них не имеет большого эффекта в этой тестовой базе */

 
 
 
/*Другими наиболее интересными полями являются дата публикации вакансии и минимальная зарплата, 
 * так как я смотрю свежие вакансии и ищю зарплату выше своей текущей, но могу использовать эти критерии и по отдельности и вместе*/
EXPLAIN ANALYSE SELECT vacancy_id, title FROM vacancy WHERE compensation_from > 90000;
EXPLAIN ANALYSE SELECT vacancy_id, title FROM vacancy WHERE create_datе > now()::date - 30;
EXPLAIN ANALYSE SELECT vacancy_id, title FROM vacancy WHERE compensation_from > 90000 AND create_datе > now()::date - 30;

/*Создаем два отдельных индекса по этим столбцам. Это ускоряет выполнение запроса примерно в 20 раз*/
CREATE INDEX compensation_from_index ON vacancy (compensation_from);
CREATE INDEX date_index ON vacancy (create_datе);



/*Пользователь будет просматривать информацию по своим откликам, а работодатель по откликам на конкретную вакансию.*/
EXPLAIN ANALYSE SELECT vacancy_id FROM response WHERE resume_id = 86;
EXPLAIN ANALYSE SELECT resume_id FROM response WHERE vacancy_id = 592;

/*Добавим два отдельных индекса для таблицы откликов по столбцам vacancy_id и resume_id. 
 * прирост производительности для этих запросов примерно в 100 раз*/
CREATE INDEX resume_id_index ON response (resume_id);
CREATE INDEX vacancy_id_index ON response (vacancy_id);



/*Для работодателя также интересны специалисты определенного направления в заданном регионе. */
EXPLAIN ANALYSE SELECT resume_id, title 
FROM resume 
WHERE 
specialization_id = (SELECT specialization_id FROM specialization WHERE specialization_name = '89849516747b668372cec610620c8547') 
AND 
area_id = (SELECT area_id FROM area WHERE area_name = 'bbe12a4cbc5c228ca4ebe9b195be9f37');

/*Создадим индекс по столбцам area_id и specialization_id. Раз в 50 выполняется быстрее.*/
CREATE INDEX area_specialization_resume_index ON resume (area_id, specialization_id);

/*Добавим индекс по столбцу create_date. Для получения выборок с наиболее свежими резюме (или за определенный период)*/
CREATE INDEX resume_date_index ON resume (create_datе);




