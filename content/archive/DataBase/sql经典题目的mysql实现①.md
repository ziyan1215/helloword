---
title: "Sql经典题目的mysql实现①"
tags: [Sql]
slug: 1548473871
keywords: [Sql经典题目的mysql实现]
date: 2019-01-26 11:37:51
draft: false
---

> 数据准备请看文章底部 
<a href="#数据准备">点击我查看</a>

# 题目



## 1、查询“01”课程比“02”课程成绩高的所有学生的学号
``` sql
select  a.s_id from 
(select sc.s_id, sc.s_score from score sc where sc.c_id='01') a,
(select sc.s_id, sc.s_score from score sc where sc.c_id='02') b 
where a.s_score>b.s_score 
and a.s_id=b.s_id
```

   <table caption="a (2 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">02</td>
        </tr>
        <tr>
          <td class="col0">04</td>
        </tr>
      </tbody>
    </table>


## 2、查询平均成绩大于60分的同学的学号和平均成绩
``` sql
select sc.s_id ,
 avg(sc.s_score) 
 from score sc 
 group by sc.s_id 
 having avg(sc.s_score)>60
```
  <table caption="score (5 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
          <th class="col1">avg(sc.s_score)</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">89.6667</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">70.0000</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">80.0000</td>
        </tr>
        <tr>
          <td class="col0">05</td>
          <td class="col1">81.5000</td>
        </tr>
        <tr>
          <td class="col0">07</td>
          <td class="col1">95.0000</td>
        </tr>
      </tbody>
    </table>

## 3、查询姓‘李’的老师的个数
``` sql
select count(t.t_id) from teacher t where t.t_name like '李%';
```

## 4、查询所有同学的学号、姓名、选课数、总成绩
```sql
-- 自己的思路，先查到 选课数、总成绩，然后在关联查询
select  sc.s_id,count(sc.c_id) xks from score sc group by sc.s_id; #学生的选课数
select sc2.s_id ,(sc2.s_score) zcj from score sc2 group by sc2.s_id; #总成绩

select s.s_id,s.s_name ,sc.s_score from student s
left join score sc on s.s_id=sc.s_id;
-- 自己想的方法a
select s.s_id,s.s_name,t.xks ,t2.zcj from student s
left join (select  sc.s_id,count(sc.c_id) xks from score sc group by sc.s_id) t on s.s_id= t.s_id
left join  (select sc2.s_id,sum(sc2.s_score) zcj from score sc2 group by sc2.s_id) t2 on s.s_id=t2.s_id;

-- 网上答案
select s.s_id,s.s_name,count(sc.c_id),sum(sc.s_score) from student s
left join score sc on s.s_id=sc.s_id group by s_id,s_name;

-- 总结 两次左联结都是同一张表，所以可以合并，一次查出选课数 和总成绩
select count(s_id),sum(s_score) from score group by s_id ;
```

  <table caption="未知表 (8 rows)">
      <thead>
        <tr>
          <th class="col0">count(s_id)</th>
          <th class="col1">sum(s_score)</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">3</td>
          <td class="col1">269</td>
        </tr>
        <tr>
          <td class="col0">3</td>
          <td class="col1">210</td>
        </tr>
        <tr>
          <td class="col0">3</td>
          <td class="col1">240</td>
        </tr>
        <tr>
          <td class="col0">4</td>
          <td class="col1">160</td>
        </tr>
        <tr>
          <td class="col0">2</td>
          <td class="col1">163</td>
        </tr>
        <tr>
          <td class="col0">2</td>
          <td class="col1">65</td>
        </tr>
        <tr>
          <td class="col0">3</td>
          <td class="col1">285</td>
        </tr>
        <tr>
          <td class="col0">1</td>
          <td class="col1">60</td>
        </tr>
      </tbody>
    </table>

## 5、查询姓‘李’的老师的个数：
``` sql
select count(t.t_id) from teacher t where t.t_name like "李%"
```


