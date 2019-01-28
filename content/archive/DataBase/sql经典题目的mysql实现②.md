---
title: "Sql经典题目的mysql实现②"
tags: [Sql]
slug: 1548494210
keywords: [Sql经典题目的mysql实现②]
date: 2019-01-26 17:16:50
draft: false
---
## 25、查询各科成绩前三名的记录（不考虑成绩并列情况）：
```sql
select t1.s_id,t1.c_id,t1.s_score
from score t1
where exists
(
select count(1) from score
where t1.c_id = c_id
and t1.s_score < s_score
having count(1) < 3
)
order by t1.c_id,s_score desc;
```
## 26、查询每门课程被选修的学生数：
```sql
-- 思路： 成绩表有修的应该就有选
select c_id,count(s_id) from score group by c_id;
-- 27、查询出只选修一门课程的全部学生的学号和姓名：
select s.s_id,s_name ,count(s_score) from score s,student where s.s_id=student.s_id group by s_id having count(s_score) =1;
```
## 28、查询男生、女生人数：
```sql
select
sum(case when s.s_sex='男' then 1 else 0 end) as 男生人数,
sum(case when s.s_sex='女' then 1 else 0 end) as 女生人数
from student s;


select (case when s_sex='男' then '男' else '女' end) 性别,count(1) 人数 from student group by s_sex;
```

## 29、查询姓“李”的学生名单：
```sql
SELECT * FROM student s
WHERE s.s_name LIKE '李%';
```
## 30、查询同名同姓的学生名单，并统计同名人数：
```sql
select s_name,count(1) 人数 from student group by s_name having 人数 >1;
```

## 31、1981年出生的学生名单
`（注：student表中sage列的类型是datetime）`
``` sql
select s_name,DATE_FORMAT(s_birth ,'%Y')as age from student_copy where DATE_FORMAT(s_birth ,'%Y')=1981;
```
## 32、查询平均成绩大于85的所有学生的学号、姓名和平均成绩：
```sql
select st.s_id,st.s_name,avg(s_score)as pjcj from score sc ,student st
where sc.s_id=st.s_id
group by sc.s_id
having pjcj>85 ;
```

## 33、查询每门课程的平均成绩
`结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列`
```sql
select c_id, avg(s_score)as pjcj from score s
group by c_id
order by pjcj ,c_id desc;
```
## 34、查询课程名称为“语文”，且分数低于60的学生名字和分数：
```sql
select st.s_name,sc.s_score
from course c,score sc ,student st
where c.c_name='语文'
and sc.s_score<60
and c.c_id=sc.c_id
and sc.s_id=st.s_id;
```
## 35、查询所有学生的选课情况：
```sql
select st.s_name,c.c_name from course c,score sc ,student st
where st.s_id=sc.s_id
and sc.c_id=c.c_id
and sc.s_score is not NULL
order by s_name;
```
## 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数：
```sql
select st.s_id,s_name,c_name , sc.s_score
from course c,score sc,student st
where st.s_id=sc.s_id
and sc.c_id=c.c_id
and sc.s_score between 70 and 100
order by s_id;
```
## 37、查询课程和不及格人数，并按课程号从大到小的排列：
```sql
select c_id ,sum(case when s_score<60 then 1 else 0 end) as 不及格人数 from score group by c_id;
```
## 38、查询课程编号为“003”且课程成绩在80分以上的学生的学号和姓名
``` sql
select sc.s_id,st.s_name,sc.s_score from score sc
left join student st on sc.s_id=st.s_id
where sc.c_id=03 and sc.s_score>=80
```
39、求选了课程的学生人数：
``` sql
select count(distinct s_id) from score where s_score is not null ;
```
## 40 查询选修“叶平”老师所授课程的学生中，成绩最高的学生姓名及其成绩
``` sql 
select sc.s_id,st.s_name,sc.s_score
 from score sc,course c, teacher t,student st
where sc.c_id=c.c_id
and c.t_id=t.t_id
and t.t_name='叶平'
and sc.s_id=st.s_id
and sc.s_score=(select max(s_score) from score where c_id=c.c_id);
-- 不建议的一种方法
select s.s_id,st.s_name ,s_score from  score s,student st
where s.s_id=st.s_id
and s_score =(select max(s_score) from score  where c_id in(select ss.c_id from score ss,course c,teacher te where ss.c_id=c.c_id and c.t_id=te.t_id and te.t_name='叶平')  )
and s.c_id in(select ss.c_id from score ss,course c,teacher te where ss.c_id=c.c_id and c.t_id=te.t_id and te.t_name='叶平')

```

