---
title: "Java基础之集合"
tags: [Java]
slug: 1548058711
keywords: [Java基础之集合,集合框架，collection]
date: 2019-01-21 16:18:31
draft: true
---


> 在使用一个体系时，原则：参阅顶层内容。建立底层对象。

> 集合是可变长度的，用于存储对象，只能存储引用数据类型，可以存储不同类型的对象

![图片](http://localhost:1313/images/Clip_20190121_162904.jpg)

![图片](https://xuziyan.ga/images/Clip_20190121_162904.jpg)

## 使用集合的技巧

看到Array就是数组结构，有角标，查询速度很快。

看到link就是链表结构：增删速度快，而且有特有方法 `addFirst();addLast();removeFirst();removeLast(); getFirst();getLast();`

看到hash就是哈希表，就要想要哈希值，就要想到唯一性，就要想到存入到该结构的中的元素必须覆盖hashCode，equals方法。

看到tree就是二叉树，就要想到排序，就想要用到比较。

## 比较的两种方式
- 一个是Comparable：覆盖compareTo方法；
- 一个是Comparator：覆盖compare方法。
LinkedHashSet，LinkedHashMap:这两个集合可以保证哈希表有存入顺序和取出顺序一致，保证哈希表有序。

## 集合什么时候用？
- 当存储的是一个元素时，就用Collection。
- 当存储对象之间存在着映射关系时，就使用Map集合。
- 保证唯一，就用Set。不保证唯一，就用List。

## Collection接口
- List：有序(元素存入集合的顺序和取出的顺序一致)，元素都有索引。元素可以重复。
- Set：无序(存入和取出顺序有可能不一致)，不可以存储重复元素。必须保证元素唯一性。

## Iterator接口
 boolean |`hashNext`| 如果仍有元素可以迭代，则返回 true

 E       |`next()`| 返回迭代的下一个元素

 void    |`remove()`| 从迭代器指向的 collection 中移除迭代器返回的最后一个元素（可选操作）

```java
public static void main(String[] args) {
		Collection coll = new ArrayList();
		coll.add("abc0");
		coll.add("abc1");
		coll.add("abc2");
		//--------------方式1----------------------
		Iterator it = coll.iterator();
		while(it.hasNext()){
			System.out.println(it.next());
		}
		//---------------方式2用此种----------------------
		for(Iterator it = coll.iterator();it.hasNext(); ){
			System.out.println(it.next());
		}
	}
```
 >List本身是Collection接口的子接口，具备了Collection的所有方法。现在学习List体系特有的共性方法，查阅方法发现List的特有方法都有索引，这是该集合最大的特点


## List接口

有序(元素存入集合的顺序和取出的顺序一致)，元素都有索引。元素可以重复。

- ArrayList：底层的数据结构是数组,线程不同步，ArrayList替代了Vector，查询元素的速度非常快。

- LinkedList：底层的数据结构是链表，线程不同步，增删元素的速度非常快。

- Vector：底层的数据结构就是数组，线程同步的，Vector无论查询和增删都巨慢。

``` java
//List集合因为角标有了自己的获取元素的方式： 遍历。
for(int x=0; x<list.size(); x++){
	sop("get:"+list.get(x));
}
```

在进行list列表元素迭代的时候，如果想要在迭代过程中，想要对元素进行操作的时候，比如满足条件添加新元素。会发生`.ConcurrentModificationException`并发修改异常

既然是在迭代中对元素进行操作,找迭代器的方法最为合适.可是Iterator中只有hasNext,next,remove方法.通过查阅的它的子接口,`ListIterator`,发现该列表迭代器接口具备了对元素的增、删、改、查的动作

## Set接口

`HashSet`:底层数据结构是哈希表，线程是不同步的。无序，高效；
HashSet集合保证元素唯一性：通过元素的hashCode方法，和equals方法完成的。
当元素的hashCode值相同时，才继续判断元素的equals是否为true。
如果为true，那么视为相同元素，不存。如果为false，那么存储。
如果hashCode值不同，那么不判断equals，从而提高对象比较的速度。
      
`LinkedHashSet`：有序，hashset的子类。
	
`TreeSet`：对Set集合中的元素的进行指定顺序的排序。不同步。TreeSet底层的数据结构就是二叉树。

## Map集合

`Hashtable`：底层是哈希表数据结构，是线程同步的。不可以存储null键，null值。

`HashMap`：底层是哈希表数据结构，是线程不同步的。可以存储null键，null值。替代了Hashtable.

`TreeMap`：底层是二叉树结构，可以对map集合中的键进行指定顺序的排序。


## Collection 和 Collections的区别

`Collections`是个java.util下的类，是针对集合类的一个工具类,提供一系列静态方法,实现对集合的查找、排序、替换、线程安全化（将非同步的集合转换成同步的）等操作。

`Collection`是个java.util下的接口，它是各种集合结构的父接口，继承于它的接口主要有Set和List,提供了关于集合的一些操作,如插入、删除、判断一个元素是否其成员、遍历等。

## 哈希表的原理

1，对对象元素中的关键字(对象中的特有数据)，进行哈希算法的运算，并得出一个具体的算法值，这个值 称为哈希值。

2，哈希值就是这个元素的位置。

3，如果哈希值出现冲突，再次判断这个关键字对应的对象是否相同。如果对象相同，就不存储，因为元素重复。如果对象不同，就存储，在原来对象的哈希值基础 +1顺延。

4，存储哈希值的结构，我们称为哈希表。

5，既然哈希表是根据哈希值存储的，为了提高效率，最好保证对象的关键字是唯一的。

	这样可以尽量少的判断关键字对应的对象是否相同，提高了哈希表的操作效率。

对于ArrayList集合，判断元素是否存在，或者删元素底层依据都是equals方法。

对于HashSet集合，判断元素是否存在，或者删除元素，底层依据的是hashCode方法和equals方法。