## 6、查询没有学过“张三”老师课(数学)的同学的学号、姓名：
```sql
select * from score ;
select * from course  where t_id not in(01);

select s.s_id,s.s_name from student s
left join (select distinct(s_id) from score sc where c_id not in (02)) t on s.s_id=t.s_id;



select student.s_id, student.s_name
from Student
where s_id not in (select distinct(score.s_id) from score,course,teacher
where score.c_id=course.c_id AND teacher.t_id=course.t_id AND teacher.t_name ='张三');
```
## 7、查询学过“张三”老师（数学）所教的所有课的同学的学号、姓名
``` sql
select * from course where t_id in (select t_id from teacher where t_name='张三') ;
select * from score t where t.c_id in (select c_id from course where t_id in (select t_id from teacher where t_name='张三'));

-- 这里要用right join  已查询出来的那些学生作为主表，不然 左联结的话得出的结果是错误的
select t2.s_id,t2.s_name from student t2
right join (select * from score t where t.c_id in (select c_id from course where t_id in (select t_id from teacher where t_name='张三'))) t3 on t2.s_id= t3.s_id;

-- 别人的方法
select s_id , s_name from student
where s_id in (select s_id from score,course,teacher
where score.c_id=course.c_id and teacher.t_id=course.t_id and teacher.t_name='张三' group by s_id
having count(score.c_id)=(select count(c_id) from course,teacher
where teacher.t_id=course.t_id and t_name='张三'));

```

## 8、查询学过“01”并且也学过编号“02”课程的同学的学号、姓名：
```sql
select * from course where c_id='01'and c_id='02';
select * from score where c_id in ('01','02');
select * from  student st ,score sc ;
-- 注意，EXISTS子查询实际上不产生任何数据；它只返回 TRUE 或 FALSE 值
-- 如果外表的记录很多而子查询的记录相对较少的话，建议采用子查询IN写法；相反，如果子查询的记录很多而外表的记录相对较少，则建议采用子查询EXISTS写法。
select st.s_id,st.s_name from  student st ,score sc where st.s_id=sc.s_id and sc.c_id='01' and exists(select * from  score sc2 where sc2.s_id=sc.s_id and sc2.c_id='02');
```

## 9、查询课程编号“02”的成绩比课程编号“01”课程低的所有同学的学号、姓名：

```sql
select  sc.s_id,s.s_name,sc.s_score from student s ,score sc where s.s_id=sc.s_id and sc.c_id='02';
select  sc.s_id,s.s_name,sc.s_score from student s ,score sc where s.s_id=sc.s_id and sc.c_id='01';
select * from student s ;--  4*8
select * from score; --  3*18
select * from student s  ,score sc ;-- 7*144
select * ,s_score as s1 from student s  ,score sc where s.s_id=sc.s_id and c_id='01';
select * ,s_score as s2 from student s  ,score sc where s.s_id=sc.s_id and c_id='02';



select s_id,s_name from (select student.s_id,student.s_name,s_score,(select sc.s_score from score sc where sc.s_id=student.s_id and sc.c_id='02') s_score2
from student,score
where student.s_id=score.s_id and c_id ='01') t2 -- 这个表别名一定要取一个，不然会报错
where s_score2 < s_score;
```

## 10、查询所有课程成绩小于60的同学的学号、姓名：
```sql
select s_score from score where s_score>60; -- >60的
select s.s_id ,s.s_name from student s ,score sc where s.s_id=sc.s_id and sc.s_score not in (select s_score from score where s_score>60); -- 错误的
select s_id ,s_name from student s where s.s_id not in(select t1.s_id from student t1,score t2 where t1.s_id = t2.s_id and t2.s_score>60); -- 正确的解法
select s.s_id ,s.s_name from student s ,score sc where s.s_id=sc.s_id and sc.s_id not in (select s_id from score where s_score>60); -- 也是错误的
-- 思考： 查询的是学生，应该以学生为主表，不然的话学号是08的学生是没有成绩的，那么是查询不出来的
```

