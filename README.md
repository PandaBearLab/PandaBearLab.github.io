# 科学上网指南（一文搞定自建代理服务器） 



## 前言

我目前的网络速度

https://speed.cloudflare.com/

![image-20240318182532094](/Users/wanghe/Library/Application Support/typora-user-images/image-20240318182532094.png)

在很多大佬面前， 我这个速度是拖后腿了， 不过对于我做开发来讲， 完全够用了。 安装软件依赖包， 不需要设置镜像代理了



实际从境外站点下载速度实测， 以下截图是我下载大模型的文件的速度：

下载速度可以达到8.5MB/s， 要知道之前我使用的机场， 下载速度只有数百KB。 一个数量级的提升。 这样的速度足以应付我的日常搬砖工作。 



## 什么是科学上网？ 

不知道是哪位大神起名科学上网的。 一直都觉得这个名字比较玄学。  本质上科学上网其实就是一种网络上的攻防对抗。



防守方： 超大型防火墙

攻方： 每一个想要自由获取互联网信息的玩家



# 一般方法

- 自建服务器
  - 使用一些优秀的开源服务器软件，这些开源软件的作者深入研究了某墙的特点， 为此提出各种不同的方案，并开源了实现方案。 比如本文自建服务用到的是gost。 
- 使用机场服务
  - 有需求就有市场。  毕竟不是所有的人都有能力解决自建服务器的问题。 于是有人把自建服务器的方法， 包装成产品， 有尝提供有需要的用户。   大多数人能够访问国际网络， 通常选择都是机场。 
- 身在墙外
  - 这是最终极的方案。 



- 如果你有计算机相关的背景， 或者希望学习技术，或者从事IT类相关的工作， 可以选择自建服务器方法。 
- 如果你是其他专业背景， 平时也只是用来上网发发邮件、看看网页，可以考虑性价比高的机场服务。 



# 自建服务器的方法



我为什么要自建， 我觉得主要是两点的考虑：

- 安全： 使用机场的最大的问题是数据安全， 毕竟你的流量经过人家机房， 人家拿你的流量究竟做了什么， 你什么也不知道， 没有安全感。 

  > 给大家举例子， 不久前我们自建了套壳的gpt网站， 一些普通用户使用我们的网站提问或聊天， 我在后台可以看到聊天的全部内容， 建议大家选择套壳的gpt，一定要慎重啊

- 稳定： 小流量个人使用， 从速度上， 稳定性上， 会一般便宜的机场更好。  

## 自建成本考虑

就我目前的情况， 主要的费用包括：

- 服务器： $169.99/年
- 域名：godaddy 申请的美国域名， 价格很便宜，我花37新台币（大概不10元人民币）

> 要注意： godaddy 第二年续费的时候就会很高了。 可以第二年更换一个域名。 

- 客户端软件： shadowrocket 花费是 $2.99
  - pc端： 我是macos， 用的是clashX， 现在没有提供下载链接了，需要你自己想想办法，找找下载安装包
  - 移动端： 我目前用了shadowrocket，美区app store 账号还可以找到其他的

- 成本价格。肯定是会比机场贵。 自建服务器的成本可以买一个机场高规格的服务。 性能和稳定性上应该也会达到自建服务器的水准。 不过需要你找到靠普的机场服务商。  

- 搭建与维护。 折腾这个会比较费时间。  当然也是可以练习网络技能， 这也是一种动手学习的机会。  尤其是学生朋友们， 通过自己动手实践， 更能体其中的乐趣。 也会学到更多关于计算机网络协议、服务器有关的一些知识。  

  



# 自建「梯子」的方法

## 基本思路



**用gost将流量伪装为web服务绕过审查**

以下是解决上网的基本方法， 如果你非常有经验， 这部分足够你用了， 不必在浪费时间在下面更详细的方法上面了。 

```mermaid
graph LR

bwh["bwh注册CN2主机"]-->godday["申请域名GoDaddy"] --配置解析-->cloudflare -->host["解析到BWH主机" ]
bwh--签证书-->cert["Let's Encrypt "] --> cloudflare
host-->gost["部署gost服务"] --> 配置客户端

```