## 41、查询各个课程及相应的选修人数
``` sql
select s.c_id, count(*) from score s where s.s_score is not null group by s.c_id
```
## 42、查询不同课程成绩相同的学生和学号、课程号、学生成绩
``` sql
-- mysql 会认为要过滤掉s1.s_id,  s1.c_id,s1.s_score字段都重复的记录,所以一般distinct用来查询不重复记录的条数
select DISTINCT s1.s_id,  s1.c_id,s1.s_score from score s1, score s2   
where s1.s_id=s2.s_id
and s1.c_id <> s2.c_id
and s1.s_score=s2.s_score
-- 如果要查询不重复的记录，有时候可以用group by 
select s1.s_id,  s1.c_id,s1.s_score from score s1, score s2   
where s1.s_id=s2.s_id
and s1.c_id <> s2.c_id
and s1.s_score=s2.s_score
group by s1.c_id
```
## 43、查询每门课程成绩最好的前两名
[未完成2019年1月26日 17:45:02]
``` sql
-- limit
select s.s_score from  score s order by s.s_score desc LIMIT 2 
select s.* from  score s  group by s.c_id -- 因为是按成绩分组 所以统计前两名就无法实现了
-- 思路：求成绩 in 前两名的数据

select s.s_id,t.s_name,s.s_score from score s ,student t
where s.s_score in (select s_score from  score   order by s_score desc LIMIT 2 )
```
## 44、统计每门课程的学生选修人数
`(超过2人的课程才统计)。要求输出课程号和选修人数，查询结果按人数降序排序，若人数相同，按课程号升序排序`
``` sql
select s.c_id ,count(*) as rs 
from score s 
group by  s.c_id 
having rs >2
order by rs DESC,s.c_id  ASC
```

## 45、检索至少选修两门课程的学生学号
``` sql
select s.s_id from  score s group by s.s_id having count(*)>2
```

## 46、查询全部学生选修的课程和课程号和课程名：
`这个题目其实需求不明确的,下面的语句能求出录入过成绩的课程`
``` sql
select  c.c_id,c.c_name
from course c
where c.c_id in(select c_id from score group by c_id);
```
## 47、查询没学过”叶平”老师讲授的任一门课程的学生姓名 
``` sql
-- 下面这个语句没有实现需求，不过能求到三国叶平老师课程的学生 
select  s.s_id AS id ,st.s_name,s.c_id from score s,student st where  s.s_id=st.s_id and s.c_id  in(select c.c_id from course c,teacher t where c.c_id=t.t_id and t.t_name='叶平') ; --  因为成绩表里面没有学叶平老师的学生还会有其他的课程成绩，所以仍会有他的数据出现在结果里面
-- war 正确的
select s.s_id, s_name 
from student  s
where s.s_id not in (select s_id from course c,teacher t,score sc where c.t_id=t.t_id and sc.c_id=c.c_id 
and t.t_name='叶平');
```
## 48、查询两门以上不及格课程的同学的学号以及其平均成绩
``` sql
-- 平均成绩，应该是所有课程的吧，那样思路就有了。先求出符合条件的学生，然后计算其平均成绩
select s_id ,avg(s_score) 
from score 
where s_id in 
(select s.s_id 
from score s 
where s.s_score <60  
group by s.s_id 
having count(s.s_score)>2) 
group by s_id;

-- 方法2
select s.s_id,avg(s.s_score) from score s group by s.s_id
having count(case when s.s_score<60 then s.c_id end)>2;
```

## 49、检索“01”课程分数小于60，按分数降序排列的同学学号
``` sql
select s.s_id,s.s_score from score s where s.c_id='01' and s.s_score<60 order by s.s_score DESC
```

## 50、删除“02”同学的“01”课程的成绩： 
``` sql
delete from score s where s.s_id='02' and s.c_id='01'
```