## 11、查询没有学全所有课的同学的学号、姓名：
``` sql
-- 这里学生08 没有学习过一门课程，没有查询出来
select t.s_id,t.s_name from student t,score s
where t.s_id=s.s_id
group by t.s_id ,t.s_name
having count(s.c_id)<(select count(c_id) from course);
```


## 12、查询至少有一门课与学号为“01”同学所学相同的同学的学号和姓名：
``` sql
select * from student s ,score sc where s.s_id=sc.s_id and s.s_id='01';
select distinct s.s_id,s.s_name from student s ,score sc
where s.s_id=sc.s_id and sc.c_id
in(select sc.c_id from student s ,score sc where s.s_id=sc.s_id and s.s_id='01'); -- 忘记写2表的关联where s.s_id=sc.s_id and 要注意

select distinct s.s_id,s.s_name from student s ,score sc
where s.s_id=sc.s_id 
and sc.c_id in(select c_id from score t where t.s_id='01');
```
## 13、查询学过学号为“01”同学所有课程的其他同学学号和姓名
``` sql
select s.s_id,s.s_name, count(t.c_id) from student s,score t
where s.s_id=t.s_id and t.c_id in
(select c_id from score where s_id='01')
group by s.s_id,s.s_name
having count(t.c_id)=(
select count(1) from score where s_id='01'
)
```
## 14、把“SC”表中“李四”老师教的课的成绩都更改为此课程的平均成绩：
``` sql
select distinct(sc.c_id) from score sc,course c,teacher t where t.t_id=c.t_id and c.c_id=sc.c_id and t.t_name='李四'; --  李四老师的课程编号
select avg(sc.s_score) from score sc,course c,teacher t where t.t_id=c.t_id and c.c_id=sc.c_id and t.t_name='李四'; -- 这里就不能用group by 语句了  李四老师的课程平均成绩
-- 两个括号里面的查询要用到表别名，不然在mysql里面会报错，oracle不知道会不会
update score set s_score =(select t4.cj from (select avg(sc.s_score) as cj from score sc,course c,teacher t where t.t_id=c.t_id and c.c_id=sc.c_id and t.t_name='李四')t4)
where score.c_id in (select t5.c_id from (select distinct(sc.c_id) from score sc,course c,teacher t where t.t_id=c.t_id and c.c_id=sc.c_id and t.t_name='李四')t5);

drop table score; -- 删除表
truncate  table score;-- 删除表数据
-- 成绩表
CREATE TABLE `Score`(
`s_id` VARCHAR(20),
`c_id`  VARCHAR(20),
`s_score` INT(3),
PRIMARY KEY(`s_id`,`c_id`)
);
-- 成绩表测试数据
insert into Score values('01' , '01' , 80);
insert into Score values('01' , '02' , 90);
insert into Score values('01' , '03' , 99);
insert into Score values('02' , '01' , 70);
insert into Score values('02' , '02' , 60);
insert into Score values('02' , '03' , 80);
insert into Score values('03' , '01' , 80);
insert into Score values('03' , '02' , 80);
insert into Score values('03' , '03' , 80);
insert into Score values('04' , '01' , 50);
insert into Score values('04' , '02' , 30);
insert into Score values('04' , '03' , 20);
insert into Score values('05' , '01' , 76);
insert into Score values('05' , '02' , 87);
insert into Score values('06' , '01' , 31);
insert into Score values('06' , '03' , 34);
insert into Score values('07' , '02' , 89);
insert into Score values('07' , '03' , 98);
```

