# 基于Gost的上网解决方案



我目前的网络速度

https://speed.cloudflare.com/

![image-20240318182532094](./images/image-20240318182532094.png)

在很多大佬面前， 我这个速度是拖后腿了， 不过对于我做开发来讲， 完全够用了。 安装软件依赖包， 不需要设置镜像代理了

实际从境外站点下载速度实测， 以下截图是我下载大模型的文件的速度：

下载速度可以达到8.5MB/s， 要知道之前我使用的机场， 下载速度只有数百KB。 一个数量级的提升。 这样的速度足以应付我的日常搬砖工作。 

![image-20240318182950576](/Users/wanghe/Work/PandaBearLab.github.io/images/image-20240318182950576.png)



- 前端项目安装依赖基本上不在会国内境像折腾版本的问题了

- go的依赖也不会再去配置goproxy 环境变量了

- homebrew安装软件基本上是秒级了，基本上没有要下载一个大型软件包了

  



# 方法

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

- 稳定： 小流量个人使用， 从速度上， 稳定性上， 会比一般便宜的机场更好。  

## 自建成本考虑

就我目前的情况， 主要的费用包括：

- 服务器： $169.99/年

> 搬瓦工上买的

- 域名：godaddy 申请的美国域名， 价格很便宜，我花37新台币（大概不10元人民币）

> 要注意： godaddy 第二年续费的时候就会很高了。 可以第二年更换一个域名。 

- 客户端软件： shadowrocket 花费是 $2.99
  - pc端： 我是macos， 用的是clashX， 现在没有提供下载链接了，需要你自己想想办法，找找下载安装包
  - 移动端： 我目前用了shadowrocket，美区app store 账号还可以找到其他的

- 成本价格。肯定是会比机场贵。 自建服务器的成本可以买一个高规格的机场服务。 性能和稳定性上应该也会达到自建服务器的水准。 不过需要你找到靠普的机场服务商。  
- 搭建与维护。 折腾这个会比较费时间。  当然也是可以练习网络技能， 这也是一种动手学习的机会。  尤其是学生朋友们， 通过自己动手实践， 更能体其中的乐趣。 也会学到更多关于计算机网络协议、服务器有关的一些知识。  



# 自建「梯子」的方法

## 基本思路

> 本质上就是部署一个代理服务器，这个代理服务器负责转发网络流量



```mermaid
---
title: 
---
flowchart LR

subgraph 用户本地网络
user --> agent["本地客户端代理软件"]
end

subgraph 国际网络
agent--socks/https-->ProxyServer-->目标服务
end

```



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
  - shadowshocks：用非大陆地区的appleid 购买， 现在没有免费的， 我写这篇文章的时候价格是2.99$, 也是我目的在用的 





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

- 客户端软件

  - 如果是苹果手机，需要登陆美国app store，购买客户端软件， 我用的是showdaowrocket，俗称小火箭。 
  - android 我没有调研过，  只要能支持https、socks这类协议的客户端就可以了。 


## vps服务器

可以从以下的平台购买vps ， 一般新人都会有一些优惠

