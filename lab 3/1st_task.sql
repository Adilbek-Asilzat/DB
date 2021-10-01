select course_id
from course
where credits > 3;

select room_number
from classroom
where building = 'Watson' or building = 'Packard';

select course_id
from course
where dept_name = 'Comp. Sci.';

select course_id
from takes
where semester = 'Fall';

select id
from student
where tot_cred > 45 and tot_cred < 90;

select id
from student
where name like '%a' or name like '%e' or name like '%i' or name like '%o' or name like '%u' or name like '%y';

select course_id
from prereq
where prereq_id = 'CS-101';