## 15、查询和“02”号的同学学习的课程完全相同的其他同学学号和姓名
``` sql
-- 加入测试数据
INSERT INTO `sampledb`.`course` (`c_id`, `c_name`, `t_id`) VALUES ('04', '生物', '01');
INSERT INTO `sampledb`.`score` (`s_id`, `c_id`, `s_score`) VALUES ('04', '04', '60');

select s_id from score  where c_id  in

(select c_id from score where s_id='02')

group by s_id having count(*)=

(select count(*) from score  where score.s_id='02');
--  这个写法是有问题的，如果“1002”同学的学习课程是其它同学的子集，那么也会筛选出来；
-- 正确写法如下
-- t1
select s_id,count(distinct c_id) as cnt1 from score where c_id in(select c_id from score where s_id=2) and s_id<>2 group by s_id having count(distinct c_id)=(select count(distinct c_id) from score where s_id=2);
-- t2
select s_id,count(distinct c_id) as cnt2 from score group by s_id;

-- 语句
select t1.s_id from
(select s_id,count(distinct c_id) as cnt1 from score where c_id in
(select c_id from score where s_id=2)
and s_id<>2
group by s_id having count(distinct c_id)=
(select count(distinct c_id) from score where s_id=2))t1,
(select s_id,count(distinct c_id) as cnt2 from score group by s_id)t2
where t1.s_id=t2.s_id and t1.cnt1=t2.cnt2;
-- 思路，首先在其它同学所学的课程要在02同学所学习的课程之中，且计数要等于02同学的计算。
```
## 16、删除学习“王五”老师课的SC表记录：
``` sql
INSERT INTO `sampledb`.`teacher` (`t_id`, `t_name`) VALUES ('04', '叶平');
delete  score from score,course,teacher where score.c_id=course.c_id and course.t_id = teacher.t_id and t_name='叶平';
```
## 17、向SC表中插入一些记录
`这些记录要求符合以下条件：没有上过编号“03”课程的同学学号、02号课的平均成绩`
```sql
INSERT INTO `sampledb`.`score` (`s_id`, `c_id`, `s_score`) VALUES ('04', '04', '60');

Insert SC select s_id,'02',
(Select avg(s_score) from score where c_id='02')
from Student where s_id not in (Select s_id from score where c_id='03');
```
## 18、按平均成绩从高到低显示所有学生的“语文”、“数学”、“英语”三门的课程成绩
```sql
-- 按如下形式显示：学生ID，“语文”、“数学”、“英语，有效课程数，有效平均分：

select s_id as 学生ID,
(select score from sc where sc.s_id=t.s_id and c_id=1) as 语文,
(select score from sc where sc.s_id=t.s_id and c_id=2) as 数学,
(select score from sc where sc.s_id=t.s_id and c_id=3) as 英语,
count(*) as 有效课程数, avg(t.score) as 平均成绩,rank() over(order by avg(t.score) desc) as 名次
from sc t
group by s_id
order by avg(t.score) asc;

select sc.s_score from score sc where sc.c_id='01';-- cj 1*6

select s_id as 学生ID
from score t
group by t.s_id;

select s_id as 学生ID,
(select sc.s_score from score sc where sc.s_id=t.s_id and t.c_id='01')as 语文
from score t
group by t.s_id;
```
## 19、查询各科成绩最高和最低的分：
` 以如下的形式显示：课程ID，最高分，最低分`
```sql
select * from score where score.c_id=02 order by s_score desc;
select c_id,max(s_score) ,min(s_score) from score group by c_id;
```
## 20、按各科平均成绩从低到高和及格率的百分数从高到低顺序：
```sql

select *,avg(s_score)  from score group by c_id ;

select *,avg(s_score) as 平均成绩 ,
sum(case when s_score>59 then 1 else 0 end )/count(*)as 及格率 from score group by c_id order by 平均成绩,及格率 desc ;

-- 优化
select *,round(avg(s_score),2) as 平均成绩 ,
 CONCAT(round(sum(case when s_score>59 then 1 else 0 end )/count(1)*100,2),'%')及格率 from score group by c_id order by 平均成绩,及格率 desc ;
```
<table caption="score (4 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
          <th class="col1">c_id</th>
          <th class="col2">s_score</th>
          <th class="col3">平均成绩</th>
          <th class="col4">及格率</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">01</td>
          <td class="col2">80</td>
          <td class="col3">63.86</td>
          <td class="col4">71.43%</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">03</td>
          <td class="col2">99</td>
          <td class="col3">68.50</td>
          <td class="col4">66.67%</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">02</td>
          <td class="col2">90</td>
          <td class="col3">72.67</td>
          <td class="col4">83.33%</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">04</td>
          <td class="col2">60</td>
          <td class="col3">79.00</td>
          <td class="col4">100.00%</td>
        </tr>
      </tbody>
