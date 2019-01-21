---
title: "Junit4加载spring配置文件进行单元测试"
tags: [Java,Junit]
slug: 1548056542
keywords: [Junit4加载spring配置文件进行单元测试]
date: 2019-01-21 15:42:22
draft: false
---


>配置BaseTest，然后后面的测试类继承此类即可进行单元测试


## 基类
``` java
@RunWith(SpringJUnit4ClassRunner.class)
// 告诉junit spring配置文件
@ContextConfiguration({ "classpath:spring/spring-dao.xml", "classpath:spring/spring-service.xml" })
public class BaseTest {

}
```

## 测试类
``` java
public class AreaDaoTest extends BaseTest{
	@Autowired
	private AreaDao areaDao;
	@Test
	public void testQueryArea() {	
		List<Area> listArea=new ArrayList<Area>();
		listArea=areaDao.queryArea();
		System.out.println(listArea.size());
	}

}
```
