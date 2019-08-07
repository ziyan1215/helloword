---
title: "Java应用中访问ElasticSearch"
tags: [Elasticsearch]
slug: 1564215157
keywords: [Java应用中访问ElasticSearch]
date: 2019-07-27 16:12:37
draft: true
---


## 4 在Java应用中访问ElasticSearch

### 4.1 在Java应用中实现查询文档

```
##pom中加入ElasticSearch6.2.4的依赖：

<dependencies>
    <dependency>
      <groupId>org.elasticsearch.client</groupId>
      <artifactId>transport</artifactId>
      <version>6.2.4</version>
    </dependency>    
    
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
  
  </dependencies> 
  
  <build>
      <plugins>
			<!-- java编译插件 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.2</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
		</plugins>
  </build>  
 ``` 
### 4.2 在Java应用中实现添加文档
```
              "{" +
                "\"id\":\"1\"," +
                "\"title\":\"Java设计模式之装饰模式\"," +
                "\"content\":\"在不必改变原类文件和使用继承的情况下，动态地扩展一个对象的功能。\"," +
                "\"postdate\":\"2018-05-20 14:38:00\"," +
                "\"url\":\"csdn.net/79239072\"" +
                "}"
 
 

 XContentBuilder doc1 = XContentFactory.jsonBuilder()
                    .startObject()
                    .field("id","3")
                    .field("title","Java设计模式之单例模式")
                    .field("content","枚举单例模式可以防反射攻击。")
                    .field("postdate","2018-02-03")
                    .field("url","csdn.net/79247746")
                    .endObject();
        
        IndexResponse response = client.prepareIndex("index1", "blog", null)
                .setSource(doc1)
                .get();
        
		System.out.println(response.status());
```		
### 4.3 在Java应用中实现删除文档
```
DeleteResponse response=client.prepareDelete("index1","blog","SzYJjWMBjSAutsuLRP_P").get();

//删除成功返回OK，否则返回NOT_FOUND

System.out.println(response.status());
```
### 4.4 在Java应用中实现更新文档
```
 UpdateRequest request=new UpdateRequest();
        request.index("index1")
                .type("blog")
                .id("2")
                .doc(
                		XContentFactory.jsonBuilder().startObject()
                        .field("title","单例模式解读")
                        .endObject()
                );
UpdateResponse response=client.update(request).get();

//更新成功返回OK，否则返回NOT_FOUND

System.out.println(response.status());

upsert方式：

IndexRequest request1 =new IndexRequest("index1","blog","3")
                .source(
                		XContentFactory.jsonBuilder().startObject()
                                .field("id","3")
                                .field("title","装饰模式")
                                .field("content","动态地扩展一个对象的功能")
                                .field("postdate","2018-05-23")
                                .field("url","csdn.net/79239072")
                                .endObject()
                );
        UpdateRequest request2=new UpdateRequest("index1","blog","3")
                .doc(
                		XContentFactory.jsonBuilder().startObject()
                        .field("title","装饰模式解读")
                        .endObject()
                ).upsert(request1);
        
UpdateResponse response=client.update(request2).get();
        
//upsert操作成功返回OK，否则返回NOT_FOUND

System.out.println(response.status());

```
### 4.5 在Java应用中实现批量操作
```
 MultiGetResponse mgResponse = client.prepareMultiGet()
	                .add("index1","blog","3","2")
	                .add("lib3","user","1","2","3")
	                .get();
		    
for(MultiGetItemResponse response:mgResponse){
	            GetResponse rp=response.getResponse();
	            if(rp!=null && rp.isExists()){
	                System.out.println(rp.getSourceAsString());
	            }
	        }
	        
bulk：

BulkRequestBuilder bulkRequest = client.prepareBulk();

bulkRequest.add(client.prepareIndex("lib2", "books", "4")
                .setSource(XContentFactory.jsonBuilder()
                        .startObject()
                        .field("title", "python")
                        .field("price", 68)
                        .endObject()
                )
        );
bulkRequest.add(client.prepareIndex("lib2", "books", "5")
                .setSource(XContentFactory.jsonBuilder()
                        .startObject()
                        .field("title", "VR")
                        .field("price", 38)
                        .endObject()
                )
        );
        //批量执行
BulkResponse bulkResponse = bulkRequest.get();
        
System.out.println(bulkResponse.status());
if (bulkResponse.hasFailures()) {
            
            System.out.println("存在失败操作");
        }

```