</table>

## 21、查询如下课程平均成绩和及格率的百分数(用”1行”显示):

<table caption="未知表 (1 rows)">
      <thead>
        <tr>
          <th class="col0">语文平均成绩</th>
          <th class="col1">语文及格率</th>
          <th class="col2">数学平均成绩</th>
          <th class="col3">数学及格率</th>
          <th class="col4">英语平均成绩</th>
          <th class="col5">英语及格率</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">63.86</td>
          <td class="col1">71.43%</td>
          <td class="col2">72.67</td>
          <td class="col3">83.33%</td>
          <td class="col4">68.50</td>
          <td class="col5">66.67%</td>
        </tr>
      </tbody>
    </table>

```sql
-- 下面这条语句实现不了拼接吧。。。
select *,round(avg(s_score),2) as 平均成绩 ,
CONCAT(round(sum(case when s_score>59 then 1 else 0 end )/count(1)*100,2),'%')及格率 from score where c_id='01'group by c_id order by 平均成绩,及格率 desc ;
-- 第一种为传统的case when使用方式：
select round(avg(case when c_id='01' then s_score end),2)as 语文平均成绩,
CONCAT(round(sum(case when c_id='01' and s_score>59 then 1 else 0 end )/sum(case when c_id='01' then 1 else 0 end)*100,2),'%') as 语文及格率 ,
round(avg(case when c_id='02' then s_score end),2)as 数学平均成绩,
CONCAT(round(sum(case when c_id='02' and s_score>59 then 1 else 0 end )/sum(case when c_id='02' then 1 else 0 end)*100,2),'%') as 数学及格率 ,
round(avg(case when c_id='03' then s_score end),2)as 英语平均成绩,
CONCAT(round(sum(case when c_id='03' and s_score>59 then 1 else 0 end )/sum(case when c_id='03' then 1 else 0 end)*100,2),'%') as 英语及格率
from score;
```
## 22、查询不同老师所教不同课程平均分从高到低显示：
```sql
-- 实现语句
select t3.t_name,t2.c_name ,round(avg(t1.s_score),2) 平均成绩 from score t1
left join course t2 on t1.c_id=t2.c_id
left join teacher t3 on t2.t_id=t3.t_id group by t1.c_id;
```
## 23、查询如下课程成绩第3名到第5名的学生成绩单：语文01、数学02、英语03
```sql
select * ,s_score from score where c_id='01' LIMIT 2,3;
```

## 24、统计下列各科成绩，各分数段人数：
`课程ID，课程名称，[100-85],[85-70],[70-60],[ 小于60] ：`

```sql
select s.* ,
sum(case when s_score  between 85 and 100 then 1 else 0 end) as '[100-85]' ,
sum(case when s_score  between 70 and 84 then 1 else 0 end) as '[85-70]',
sum(case when s_score  between 60 and 69 then 1 else 0 end) as '[70-60]',
sum(case when s_score  between 0 and 59 then 1 else 0 end) as '[小于60]'
from course c,score s where c.c_id=s.c_id  group by c_id ;


-- 实现方法2
select c.c_id as 课程id,c.c_name as 课程名称 ,
count(distinct case when s.s_score between 85 and 100 then s_id end) as '[85-100]' ,
count(distinct case when s_score  between 70 and 84 then s_id end) as '[85-70]',
count(distinct case when s_score  between 60 and 69 then s_id end) as '[70-60]',
count(distinct case when s_score  < 60 then s_id end) as '[小于60]'
from course c, score s
where c.c_id=s.c_id
group by s.c_id;
```

