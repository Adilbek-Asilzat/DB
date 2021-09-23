CREATE TABLE students (
         full_name varchar PRIMARY KEY,
         age integer NOT NULL,
         birth_date timestamp NOT NULL,
         gender varchar(6) NOT NULL,
         average_grade numeric(3,2) NOT NULL,
         information_about_yourself text,
         the_need_for_a_dormitory boolean NOT NULL,
         additional_info text
);
CREATE TABLE instructors (
         full_name varchar PRIMARY KEY,
         speaking_languages text NOT NULL,
         work_experience text NOT NULL,
         the_possibility_of_having_remote_lessons boolean NOT NULL
);
CREATE TABLE lesson_participants
(
    lesson_title        varchar PRIMARY KEY,
    teaching_instructor varchar REFERENCES instructors (full_name),
    studying_students   varchar REFERENCES students (full_name),
    room_number         integer NOT NULL
);

