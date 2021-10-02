a) select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name
order by avg_salary asc;

b)
c)

d) select takes.id, student.name
from takes, student, course
where takes.id = student.id  and takes.grade != 'F' and takes.grade != '' and takes.course_id = course.course_id and course.dept_name = 'Comp. Sci.'
group by takes.id, student.name
having count(takes.course_id)>3;

e) select name
from instructor
where dept_name = 'Music' or dept_name = 'Philosophy' or dept_name = 'Biology';

f) select distinct instructor.name
from teaches, instructor
where teaches.id = instructor.id and teaches.id in(select id
                                                    from teaches
                                                     where year = 2018) and  teaches.id not in(select id
                                                                                               from teaches
                                                                                               where year = 2017);