<table caption="score (4 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
          <th class="col1">c_id</th>
          <th class="col2">s_score</th>
          <th class="col3">[100-85]</th>
          <th class="col4">[85-70]</th>
          <th class="col5">[70-60]</th>
          <th class="col6">[小于60]</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">01</td>
          <td class="col2">80</td>
          <td class="col3">0</td>
          <td class="col4">4</td>
          <td class="col5">1</td>
          <td class="col6">2</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">02</td>
          <td class="col2">90</td>
          <td class="col3">3</td>
          <td class="col4">1</td>
          <td class="col5">1</td>
          <td class="col6">1</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">03</td>
          <td class="col2">99</td>
          <td class="col3">2</td>
          <td class="col4">2</td>
          <td class="col5">0</td>
          <td class="col6">2</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">04</td>
          <td class="col2">60</td>
          <td class="col3">1</td>
          <td class="col4">0</td>
          <td class="col5">1</td>
          <td class="col6">0</td>
        </tr>
      </tbody>
    </table>

## 25、查询学生平均成绩及其名次：
```sql
-- 错误的方法
select * ,avg(s_score) as mc from student st,score sc
where st.s_id=sc.s_id
group by sc.s_id
order by mc desc;

--  分组求各个学生的平均成绩
select s_id,avg(s_score)as pjcj
from score
group by s_id;
-- 实现方法
select 1+(select count(distinct pjcj)
from
(select s_id,avg(s_score)as pjcj
from score
group by s_id)as t1
where t1.pjcj>t2.pjcj) as mc,
s_id as xh,
pjcj
from
(select s_id,avg(s_score)as pjcj
from score
group by s_id)as t2
order by pjcj desc;
```

<table caption="score (1 rows)">
      <thead>
        <tr>
          <th class="col0">mc</th>
          <th class="col1">xh</th>
          <th class="col2">pjcj</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">2</td>
          <td class="col1">01</td>
          <td class="col2">89.6667</td>
        </tr>
      </tbody>
</table>

--- 

## 数据准备
``` sql
CREATE TABLE `Student`(
`s_id` VARCHAR(20),
`s_name` VARCHAR(20) NOT NULL DEFAULT '',
`s_birth` VARCHAR(20) NOT NULL DEFAULT '',
`s_sex` VARCHAR(10) NOT NULL DEFAULT '',
PRIMARY KEY(`s_id`)
);
--课程表
CREATE TABLE `Course`(
`c_id`  VARCHAR(20),
`c_name` VARCHAR(20) NOT NULL DEFAULT '',
`t_id` VARCHAR(20) NOT NULL,
PRIMARY KEY(`c_id`)
);
--教师表
CREATE TABLE `Teacher`(
`t_id` VARCHAR(20),
`t_name` VARCHAR(20) NOT NULL DEFAULT '',
PRIMARY KEY(`t_id`)
);
--成绩表
CREATE TABLE `Score`(
`s_id` VARCHAR(20),
`c_id`  VARCHAR(20),
`s_score` INT(3),
PRIMARY KEY(`s_id`,`c_id`)
);
--插入学生表测试数据

insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('08' , '王菊' , '1990-01-20' , '女');
--课程表测试数据
insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');

--教师表测试数据
insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

--成绩表测试数据
insert into Score values('01' , '01' , 80);
insert into Score values('01' , '02' , 90);
insert into Score values('01' , '03' , 99);
insert into Score values('02' , '01' , 70);
insert into Score values('02' , '02' , 60);
insert into Score values('02' , '03' , 80);
insert into Score values('03' , '01' , 80);
insert into Score values('03' , '02' , 80);
insert into Score values('03' , '03' , 80);
insert into Score values('04' , '01' , 50);
insert into Score values('04' , '02' , 30);
insert into Score values('04' , '03' , 20);
insert into Score values('05' , '01' , 76);
insert into Score values('05' , '02' , 87);
insert into Score values('06' , '01' , 31);
insert into Score values('06' , '03' , 34);
insert into Score values('07' , '02' , 89);
insert into Score values('07' , '03' , 98);
```
## 学生表

   <table caption="student (8 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
          <th class="col1">s_name</th>
          <th class="col2">s_birth</th>
          <th class="col3">s_sex</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">赵雷</td>
          <td class="col2">1990-01-01</td>
          <td class="col3">男</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">钱电</td>
          <td class="col2">1990-12-21</td>
          <td class="col3">男</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">孙风</td>
          <td class="col2">1990-05-20</td>
          <td class="col3">男</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">李云</td>
          <td class="col2">1990-08-06</td>
          <td class="col3">男</td>
        </tr>
        <tr>
          <td class="col0">05</td>
          <td class="col1">周梅</td>
          <td class="col2">1991-12-01</td>
          <td class="col3">女</td>
        </tr>
        <tr>
          <td class="col0">06</td>
          <td class="col1">吴兰</td>
          <td class="col2">1992-03-01</td>
          <td class="col3">女</td>
        </tr>
        <tr>
          <td class="col0">07</td>
          <td class="col1">郑竹</td>
          <td class="col2">1989-07-01</td>
          <td class="col3">女</td>
        </tr>
        <tr>
          <td class="col0">08</td>
          <td class="col1">王菊</td>
          <td class="col2">1990-01-20</td>
          <td class="col3">男</td>
        </tr>
      </tbody>
    </table>

