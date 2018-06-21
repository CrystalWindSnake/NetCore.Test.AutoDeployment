# 自动化部署v1
源自于前一个版本的改进

---
## 改进
- 1. git的相关功能放到服务器主机上。
- 2. 编译发布和web运行的功能合并为一个容器。

---
## 变化
- 由于git功能不在容器中使用，因此不需要gitbase的镜像
- 制作dotnet-base镜像，内置处理脚本
- 在第一次部署时，执行脚本`git-clone.sh`，其中输入你的git项目地址，将会克隆代码到目录`src`。

---
### 源码更新发布
如果新增的源码已经推送到github类托管网站，此时需要执行git pull和重启web服务。可以执行脚本`renew.sh`
```
cd ./src &&\
git pull &&\
cd ../  &&\
docker-compose restart web
```




