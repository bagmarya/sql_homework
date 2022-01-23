/* 1_Спроектировать базу данных hh (основные таблицы: вакансии, резюме, отклики, специализации). По необходимым столбцам
ориентироваться на сайт hh.ru*/

CREATE TABLE specialization_group(
	specialization_group_id serial PRIMARY KEY,
	specialization_group_name text NOT NULL);

CREATE TABLE specialization (
	specialization_id serial PRIMARY key,
	specialization_group_id int not null,
	specialization_name text NOT null,
FOREIGN KEY ( specialization_group_id ) REFERENCES specialization_group ( specialization_group_id ) ON DELETE CASCADE);

CREATE TABLE area (area_id serial PRIMARY KEY, area_name text NOT NULL);

CREATE TABLE required_experience (required_experience_id serial PRIMARY KEY,
description text NOT NULL);

CREATE TABLE employer (employer_id serial PRIMARY KEY, employer_name text NOT NULL);

CREATE TABLE response_status (status_id serial PRIMARY KEY, status_name text NOT NULL);

CREATE TABLE vacancy ( 
	vacancy_id serial PRIMARY KEY,
	employer_id integer NOT NULL,
	title text NOT NULL,
	compensation_from integer,
	compensation_to integer,
	required_experience_id integer,
	shedule varbit(5) DEFAULT b'10000',
	vacancy_description text,
	create_datе date NOT NULL,
	area_id integer,
	specialization_id integer,
FOREIGN KEY (employer_id) REFERENCES employer (employer_id) ON DELETE CASCADE,
FOREIGN KEY (required_experience_id) REFERENCES required_experience (required_experience_id) ON	DELETE SET NULL,
FOREIGN KEY (area_id) REFERENCES area (area_id) ON DELETE CASCADE,
FOREIGN KEY (specialization_id) REFERENCES specialization (specialization_id) ON DELETE	RESTRICT );

CREATE TABLE resume ( 
	resume_id serial PRIMARY KEY,
	title TEXT NOT NULL,
	compensation integer,
	applicant_id integer NOT NULL,
	about_me TEXT NOT NULL,
	area_id integer NOT NULL DEFAULT 1,
	ready_to_move bool NOT NULL,
	experience bool NOT NULL,
	specialization_id integer,
	create_datе date NOT NULL,
FOREIGN KEY (area_id) REFERENCES area (area_id) ON DELETE SET DEFAULT,
FOREIGN KEY (specialization_id) REFERENCES specialization (specialization_id) ON DELETE	RESTRICT );

CREATE TABLE response ( 
	response_id serial PRIMARY KEY,
	resume_id integer NOT NULL,
	vacancy_id integer NOT NULL,
	status_id integer NOT NULL,
	archive bool NOT NULL,
	create_datе date NOT NULL,
FOREIGN KEY (status_id) REFERENCES response_status (status_id) ON DELETE RESTRICT,
FOREIGN KEY (resume_id) REFERENCES resume (resume_id) ON DELETE CASCADE,
FOREIGN KEY (vacancy_id) REFERENCES vacancy (vacancy_id) ON DELETE CASCADE );
