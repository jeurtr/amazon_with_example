##clear workplace
rm(list=ls())
##set directory
setwd('C:/Users/dell/Desktop/智干电商/data')

#load packages
library(sqldf)
library(ggplot2)
library(parallel)
library(doParallel)
library(ggthemes)    #pictures themes
library(Hmisc)

#parallel processing set up
n_CORES<-detectCores()  #检查CPU核数
cluster_set<-makeCluster(n_CORES) #进行并行运算
registerDoParallel(cluster_set)

##load data
test<-read.csv('./data3.csv',header=T,encoding = 'utf-8')

#ReviewSum
R<-sqldf('select distinct Asin,count(ReviewSum) AS ReviewSum
         from test
         group by Asin')

##star_count
#star_1_count
star_1_count<-sqldf('select distinct Asin,count(star) as star_1_count
          from test
          where star=1
          group by Asin ')

#star_2_count
star_2_count<-sqldf('select distinct Asin,count(star) as star_2_count
          from test
          where star=2
          group by Asin ')

##star_3_count
star_3_count<-sqldf('select distinct Asin,count(star) as star_3_count
          from test
          where star=3
          group by Asin ')

##star_4_count
star_4_count<-sqldf('select distinct Asin,count(star) as star_4_count
          from test
          where star=4
          group by Asin ')

##star_5_count
star_5_count<-sqldf('select distinct Asin,count(star) as star_5_count
          from test
          where star=5
          group by Asin ')

##star_mean
mode(test$Star)
m1<-sqldf('select distinct Asin,count(ReviewSum) as a
          from test
          group by Asin ')
m2<-sqldf('select distinct Asin,sum(star) as b
          from test
          group by Asin ')
#bind
m3<-merge(m1,m2,by='Asin')

#
m3$mean<-m3$b/m3$a
var<-names(m3)%in%c('a','b')
star_mean<-m3[!var]

##注释
if(false){
attach(m3)
star_mean<-b/a
attach(m3)}

##注释
if(false){a<-sqldf('select *
          from test
          where Asin="1583556397"
         ')}

##star_min
star_min<-sqldf('select Asin,min(star)
                from test
                group by Asin')


##star_max
star_max<-sqldf('select Asin,max(star)
                from test
                group by Asin')

##helpfulvote
##helpfulvote_sum
mode(test$HelpfulVote)
h_sum<-sqldf('select DISTINCT Asin,sum(HelpfulVote)
             from test
             where HelpfulVote != 0
             group by Asin')
##helpfulvote_count
h_count<-sqldf('select DISTINCT Asin,count(HelpfulVote)
             from test
             where HelpfulVote != 0
             group by Asin')

#verifiedPurchase
##vp_is_rate

##vp_count
vp_count<-sqldf('select Asin,count(verifiedPurchase)
                  from test
                  where verifiedPurchase != 0
                  group by Asin')

##AgeReview 
##分箱操作
##AgeReview<-test[c(1,5)]
##attach(AgeReview)
#AgeReview$AgeReview<-scale(AgeReview$AgeReview) #标准化
#detach()

##合并数据集成为宽表
##star_count
star_count<-merge(star_1_count,star_2_count,by='Asin') #star_1_count,star_2_count合并，以此类推
star_count<-merge(star_count,star_3_count,by='Asin')
star_count<-merge(star_count,star_4_count,by='Asin')
star_count<-merge(star_count,star_5_count,by='Asin')
star_all<-merge(star_count,star_max,by='Asin') #与star_max合并
star_all_1<-merge(star_all,star_min,by='Asin') #与star_min合并
star_all_2<-merge(star_all_1,star_mean,by='Asin') #与star_mean合并
##与ReviewSum
star_all_3<-merge(star_all_2,R,by='Asin')
##与helpfulvote
all_1<-merge(star_all_3,h_count,by='Asin')
all_2<-merge(all_1,h_sum,by='Asin')
##与AgeReview

##输出宽表
write.csv(all_2,'./train.csv')



