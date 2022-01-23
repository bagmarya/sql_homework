/* Заполнить базу данных тестовыми данными (порядка 10к вакансий и 100к резюме) */


INSERT INTO specialization_group (specialization_group_name)
VALUES 
('Автомобильный бизнес'),
('Административный персонал'),
('Безопасность'),
('Высший менеджмент'),
('Добыча сырья'),
('Домашний, обслуживающий персонал'),
('Закупки'),
('Информационные технологии'),
('Искусство, развлечения, масс-медиа'),
('Маркетинг, реклама, PR'),
('Медицина, фармацевтика'),
('Наука, образование'),
('Продажи, обслуживание клиентов'),
('Производство, сервисное обслуживание'),
('Рабочий персонал'),
('Розничная торговля'),
('Сельское хозяйство'),
('Спортивные клубы, фитнес, салоны красоты'),
('Стратегия, инвестиции, консалтинг'),
('Страхование'),
('Строительство, недвижимость'),
('Транспорт, логистика, перевозки'),
('Туризм, гостиницы, рестораны'),
('Управление персоналом, тренинги'),
('Финансы, бухгалтерия'),
('Юристы'),
('Другое');


WITH test_data (id, specialization_group_id, specialization_name) AS (
SELECT
	generate_series(1,	200) AS id,
	((random()* 1000)::int%27 + 1)::int AS specialization_group_id,
	md5(random()::text ) AS specialization_name
)
INSERT INTO
	specialization (specialization_group_id,
	specialization_name)
SELECT
	specialization_group_id,
	specialization_name
FROM
	test_data;


WITH test_data (id, area_name) AS (
SELECT
	generate_series(1, 20) AS id,
	md5(random()::text ) AS area_name)
INSERT INTO
	area (area_name)
SELECT
	area_name
FROM
	test_data;


INSERT INTO required_experience (description) VALUES
('Не имеет значения'),
('Нет опыта'),
('От 3 до 6 лет'),
('От 1 года до 3 лет'),
('Более 6 лет');


INSERT INTO employer (employer_name) VALUES
('Завод'),
('Строительная компания'),
('Банк'),
('Кадровое агентство'),
('Торговая сеть'),
('Салон красоты');


INSERT INTO response_status (status_name) VALUES
('Резюме не просмотрено'),
('Резюме просмотрено'),
('Отказ'),
('Приглашение');


WITH test_data ( 
	id,
	employer_id,
	title,
	salary,
	required_experience_id,
	vacancy_description,
	create_datе,
	area_id,
	specialization_id 
) AS (
SELECT
	generate_series(1,
	10000) AS id,
	((random()* 100)::int%6 + 1)::int AS employer_id,
	md5(random()::text ) AS title,
	round((random()* 100000)::int,
	-3) AS salary,
	((random()* 100)::int%5 + 1)::int AS required_experience_id,
	md5(random()::text ) AS vacancy_description,
	date(timestamp '2021-01-01' + random() * (timestamp '2021-12-31' - timestamp '2021-01-01')) AS create_datе,
	((random()* 100)::int%20 + 1)::int AS area_id,
	((random()* 1000)::int%200 + 1)::int AS specialization_id 
)
INSERT INTO vacancy ( 
	employer_id,
	title,
	compensation_from,
	compensation_to,
	required_experience_id,
	shedule,
	vacancy_description,
	create_datе,
	area_id,
	specialization_id
)
SELECT
	employer_id,
	title,
	salary,
	salary + 10000,
	required_experience_id,
	b'10000',
	vacancy_description,
	create_datе,
	area_id,
	specialization_id
FROM
	test_data;



WITH test_data ( 
	id,
	title,
	compensation,
	applicant_id,
	about_me,
	area_id,
	specialization_id,
	create_datе
) AS (
SELECT
	generate_series(1, 100000) AS id,
	md5(random()::text ) AS title,
	round((random()* 100000)::int, -3) AS compensation,
	(random()* 100000)::int AS applicant_id,
	md5(random()::text ) AS about_me,
	((random()* 100)::int%20 + 1)::int AS area_id,
	((random()* 1000)::int%200 + 1)::int AS specialization_id,
	date(timestamp '2021-01-01' + random() * (timestamp '2021-12-31' - timestamp '2021-01-01')) AS create_datе 
)
INSERT INTO resume (
	title,
	compensation,
	applicant_id,
	about_me,
	area_id,
	ready_to_move,
	experience,
	specialization_id,
	create_datе
)
SELECT
	title,
	compensation,
	applicant_id,
	about_me,
	area_id,
	TRUE,
	FALSE,
	specialization_id,
	create_datе
FROM
	test_data;



WITH test_data (
	id,
	resume_id,
	vacancy_id 
) AS (
SELECT
	generate_series(1, 200000) AS id,
	(random()* 100000)::int AS resume_id,
	(random()* 10000)::int AS vacancy_id 
)
INSERT INTO response (resume_id,
	vacancy_id,
	status_id,
	archive,
	create_datе)
SELECT
	t.resume_id,
	t.vacancy_id,
	1,
	FALSE,
	((CASE WHEN v.create_datе > r.create_datе THEN v.create_datе ELSE r.create_datе END) + random() * INTERVAL '30 days')::date
FROM
	resume r
	INNER JOIN test_data t ON r.resume_id = t.resume_id
	INNER JOIN vacancy v ON	v.vacancy_id = t.vacancy_id;
	




