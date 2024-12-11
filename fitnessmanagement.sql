
-- Create the Database and Use it

CREATE DATABASE FitnessManagement;
USE fitnessmanagement;

-- Create members Table
CREATE TABLE members (
	member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Create rooms Table

CREATE TABLE rooms (
	room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('Cardio', 'Weights', 'Studio') NOT NULL,
    capacity INT NOT NULL
);

-- Create departments Table

CREATE TABLE departments (
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- Create memberships Table

CREATE TABLE memberships (
	membership_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    room_id INT,
	FOREIGN KEY (member_id) REFERENCES members(member_id),
	FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    start_date DATE
);

-- Create trainers table

CREATE TABLE trainers (
	trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
	department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create appoitment table 

CREATE TABLE appointments (
	appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    trainer_id INT,
    member_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Create workout_plans table

CREATE TABLE workout_plans (
	plan_id INT PRIMARY KEY AUTO_INCREMENT,
    instructions VARCHAR(255),
    trainer_id INT,
    member_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 1 - Create Member (create number column first)

ALTER TABLE members
ADD COLUMN phone VARCHAR(15);

INSERT INTO members 
-- I used te email cuz Ive set it to not null
(first_name, last_name, gender, date_of_birth, email, phone)
VALUES ('Alex', 'Johnson', 'Male', '1990-07-15', 'alex@test.com', '1234567890')
;
INSERT INTO members 
-- I used te email cuz Ive set it to not null
(first_name, last_name, gender, date_of_birth, email, phone)
VALUES ('Mohamed', 'Ayadi', 'Male', '2001-01-01', 'm@@test.com', '1234567890')
;
INSERT INTO members 
-- I used te email cuz Ive set it to not null
(first_name, last_name, gender, date_of_birth, email, phone)
VALUES ('Alex', 'haha', 'Male', '2007-01-01', 'test@test.com', '123123123')
;
-- 2 Select departments and their locations
SELECT department_name, location FROM departments

-- 3 ORDER BY ascending 

SELECT * FROM members ORDER BY date_of_birth -- default is ASC

--4 Filter by gender

SELECT DISTINCT gender FROM members;

-- 5 First 3 trainers

SELECT * FROM trainers LIMIT 3;

-- 6 members born after 2000 (idk why > 2000 expression didnt work)

SELECT * FROM members WHERE date_of_birth > '2000-01-01';

-- 7  get trainers from weights and cardio departments

SELECT * FROM trainers WHERE department_id IN (SELECT department_id FROM departments WHERE department_name IN ('Weights', 'Cardio'));

-- 8 date range

SELECT * FROM memberships WHERE start_date BETWEEN '2024-12-01' AND '2024-12-07';

-- 9 Age range

SELECT first_name, last_name, 
    CASE 
        WHEN YEAR(CURDATE()) - YEAR(date_of_birth) < 18 THEN 'Junior'
        WHEN YEAR(CURDATE()) - YEAR(date_of_birth) BETWEEN 18 AND 30 THEN 'Adult'
        ELSE 'Senior'
    END AS age_category
FROM members;

-- 10 count total number of appoitments

SELECT COUNT(*) AS total_appointments FROM appointments;

-- 11 COUNT with GROUP BY 

SELECT department_id, COUNT(*) AS number_of_trainers FROM trainers GROUP BY department_id;


-- 12 Average Age

SELECT AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS average_age FROM members;


-- 13 

SELECT MAX(appointment_date) AS last_appointment_date, MAX(appointment_time) AS last_appointment_time
FROM appointments;

--14

SELECT room_id, COUNT(*) AS total_memberships FROM memberships GROUP BY room_id;


-- 15

SELECT * FROM members WHERE email IS NULL;


-- 16

SELECT a.appointment_id, a.appointment_date, a.appointment_time, t.first_name AS trainer_first_name, t.last_name AS trainer_last_name, m.first_name AS member_first_name, m.last_name AS member_last_name
FROM appointments a
JOIN trainers t ON a.trainer_id = t.trainer_id
JOIN members m ON a.member_id = m.member_id;


-- 17

DELETE FROM appointments WHERE appointment_date < '2024-01-01';

--18

UPDATE departments SET department_name = 'Force et Conditionnement' WHERE department_name = 'weights';

-- 19

SELECT gender, COUNT(*) AS gender_count
FROM members
GROUP BY gender
HAVING gender_count >= 2;

-- 20

CREATE VIEW active_subscriptions AS
SELECT m.membership_id, m.member_id, m.room_id, m.start_date
FROM memberships m
WHERE m.start_date >= CURDATE();