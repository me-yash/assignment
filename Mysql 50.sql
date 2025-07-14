-- 1. Create database
CREATE DATABASE college_db;
USE college_db;

-- 2. Create table
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    department VARCHAR(50)
);

-- 3. Insert 5 records
INSERT INTO students (id, name, age, department) VALUES
(1, 'Yash Srivastava', 19, 'Computer Science'),
(2, 'Yaman Saini', 22, 'Mathematics'),
(3, 'Tanishk Rana', 20, 'Physics'),
(4, 'Raghav Sharma', 23, 'Biology'),
(5, 'Lakshay Khandelwal', 21, 'Computer Science');

-- 4. Fetch all records
SELECT * FROM students;

-- 5. Fetch students with age > 20
SELECT * FROM students WHERE age > 20;

-- 6. Update department where name is 'Yash Srivastava'
UPDATE students SET department = 'Chemistry' WHERE name = 'Yash Srivastava';

-- 7. Delete student with ID = 3
DELETE FROM students WHERE id = 3;

-- 8. Order students by age DESC
SELECT * FROM students ORDER BY age DESC;

-- 9. Fetch distinct departments
SELECT DISTINCT department FROM students;

-- 10. Count total students
SELECT COUNT(*) AS total_students FROM students;

-- 11. Rename table
RENAME TABLE students TO student_info;

-- 12. Add new column: email
ALTER TABLE student_info ADD COLUMN email VARCHAR(100);

-- 13. Find students whose name starts with 'A'
SELECT * FROM student_info WHERE name LIKE 'A%';

-- 14. Students aged between 18 and 25
SELECT * FROM student_info WHERE age BETWEEN 18 AND 25;

-- 15. Student with highest age
SELECT * FROM student_info ORDER BY age DESC LIMIT 1;

-- 16. First 3 students using LIMIT
SELECT * FROM student_info LIMIT 3;

-- 17. Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

-- 18. Insert records into courses
INSERT INTO courses (course_id, course_name, credits) VALUES
(101, 'Data Structures', 4),
(102, 'Linear Algebra', 3),
(103, 'Physics 101', 4);

-- 19. Students from 'Computer Science'
SELECT * FROM student_info WHERE department = 'Computer Science';

-- 20. Students from specific departments
SELECT * FROM student_info WHERE department IN ('Computer Science', 'Mathematics');

-- 21. Students aged between 20 and 30
SELECT * FROM student_info WHERE age BETWEEN 20 AND 30;

-- 22. Display current system date & time
SELECT NOW() AS current_datetime;

-- 23. Use AS to rename columns
SELECT name AS student_name, age AS student_age FROM student_info;

-- 24. Exclude students from a specific department
SELECT * FROM student_info WHERE department != 'Physics';

-- 25. Delete all records but keep table
DELETE FROM student_info;

-- 26. Create marks table
CREATE TABLE marks (
    student_id INT,
    subject VARCHAR(50),
    marks INT
);

-- 27. Insert records into marks table
INSERT INTO marks (student_id, subject, marks) VALUES
(1, 'Math', 85),
(1, 'Physics', 90),
(2, 'Math', 70),
(2, 'Physics', 65),
(4, 'Biology', 88);

-- 28. JOIN students and marks data
SELECT s.id, s.name, m.subject, m.marks
FROM student_info s
JOIN marks m ON s.id = m.student_id;

-- 29. Average marks per student
SELECT student_id, AVG(marks) AS avg_marks FROM marks GROUP BY student_id;

-- 30. Total marks per student
SELECT student_id, SUM(marks) AS total_marks FROM marks GROUP BY student_id;

-- 31. Students with total marks > 200
SELECT student_id, SUM(marks) AS total_marks
FROM marks
GROUP BY student_id
HAVING SUM(marks) > 200;

-- 32. Students with same age
SELECT age, COUNT(*) as count FROM student_info GROUP BY age HAVING COUNT(*) > 1;

-- 33. INNER, LEFT, RIGHT JOIN examples
-- INNER JOIN
SELECT * FROM student_info s INNER JOIN marks m ON s.id = m.student_id;
-- LEFT JOIN
SELECT * FROM student_info s LEFT JOIN marks m ON s.id = m.student_id;
-- RIGHT JOIN (may not work in all DBMS like SQLite)
SELECT * FROM student_info s RIGHT JOIN marks m ON s.id = m.student_id;

-- 34. Create table with PRIMARY KEY and AUTO_INCREMENT
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- 35. Table with FOREIGN KEY
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES student_info(id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 36. Subquery for maximum marks
SELECT MAX(marks) FROM marks;

-- 37. View for student total marks
CREATE VIEW student_totals AS
SELECT s.name, SUM(m.marks) AS total_marks
FROM student_info s
JOIN marks m ON s.id = m.student_id
GROUP BY s.name;

-- 38. Students who scored more than average
SELECT student_id, marks FROM marks
WHERE marks > (SELECT AVG(marks) FROM marks);

-- 39. Stored procedure to insert student
DELIMITER //
CREATE PROCEDURE insert_student(
    IN s_name VARCHAR(50),
    IN s_age INT,
    IN s_dept VARCHAR(50)
)
BEGIN
    INSERT INTO student_info(name, age, department) VALUES (s_name, s_age, s_dept);
END //
DELIMITER ;

-- 40. Stored procedure to update department
DELIMITER //
CREATE PROCEDURE update_department(
    IN s_id INT,
    IN new_dept VARCHAR(50)
)
BEGIN
    UPDATE student_info SET department = new_dept WHERE id = s_id;
END //
DELIMITER ;

-- 41. Function to calculate grade
DELIMITER //
CREATE FUNCTION get_grade(mark INT) RETURNS VARCHAR(10)
BEGIN
    DECLARE grade VARCHAR(10);
    IF mark >= 90 THEN SET grade = 'A';
    ELSEIF mark >= 75 THEN SET grade = 'B';
    ELSEIF mark >= 60 THEN SET grade = 'C';
    ELSE SET grade = 'D';
    END IF;
    RETURN grade;
END //
DELIMITER ;

-- 42. Trigger to log inserts
CREATE TABLE student_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(50),
    action_time DATETIME
);

DELIMITER //
CREATE TRIGGER after_student_insert
AFTER INSERT ON student_info
FOR EACH ROW
BEGIN
    INSERT INTO student_log(student_name, action_time)
    VALUES (NEW.name, NOW());
END //
DELIMITER ;

-- 43. Transaction example
START TRANSACTION;
UPDATE student_info SET department = 'Physics' WHERE id = 1;
UPDATE student_info SET department = 'Math' WHERE id = 2;
COMMIT;

-- 44. Find duplicates
SELECT name, COUNT(*) as count FROM student_info
GROUP BY name
HAVING COUNT(*) > 1;

-- 45. Backup database (run in terminal)
-- mysqldump -u root -p college_db > backup.sql

-- 46. Restore database (run in terminal)
-- mysql -u root -p college_db < backup.sql

-- 47. Import CSV data (example)
-- LOAD DATA INFILE 'students.csv'
-- INTO TABLE student_info
-- FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- 48. Create index on student name
CREATE INDEX idx_name ON student_info(name);

-- 49. Second highest mark in a subject
SELECT MAX(marks) AS second_highest
FROM marks
WHERE marks < (SELECT MAX(marks) FROM marks);

-- 50. Drop courses table
DROP TABLE courses;
-- Effect: All course data will be permanently deleted.