- [aws(亚马逊云)](https://aws.amazon.com/)
- [bwh(搬瓦工)](https://bwh8.net/)
- [ishosting](https://ishosting.com/en/vps)
- [azure](https://azure.microsoft.com/)

> 新人可以选择用用微软的azure，新人注册绑定信用卡后，可以获得200$的额度， 可以用来使用ms提供的各种各样的云服务， 其中之一就是vps
>
> 

我目前正在使用搬瓦工，我在搬瓦工上面找到了一个美国机器， 线路为CN2 GIAN ， 网络拥堵一般， 香港或日本会更快一些， 用美国的IP最大的好处是像chatgpt这类的服务不受限制， 日本一般也没有问题。   价格不算太便宜， 169.99$/年 



这个49.99$ 的一直处于**缺货的状态**

![image-20240318172348776](./images/image-20240318172348776.png)



$169.99 每年  价格不算太亲民

![image-20240318172512091](./images/image-20240318172512091.png)

## 域名&证书

###  域名注册

> 域名要从境外机构申请， 不要使用境内域名提供商

[godaddy](https://www.godaddy.com)

[dynadot](https://www.dynadot.com/)

[Namecheap](https://www.namecheap.com/)



### 域名解析

推荐将域名解析配置在[cloudfare](https://www.cloudflare.com) 上， 可以设置代理 

要把刚申请的域名解析到我们在bwh上买的vps机器的IP上 

![image-20240319095341967](./images/image-20240319095341967.png)



 输入你申请的域名 

![image-20240319095409997](./images/image-20240319095409997.png)

使用免费即可



![image-20240319095548087](./images/image-20240319095548087.png)



在配置域名解析之前， 你需要在godaddy上修改域名解析服务器为cloudflare 提供的地址

![image-20240319095833267](./images/image-20240319095833267.png)

修改godaddy 域名的解析服务器地址为cloudflare提供你的地址（就是上面的截图所示）

![image-20240319100138602](./images/image-20240319100138602.png)



当你修改的域名解析服务器地址生效后， cloudflare 会给你发一封邮件，告诉你已经修改成功。 



这时你就可以配置域名解析到你的申请的vps机器ip地址了。 



![image-20240319095659931](./images/image-20240319095659931.png)



### 证书

我用[Let's Encrypt](https://letsencrypt.org) 自行签了证书， 配置了执行计划， 定期重新签证书， 来保证HTTPS服务的正常可用。

安装[certbot ](https://certbot.eff.org/)

签证书

```bash
sudo certbot certonly --standalone
```



定期重新签证书， 以保证服务持续可用



```
crontab -e 
```

编辑如下内容

```
0 0 1 * * /usr/bin/certbot renew --force-renewal
5 0 1 * * /usr/bin/docker restart gost
```

> 1. 第一个任务：
>    - 时间规则：在每个月的第1天的0点0分执行。
>    - 命令：`/usr/bin/certbot renew --force-renewal`，这是用于自动更新SSL证书的命令。
> 2. 第二个任务：
>    - 时间规则：在每个月的第1天的0点5分执行。
>    - 命令：`/usr/bin/docker restart gost`，这是用于重启名为"gost"的Docker容器的命令。



> 推荐用docker来部署服务， 如果不喜欢， 可以将上面重启gost的方法换成bash脚本

**restart_gost.sh** 

```bash
#!/bin/sh
killall gost
./run_gost.sh
```



```
0 0 1 * * /usr/bin/certbot renew --force-renewal
5 0 1 * * /usr/bin/docker restart gost
```





## 部署gost

[gost 项目地址](https://github.com/ginuerzh/gost)

[gost wiki](https://v2.gost.run/)

gost 配置， 可以选择使用docker 安装部署， 也可以直接跑起来。  





**run_gost.sh**

```bash
#!/bin/bash

port=443
domain=www.example.com
user=xxxxx
password=yyyyy

gost -L "http2://${user}:${password}@0.0.0.0:${port}?cert=/etc/letsencrypt/live/${domain}/fullchain.pem&key=/etc/letsencrypt/live/${domain}/privkey.pem&probe_resist=file:/var/www/html/index.html&knock=www.google.com" > /dev/null 2>&1 &
```



**run_gost_in_docker.sh**

用docker部署容器的脚本

```bash
#!/bin/bash

port=443
domain=www.example.com
user=xxxxx
password=yyyyy

sudo docker run -d --name gost \
    -v ${CERT_DIR}:${CERT_DIR}:ro \
    --net=host ginuerzh/gost \
    -L "http2://${user}:${password}@0.0.0.0:${port}?cert=/etc/letsencrypt/live/${domain}/fullchain.pem&key=/etc/letsencrypt/live/${domain}/privkey.pem&probe_resist=file:/var/www/html/index.html&knock=www.google.com"
```



## 安装客户端



PC端： 推荐clash

移动端： shadowrockets



> 移动端需要一个境外手机号， 可以在淘宝搜paygo 买一个3$月租的电话卡， 可以自行充值 





### clash 配置



![clash_config](./images/clash_config.png)





**将这个[clash 配置文件](./scripts/run_gost.sh) 修改用户名和密码后， 放到这个目录下面。** 



![image-20240320151741280](./images/clash_reload_config.png)



# 最后



以上的自建的方法， 并不是万无一失的，  采用https 协议，伪装正常的web流量， 仍然有很大的概率会被封IP 

你可以考虑在cloudflare 上进行套壳访问， 即便vps被封了， 也能继续使用这台服务器。  

本文的上网方法不一定是最好的， 是我亲自测试验证过， 目前使用了一个月， 还没有遇到问题。 目前家庭3-5个人日常使用豪无压力， 我还可以在上面部署个人的博客。  

水平有限， 文中难免会有错误， 如果有错误请提出来帮助我修改。



