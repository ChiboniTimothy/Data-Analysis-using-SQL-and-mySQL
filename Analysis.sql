-- 1. Find the titles of courses in the Comp. Sci department that have 4 credits.
-- Ans: 

            SELECT title FROM course
            WHERE dept_name = 'Comp. Sci' AND credits = 4;

-- 2. Find the name(s) of the instructor(s) who DON’T earn the lowest salary in Physics
-- Ans: 

            SELECT name FROM instructor
            WHERE dept_name = 'Physics' AND salary > (SELECT MIN(salary) FROM instructor WHERE
            dept_name = 'Physics');

-- 3. Find the enrollment of each section (number of students enrolled) that was
-- offered in Fall 2017.
-- Ans:

            SELECT sec_id, COUNT(*) as enrollment FROM section
            WHERE semester = 'Fall' AND year = 2017
            GROUP BY sec_id;


-- 3. Find the minimum enrollment, across all sections offered in Fall 2017
-- Ans: 

            SELECT MIN(enrollment) as minimum_enrollment FROM (
            SELECT COUNT(*) as enrollment FROM section
            WHERE semester = 'Fall' AND year = 2017
            GROUP BY sec_id
            ) as sections;

-- 4. Find the course ID and section ID of the sections that had the minimum enrollment
-- in Fall 2017.
-- Ans: 

            SELECT sec_id,course_id FROM section
            WHERE semester = 'Fall' AND year = 2017
            GROUP BY sec_id,course_id
            HAVING COUNT(*) = (SELECT MIN(enrollment) FROM (SELECT COUNT(*) as enrollment
            FROM section WHERE semester = 'Fall' AND year = 2017 GROUP BY sec_id) as sections);



-- 5. Find the names of all students who have taken at least two courses offered by
-- Comp. Sci.department; make sure there are no duplicate names in the result. Note
-- that student in other departments can take courses from Comp. Sci. as well.
-- Ans: 

            SELECT DISTINCT student.name
            FROM student JOIN takes ON student.ID = takes.ID
            JOIN section ON takes.course_id = section.course_id AND takes.sec_id = section.sec_id AND
            takes.semester = section.semester AND takes.year = section.year
            WHERE section.sec_id = 'Comp. Sci'
            GROUP BY student.ID
            HAVING COUNT(DISTINCT section.course_id) >= 2;

-- 6. Find the IDs and names of all students who have not taken any course offering in
-- 2017.
-- Ans: 

            SELECT student.ID, student.name
            FROM student
            WHERE student.ID NOT IN (
            SELECT ID
            FROM takes
            JOIN section ON takes.course_id = section.course_id AND takes.sec_id = section.sec_id
            AND takes.semester = section.semester AND takes.year = section.year
            WHERE section.year = 2017
            );

-- 7. For each department, find the name and salary of the instructor who earns the
-- minimum salary in that department. You may assume that every department has at
-- least one instructor.
-- Ans: 

            SELECT department.dept_name, instructor.name, instructor.salary
            FROM instructor
            JOIN department ON instructor.dept_name = department.dept_name
            JOIN (SELECT dept_name, MIN(salary) as min_salary FROM instructor GROUP BY
            dept_name) as min_salaries ON instructor.dept_name = min_salaries.dept_name AND
            instructor.salary = min_salaries.min_salary;

-- 8. Find the highest, across all departments, of the per-department minimum salary
-- computed by the preceding query (part 7.c).
-- Ans: 

            SELECT MAX(min_salary) as highest_min_salary
            FROM (SELECT dept_name, MIN(salary) as min_salary FROM instructor GROUP BY
            dept_name) as department_min_salaries;

-- 9. Find the course titles of all prerequisite courses of “CS-319”
-- Ans: 

            SELECT DISTINCT course.title
            FROM course
            JOIN prereq ON prereq.course_id = course.course_id
            WHERE prereq.prereq_id = 'CS-319';