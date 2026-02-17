# syntax=docker/dockerfile:1

# =============================================
# Dujiao-Next 后端 API Dockerfile
# 使用预编译的 Linux amd64 二进制文件
# =============================================

FROM alpine:3.21

# 安装运行时必要的依赖 + 健康检查工具
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    wget \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

# 创建必要的目录
RUN mkdir -p /app/db /app/uploads /app/logs

# 复制预编译的二进制文件
COPY dujiao-next /app/dujiao-next

# 确保二进制文件有执行权限
RUN chmod +x /app/dujiao-next

EXPOSE 9090

CMD ["/app/dujiao-next"]