## 教师表

  <table caption="teacher (4 rows)">
      <thead>
        <tr>
          <th class="col0">t_id</th>
          <th class="col1">t_name</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">张三</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">李四</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">王五</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">叶平</td>
        </tr>
      </tbody>
    </table>

## 课程表

<table caption="course (4 rows)">
      <thead>
        <tr>
          <th class="col0">c_id</th>
          <th class="col1">c_name</th>
          <th class="col2">t_id</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">语文</td>
          <td class="col2">02</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">数学</td>
          <td class="col2">01</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">英语</td>
          <td class="col2">03</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">生物</td>
          <td class="col2">04</td>
        </tr>
      </tbody>
    </table>

## 成绩表

  <table caption="score (21 rows)">
      <thead>
        <tr>
          <th class="col0">s_id</th>
          <th class="col1">c_id</th>
          <th class="col2">s_score</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="col0">01</td>
          <td class="col1">01</td>
          <td class="col2">80</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">01</td>
          <td class="col2">70</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">01</td>
          <td class="col2">80</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">01</td>
          <td class="col2">50</td>
        </tr>
        <tr>
          <td class="col0">05</td>
          <td class="col1">01</td>
          <td class="col2">76</td>
        </tr>
        <tr>
          <td class="col0">06</td>
          <td class="col1">01</td>
          <td class="col2">31</td>
        </tr>
        <tr>
          <td class="col0">08</td>
          <td class="col1">01</td>
          <td class="col2">60</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">02</td>
          <td class="col2">90</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">02</td>
          <td class="col2">60</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">02</td>
          <td class="col2">80</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">02</td>
          <td class="col2">30</td>
        </tr>
        <tr>
          <td class="col0">05</td>
          <td class="col1">02</td>
          <td class="col2">87</td>
        </tr>
        <tr>
          <td class="col0">07</td>
          <td class="col1">02</td>
          <td class="col2">89</td>
        </tr>
        <tr>
          <td class="col0">01</td>
          <td class="col1">03</td>
          <td class="col2">99</td>
        </tr>
        <tr>
          <td class="col0">02</td>
          <td class="col1">03</td>
          <td class="col2">80</td>
        </tr>
        <tr>
          <td class="col0">03</td>
          <td class="col1">03</td>
          <td class="col2">80</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">03</td>
          <td class="col2">20</td>
        </tr>
        <tr>
          <td class="col0">06</td>
          <td class="col1">03</td>
          <td class="col2">34</td>
        </tr>
        <tr>
          <td class="col0">07</td>
          <td class="col1">03</td>
          <td class="col2">98</td>
        </tr>
        <tr>
          <td class="col0">04</td>
          <td class="col1">04</td>
          <td class="col2">60</td>
        </tr>
        <tr>
          <td class="col0">07</td>
          <td class="col1">04</td>
          <td class="col2">98</td>
        </tr>
      </tbody>
    </table>
