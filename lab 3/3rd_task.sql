a) select distinct student.name
from student, takes
where student.id = takes.id and (takes.grade = 'A' or takes.grade = 'A-') and takes.course_id in(select course_id
                                                                                                  from course
                                                                                                   where course.dept_name = 'Comp. Sci.')
order by student.name asc;

b) select distinct instructor.name
    from instructor, advisor, takes
    where instructor.id = advisor.i_id and takes.id = advisor.s_id and (takes.grade != 'A' and
                                                                       takes.grade != 'A-' and
                                                                       takes.grade != 'B' and
                                                                       takes.grade != 'B+');

c) select distinct course.dept_name
from course, takes
    where  takes.course_id = course.course_id and course.dept_name not in(select course.dept_name
                                                                      from course
                                                                      where course_id in(select takes.course_id
                                                                                             from takes
                                                                                             where grade = 'F' or grade = 'C'));


d) select instructor.name
    from instructor, teaches, takes
    where  instructor.id = teaches.id and teaches.course_id = takes.course_id and takes.course_id not in(select course_id
                                                                                                          from takes
                                                                                                         where grade = 'A');

e) select distinct section.course_id
    from section, time_slot
    where section.time_slot_id = time_slot.time_slot_id and time_slot.time_slot_id not in(select time_slot.time_slot_id
                                                                                          from time_slot
                                                                                          where time_slot.end_hr > 13)
group by section.course_id;