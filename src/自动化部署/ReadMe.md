# 自动化部署
此套件使用docker容器技术，实现自动化获取源码、部署、更新。主要用于dotnet core网站应用开发。

---
## 必要条件
- 基于linux系统
- 基于docker容器技术
- 基于docker-compose组织容器服务
- 基于dotnet core网站部署
- 基于nginx作为反向路由
---

## 系统准备
以下步骤一个服务器只需要执行一次即可
- linux上安装好docker，版本为`18.03.1-ce`
- 安装好docker-compose
- 进入目录`GitBase`执行脚本`create.sh`，生成git基础镜像
```
cd ./GitBase
sh create.sh
```
---
## 生成项目
对于每个应用项目，应该独立执行以下步骤。这意味着每个应用会使用独立的nginx。所有操作都在目录`AutoDeployment`

### 修改配置文件
- 打开`.env`，设置以下项目
    - `cp_git_address`:你的源码git地址，使用ssh地址，并确保设置好项目使用公钥免密码认证。如果不想使用ssh，这里可以填写任何git项目地址，但应该确保地址不需要认证。但强烈建议使用ssh。
    - `cp_pj_name`:你的项目名字，这个名字应该与你的网站应用发布后的dll文件名字相同。例如：`ctwind.myweb`
    - `cp_main_name`:你的项目主名字。这个名字只是为了在docker区别开来，不需要太长的，并注意确保不同的项目使用不一样的名字。名字不能有大写字母。例如:`my-mvc`
    - `cp_ng_host_port`:nginx使用的端口。注意确保不同的项目使用不一样的值，并且没有被其他服务占用的端口。例如：`30001`

### 执行
- 执行docker-compose启动
```
docker-compose up -d --build
```
- 一切正常启动后，可以看到已经产生了4个容器。
```
docker-compose ps
```

- 在当前目录下会生成`src`和`published`两个目录。前者保存了最新的源码，后者保存了基于`src`中的源码编译发布后的文件

---

### 源码更新发布
如果新增的源码已经推送到github类托管网站，此时只需要开启3个容器，即可更新部署。
```
docker start -i {cp_main_name}-git &&\
docker start -i {cp_main_name}-publish &&\
docker-compose restart web 
```
- 上述脚本中的`{cp_main_name}`是你在`.env`下配置的值。例如你设置了`my-mvc`，那么你应该执行的命令为：
```
docker start -i mvc-git &&\
docker start -i mvc-publish &&\
docker-compose restart web 
```
---

### 查错相关
在使用docker-compose启动后，可能由于意外情况没有能正常启动服务，以下是一些排查。注意使用`docker-compose`命令都必须先`cd`到`docker-compose.yml`所在目录下。

- 正常启动后，应该生成4个容器，其中git和publish后缀的容器处于exitd状态，web和nginx处于up状态。假如web没能启动起来，那么可以查看最新的log。执行以下命令后，终端会被一直占用来更新日志，按`ctrl+z`退出。
```
# 4个服务的日志
docker-compose logs

# 只看每个服务的最后10条
docker-compose logs -f --tail=10

# 查看网站应用的log
docker-compose logs web

# 只看最后10条
docker-compose logs -f --tail=10  web
```

- 正常启动后，希望停止服务并移除容器。
```
docker-compose rm -s -a -f
```