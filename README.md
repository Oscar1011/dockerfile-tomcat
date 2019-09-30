# tomcat
基于alpine linux安装tomcat，此镜像安装了一些调试工具ss、telnet、iostat、openssh等

时间不采用UTC时间，设置为中国上海时间；语言设置为zh_CN.UTF-8，支持中文

## 环境参数配置
- `ENABLE_SSH` 设置是否启动sshd，默认不启动
- `USER` 设置SSH用户名，默认root用户
- `PASSWORD` 设置SSH用户密码，默认"alpine@"

## 使用示例
```
docker run -d -p 22:22 -p 8080:8080 -e ENABLE_SSH=true -e PASSWORD=<your password> dockerbilltang/tomcat
```
