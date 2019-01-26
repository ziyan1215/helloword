---
title: "Sql经典题目的mysql实现②"
tags: [Sql]
slug: 1548494210
keywords: [Sql经典题目的mysql实现②]
date: 2019-01-26 17:16:50
draft: true
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

## 31、1981年出生的学生名单（注：student表中sage列的类型是datetime）:
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

## 33、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列：
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
## 43、查询每门课程成绩最好的前两名[未完成2019年1月26日 17:45:02]
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

# Q&A
这样是会报错的，要去掉分号


忘记写2表的关联where s.s_id=sc.s_id and 要注意
select distinct s.s_id,s.s_name from student s ,score sc where s.s_id=sc.s_id and sc.c_id in(select sc.c_id from student s ,score sc where s.s_id=sc.s_id and s.s_id='01'); -- 忘记写2表的关联where s.s_id=sc.s_id and 要注意

Every derived table must have its own alias(sql语法错误)
Every derived table must have its own alias：每一个派生出来的表都必须有一个自己的别名



知识点
关键词 DISTINCT 用于返回唯一不同的值。
语法：
SELECT DISTINCT 列名称 FROM 表名称

派生表是从SELECT语句返回的虚拟表。派生表类似于临时表，但是在SELECT语句中使用派生表比临时表简单得多，因为它不需要创建临时表的步骤。
术语:*派生表*和子查询通常可互换使用。当SELECT语句的FROM子句中使用独立子查询时，我们将其称为派生表。

“Group By”
从字面意义上理解就是根据“By”指定的规则对数据进行分组，所谓的分组就是将一个“数据集”划分成若干个“小区域”，然后针对若干个“小区域”进行数据处理。


Having与Where的区别
where 子句的作用是在对查询结果进行分组前，将不符合where条件的行去掉，即在分组之前过滤数据，where条件中不能包含聚组函数，使用where条件过滤出特定的行。
having 子句的作用是筛选满足条件的组，即在分组之后过滤数据，条件中经常包含聚组函数，使用having 条件过滤出特定的组，也可以使用多个分组标准进行分组

limit在mysql中的使用详解： 
语法：
SELECT * FROM table LIMIT [offset,] rows | rows OFFSET offset
LIMIT 子句可以被用于强制 SELECT 语句返回指定的记录数。LIMIT 接受一个或两个数字参数。参数必须是一个整数常量。
如果给定两个参数，第一个参数指定第一个返回记录行的偏移量，第二个参数指定返回记录行的最大数目。
初始记录行的偏移量是 0(而不是 1)： 为了与 PostgreSQL 兼容，MySQL 也支持句法： LIMIT # OFFSET #。
mysql> SELECT * FROM table LIMIT 5,10; // 检索记录行 6-15 ,注意，10为偏移量 
//为了检索从某一个偏移量到记录集的结束所有的记录行，可以指定第二个参数为 -1：
mysql> SELECT * FROM table LIMIT 95,-1; // 检索记录行 96-last.
//如果只给定一个参数，它表示返回最大的记录行数目：
mysql> SELECT * FROM table LIMIT 5; //检索前 5 个记录行 //也就是说，LIMIT n 等价于 LIMIT 0,n。
如果你想得到最后几条数据可以多加个 order by id desc

mysql不支持select top n的语法，应该用这个替换：
select * from tablename order by orderfield desc/asc limit position， counter；
position 指示从哪里开始查询，如果是0则是从头开始，counter 表示查询的个数
取前15条记录：
select * from tablename order by orderfield desc/asc limit 0,15
.
.
order by avg(t.score) asc
.
此题很经典，没做出来。rank over() 里面是是计算名次的排序；order by是记录展示的排序
.
.
.
注：这种写法更好一点，可以排除，同人同科目错误录入了两条记录的情况；
26、查询每门课程被选修的学生数：
.
select c#, count(s#) 
.
.
from sc 
.
.
group by c#;
.
27、查询出只选修一门课程的全部学生的学号和姓名：
.
select t2.s_Id,t2.sname from student t2 where t2.s_id 
.
.
in(select s_Id from sc group by sc.s_id having count(distinct sc.c_id)=1);
.
.
 
.
.
select t1.s_id,t2.sname from sc t1,student t2 where t1.s_id=t2.s_id 
.
.
group by t1.s_id,t2.sname having count(distinct t1.c_id)=1
.
.
 注：写法2 可加深对group by的理解，实际根据t1.s_id已经能够唯一定位，加上t2.sname完全是语法需要