- CN2线路网络拥堵一般， 推荐使用， 选择CN2线路的机房

  > 我用了搬瓦工 

- Godaddy 申请一个美国的域名 

- 使用Let's Encrypt 签一个证书

- Cloudflare 配置解析域名 到刚申请机房ip

- 部署gost

  > 协议使用https， 没有使用普遍用的socks5， 如果你要使用telegram 这类只支持socks代理的软件， 需要在本地做代理转发。  

- 配置客户端（ios）

  > 类似方法， 大家可以去找关于android的方法， 非常简单，要是你有问题可以在推上私信我

  - clash:  非常好用的客户端代理工具， 支持很多种协议socks5, https,配置也比较简单
  - shadowshocks：有非大陆地区的appleid 购买， 现在没有免费的， 我写这篇文章的时候价格是2.99$, 也是我目的在用的 





# 更详细的操作步骤



## 准备

- VPS主机，1c1g 足够了 

  - 这台主机CN2 GIAN 线路的更好。  
  - 一定要在境外， 我选的是美国，不推荐选择境内的云服务商

- 境外域名， 可以上godaddy上面申请， 需要花钱。  

- 境外手机号，主要用于解决支付问题

  > 我是淘宝买的手机卡，淘宝搜paygo 能找一些商家
  >
  > 你可以直接去paygo官网自己买， 应该是没有问题的
  >
  > [paygo网址](https://www.ultramobile.com/paygo/)

  - 如果是苹果手机，需要登陆美国app store，购买客户端软件， 我用的是showdaowrocket，俗称小火箭。 
  - android 我没有调研过，  只要能支持https、socks这类协议的客户端就可以了。 

## vps服务器



- [aws(亚马逊云)](https://aws.amazon.com/)
- [bwh(搬瓦工)](https://bwh8.net/)
- [ishosting](https://ishosting.com/en/vps)
- [azure](https://azure.microsoft.com/)

> 新人可以选择用用微软的azure，新人注册绑定信用卡后，可以获得200$的额度， 可以用来使用ms提供的各种各样的云服务， 其中之一就是vps
>
> 

我目前正在使用搬瓦工，我在搬瓦工上面找到了一个美国机器， 线路为CN2 GIAN ， 网络拥堵一般， 香港或日本会更快一些， 用美国的IP最大的好处是像chatgpt这类的服务不受限制， 日本一般也没有问题。   价格不算太便宜， 169.99$/年 



这个49.99$ 的一直处于**缺货的状态**

![image-20240318172348776](/Users/wanghe/Library/Application Support/typora-user-images/image-20240318172348776.png)



$169.99 每年  价格不算太亲民

![image-20240318172512091](/Users/wanghe/Library/Application Support/typora-user-images/image-20240318172512091.png)

## 域名&证书

###  godaddy申请一个域名

 应该也有免费申请域名， 现在不好找， 提供免费域服务的越来越少了





### 证书

我用Let's Encrypt 自行签了证书， 配置了执行计划， 定期重新签证书， 来保证HTTPS服务的正常可用。



安装certbot 

```bash
sudo certbot certonly --standalone
```



签证书

```bash
sudo certbot certonly --standalone
```



### 域名解析

推荐将域名解析配置在cloudfare上， 可以设置代理 

要把刚申请的域名解析到我们在bwh上买的vps机器的IP上 



## 安装配置

[gost 项目地址](https://github.com/ginuerzh/gost)

[gost wiki](https://v2.gost.run/)

gost 配置， 可以选择使用docker 安装部署， 也可以直接跑起来。  



gost -L http2://wanghe:xuo5Ioye@0.0.0.0:4433?cert=/etc/letsencrypt/live/vpn.asdfghklhhhhh.online/fullchain.pem&key=/etc/letsencrypt/live/vpn.asdfghklhhhhh.online/privkey.pem&probe_resist=code:404&knock=www.google.com






