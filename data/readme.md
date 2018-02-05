#亚马逊商品评论数据
数据包括：reviews-20170810 ；reviews-20170822 
          分别表示20170810、20170822亚马逊商品评论数据列表

 数据量：大概100万个商品，以及每个商品的每一条review数据，同时为了观察时效的影响，10天后又对相同的100w商品的review又爬了一次。

----------
字段说明：

rowid               按评论记录排序 
Asia                商品编号
StarSum	            总分数
ReviewSum	        总评论数
Star	            每个评论的分数
Author	            每个评论的作者
ReviewDate	        每个评论的时间
AgeReview	        评论距当前时间
HelpfulVote	        每个评论的支持投票数
VerifiedPurchase	每个评论是否为已购买者验证
CommentNum          每个评论对应的回复评价数
								
-----------								
我将在这个主页实现对数据进行分析的基本流程.包括:  
- 数据清洗
- 数据分析
- 特征抽取
- 搭建模型
- 模型评估  

----------

语言为R，工具包为：
R基础包
library(sqldf)
library(ggplot2)
library(parallel)
library(doParallel)
library(ggthemes)    #pictures themes
library(Hmisc)
。。。
。。。