28、查询男生、女生人数：
.
select count(Ssex) as 男生人数 
.
.
from student 
.
.
group by Ssex 
.
.
having Ssex='男'；
.
.
select count(Ssex) as 女生人数 
.
.
from student 
.
.
group by Ssex 
.
.
having Ssex='女';
.
.
select (case when ssex='M' then '男' else '女' end) 性别,count(1) 人数 from student group by ssex;
.
.
注：注意单引号，数据库里只识别单引号。
29、查询姓“张”的学生名单：
.
select sname 
.
.
from student 
.
.
where sname like '张%';
.
30、查询同名同姓的学生名单，并统计同名人数：
.
select sanme,count(*) 
.
.
from student 
.
.
group by sname 
.
.
havang count(*)>1;
.
31、1981年出生的学生名单（注：student表中sage列的类型是datetime）:
.
select sname, convert(char(11),DATEPART(year,sage)) as age
.
.
from student 
.
.
where convert(char(11),DATEPART(year,Sage))='1981';
.
32、查询平均成绩大于85的所有学生的学号、姓名和平均成绩：
.
select Sname,SC.S# ,avg(score)     
.
.
from Student,SC      
.
.
where Student.S#=SC.S# 
.
.
group by SC.S#,Sname 
.
.
having    avg(score)>85;
.
33、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列：
.
select C#, avg(score) 
.
.
from sc 
.
.
group by c# 
.
.
order by avg(score), c# desc;
.
34、查询课程名称为“数据库”，且分数低于60的学生名字和分数：
.
select sname, isnull(score,0) 
.
.
from student, sc ,course 
.
.
where sc.s#=student.s#  and sc.c#=course.c# and course.cname='数据库' and score<60;
.
35、查询所有学生的选课情况：
.
select sc.s#,sc.c#,sname,cname 
.
.
from sc,student course 
.
.
where sc.s#=student.s# and sc.c#=course.c#;
.
36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数：
.
select distinct student.s#,student.sname,sc.c#,sc.score 
.
.
from student,sc 
.
.
where sc.score>=70 and sc.s#=student.s#;
.
37、查询课程和不及格人数，并按课程号从大到小的排列：
.
select c# 
.
.
from sc 
.
.
where score<60 
.
.
order by c#;
.
.
select c_id , count(1) from sc where score < 60 group by c_id order by c_id;
.
.
注：很好的考察了对group by 用法的理解
38、查询课程编号为“003”且课程成绩在80分以上的学生的学号和姓名：
.
select sc.s#,student.sname 
.
.
from sc,student 
.
.
where sc.s#=student.s# and score>80 and c#='003';
.
39、求选了课程的学生人数：
select count(*) from sc;
.
select count(distinct c_id) from sc where score is not null;
.
.
注：感觉这样更严谨
40、查询选修“叶平”老师所授课程的学生中，成绩最高的学生姓名及其成绩：
.
select student.sname,score 
.
.
from student,sc,course c, teacher 
.
.
where student.s#=sc.S# and sc.c#=c.c#
.
.
and c.T#=teacher.T#
.
.
and teacher.tname='叶平' 
.
.
and sc.score=(select max(score) from sc where c#=c.c#);
.
.
select t4.sname 姓名,t3.score 成绩 from sc t3,student t4 where t3.s_id=t4.s_id and  t3.score=
.
.
(select max(score) from sc 
.
.
where c_id in(select t1.c_id from course t1,teacher t2 where t1.t_id=t2.t_id and t2.tname='叶平'));
.
.
注：连接4张表
41、查询各个课程及相应的选修人数：
select count(*) from sc group by c#;
42、查询不同课程成绩相同的学生和学号、课程号、学生成绩：
.
select distinct a.s#,b.score 
.
.
from sc a ,sc b 
.
.
where a.score=b.score 
.
.
and a.c#<>b.c#;
.
.
select t1.* from 
.
.
sc t1,sc t2 where 
.
.
t1.score=t2.score and t1.s_id<>t2.s_id and t1.c_id<>t2.c_id order by t1.score;
.
注：使用自连接的例子
43、查询每门课程成绩最好的前两名：
.
select t1.s# as 学生ID,t1.c#  课程ID, Score as 分数
.
.
from sc t1 
.
.
where score in (select top 2 score from sc 
.
.
        where t1.c#=c#
.
.
        order by score desc)
.
.
order by t1.c#;
.
select (select cname from course where c_id=t1.c_id) 课程名,t2.sname 学生姓名,t1.rank 排名 from 
(select c_id,s_id,rank() over(partition by c_id order by score desc) rank from sc) t1,student t2 
where t1.s_id=t2.s_id and t1.rank <3 
注：partition by 以前没用过，注意下用法；
44、统计每门课程的学生选修人数(超过10人的课程才统计)。要求输出课程号和选修人数，查询结果按人数降序排序，若人数相同，按课程号升序排序：
select c_id,count(distinct s_id) from sc group by c_id 
having count(distinct s_id)>10 order by count(distinct s_id) desc,c_id asc;
45、检索至少选修两门课程的学生学号：
.
select s# 
.
.
from sc 
.
.
group by s# 
.
.
having count(*)>=2;
.
46、查询全部学生选修的课程和课程号和课程名：
.
select c# ,cname
.
.
from course 
.
.
where c# in (select c# from sc group by c#);
.
47、查询没学过”叶平”老师讲授的任一门课程的学生姓名：
.
select sname 
.
.
from student 
.
.
where s# not in (select s# from course,teacher,sc where course.t#=teacher.t# and sc.c#=course.c# 
.
.
and tname='叶平');
.
select distinct  t3.s_id,t3.sname from student t3,sc t4 where t3.s_id=t4.s_id and t4.c_id 
not in(select t1.c_id from course t1,teacher t2 where t1.t_id=t2.t_id and t2.tname='叶平');
注：此题集合的思想，1、学过叶平的课的学生；2、叶平教过的课    取相反数
48、查询两门以上不及格课程的同学的学号以及其平均成绩：
.
select s#,avg(isnull(score,0)) 
.
.
from sc 
.
.
where s# in (select s# from sc where score<60 group by s# having count(*)>2)
.
.
group by s#;
.
select s_id,avg(score) from sc group by s_id 
having count(distinct case when score < 60 then c_id end)>2
49、检索“004”课程分数小于60，按分数降序排列的同学学号：
.
select s# 
.
.
from sc 
.
.
where c#='004' 
.
.
and score<60 
.
.
order by score desc;
.
50、删除“002”同学的“001”课程的成绩：
.
delect from sc 
.
.
where s#='002' 
.
.
and c#='001';
.

```