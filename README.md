# Docker 日志查看系统与飞书认证集成部署指南

本项目是一个 Docker 容器日志查看系统，集成飞书身份认证，通过 Nginx 代理和 Lua 脚本实现安全的身份验证和日志访问。

## 环境要求

- Docker 和 Docker Compose
- OpenResty (基于 Nginx 的 Lua 扩展)
- 飞书开放平台应用

## 部署步骤

### 1. 准备环境变量

创建 `.env` 文件，配置以下环境变量：

```
APP_ID=你的飞书应用ID
APP_SECRET=你的飞书应用Secret
DOMAIN=你的应用域名
JWT_SECRET=自定义JWT密钥
```

### 2. 创建 Docker Compose 配置

使用现有的 `docker-compose.yml` 文件：

```yaml
services:
  nginx:
    restart: always
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "9999:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
```

### 3. 准备 Lua 脚本

在 `lua` 目录下创建必要的飞书认证脚本，确保 `resty.feishu_auth` 模块可用。

### 4. 启动服务

```bash
docker-compose up -d
```

## 配置说明

### nginx.conf

nginx.conf 文件包含了代理配置和飞书身份认证的设置：

- 通过环境变量读取 APP_ID、APP_SECRET、DOMAIN 和 JWT_SECRET
- 配置飞书认证的回调 URI 和登出 URI
- 提供 Docker 容器日志查看接口

### 飞书应用配置

1. 在飞书开放平台创建应用
2. 配置重定向 URL 为 `https://你的域名/feishu_auth_callback`
3. 获取应用的 APP_ID 和 APP_SECRET 填入环境变量

## 访问应用

部署完成后，通过浏览器访问 `http://你的域名:9999` 即可通过飞书认证进入日志查看系统。

### 查看容器日志

认证成功后，可以通过以下方式查看特定容器的日志：

```
/?id=容器名称
```

例如：查看 nginx 容器的日志
```
/?id=tail-docker-logs-nginx-1
```

## 常见问题

1. **认证失败**：检查 APP_ID 和 APP_SECRET 是否正确
2. **回调错误**：确认 DOMAIN 环境变量设置正确
3. **无法访问日志**：检查 Docker socket 挂载和容器运行状态
4. **端口冲突**：确保 9999 端口未被其他服务占用

## 自定义配置

如需配置 IP 黑名单、URI 白名单或部门白名单，可以在 nginx.conf 中取消相应注释并进行设置。

## 功能特性

- 🔐 飞书身份认证集成
- 📋 实时 Docker 容器日志查看
- 🛡️ 安全的访问控制
- 🚀 轻量级部署方案