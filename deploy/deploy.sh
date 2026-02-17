#!/bin/bash
###############################################
# Dujiao-Next 一键部署脚本
# 用法: chmod +x deploy.sh && ./deploy.sh
###############################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════╗"
echo "║       Dujiao-Next Docker 部署脚本        ║"
echo "║            v0.0.1-beta                   ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DEPLOY_DIR"

# ------ 步骤 1: 检查 Docker 环境 ------
echo -e "${YELLOW}[1/6] 检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 未安装 Docker！请先安装 Docker。${NC}"
    echo "   安装命令: curl -fsSL https://get.docker.com | bash"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ 未安装 Docker Compose！请升级 Docker 或安装 docker-compose-plugin。${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker 和 Docker Compose 已就绪${NC}"

# ------ 步骤 2: 检查配置文件 ------
echo -e "${YELLOW}[2/6] 检查配置文件...${NC}"
if [ ! -f "$DEPLOY_DIR/config.yml" ]; then
    echo -e "${RED}❌ 未找到 config.yml 配置文件！${NC}"
    echo "   请复制并修改配置文件:"
    echo "   cp config.yml.example config.yml"
    exit 1
fi

# 检查是否修改了默认密钥
if grep -q "CHANGE-ME" "$DEPLOY_DIR/config.yml"; then
    echo -e "${RED}⚠️  警告: 配置文件中仍包含默认密钥 (CHANGE-ME)！${NC}"
    echo -e "${RED}   请修改 config.yml 中的 jwt.secret 和 user_jwt.secret${NC}"
    read -p "是否继续部署？(y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        exit 1
    fi
fi
echo -e "${GREEN}✅ 配置文件已就绪${NC}"

# ------ 步骤 3: 检查必要文件 ------
echo -e "${YELLOW}[3/6] 检查项目文件...${NC}"

if [ ! -f "$DEPLOY_DIR/backend/dujiao-next" ]; then
    echo -e "${RED}❌ 未找到后端二进制文件 backend/dujiao-next${NC}"
    exit 1
fi

if [ ! -f "$DEPLOY_DIR/admin/package.json" ]; then
    echo -e "${RED}❌ 未找到管理后台源码 admin/package.json${NC}"
    exit 1
fi

if [ ! -f "$DEPLOY_DIR/user/package.json" ]; then
    echo -e "${RED}❌ 未找到用户前端源码 user/package.json${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 项目文件已就绪${NC}"

# ------ 步骤 4: 构建镜像 ------
echo -e "${YELLOW}[4/6] 构建 Docker 镜像 (首次可能需要几分钟)...${NC}"
docker compose build --no-cache
echo -e "${GREEN}✅ 镜像构建完成${NC}"

# ------ 步骤 5: 启动服务 ------
echo -e "${YELLOW}[5/6] 启动所有服务...${NC}"
docker compose up -d
echo -e "${GREEN}✅ 服务已启动${NC}"

# ------ 步骤 6: 检查服务状态 ------
echo -e "${YELLOW}[6/6] 等待服务就绪...${NC}"
sleep 8

echo ""
echo -e "${BLUE}========== 服务状态 ==========${NC}"
docker compose ps
echo ""

# 检查健康状态
API_OK=false
ADMIN_OK=false
USER_OK=false
BEPUSDT_OK=false

if docker exec dujiao-api wget -qO- http://localhost:9090/health > /dev/null 2>&1; then
    API_OK=true
    echo -e "${GREEN}✅ 后端 API    : 运行中 (仅内部访问，端口 9090)${NC}"
else
    echo -e "${RED}❌ 后端 API    : 启动失败，请检查日志${NC}"
fi

if curl -s -o /dev/null -w "%{http_code}" http://localhost:9091/health | grep -q "200"; then
    ADMIN_OK=true
    echo -e "${GREEN}✅ 管理后台    : http://localhost:9091${NC}"
else
    echo -e "${RED}❌ 管理后台    : 启动失败，请检查日志${NC}"
fi

if curl -s -o /dev/null -w "%{http_code}" http://localhost:9092/health | grep -q "200"; then
    USER_OK=true
    echo -e "${GREEN}✅ 用户前端    : http://localhost:9092${NC}"
else
    echo -e "${RED}❌ 用户前端    : 启动失败，请检查日志${NC}"
fi

# 检测已有的独立 BEpusdt 容器
BEPUSDT_CONTAINER=$(docker ps --format '{{.Names}}' | grep -i bepusdt | head -1)
if [ -n "$BEPUSDT_CONTAINER" ]; then
    BEPUSDT_PORT=$(docker port "$BEPUSDT_CONTAINER" 8080 2>/dev/null | head -1 | sed 's/.*://')
    if [ -n "$BEPUSDT_PORT" ]; then
        BEPUSDT_OK=true
        echo -e "${GREEN}✅ BEpusdt支付  : 已检测到独立运行的容器 ($BEPUSDT_CONTAINER), 端口 $BEPUSDT_PORT${NC}"
    else
        BEPUSDT_OK=true
        echo -e "${GREEN}✅ BEpusdt支付  : 已检测到独立运行的容器 ($BEPUSDT_CONTAINER)${NC}"
    fi
else
    echo -e "${YELLOW}ℹ️  BEpusdt支付  : 未检测到运行中的 BEpusdt 容器${NC}"
fi

echo ""
if $API_OK && $ADMIN_OK && $USER_OK; then
    echo -e "${GREEN}🎉 所有服务部署成功！${NC}"
else
    echo -e "${YELLOW}⚠️  部分服务可能仍在启动中，请稍后检查或查看日志:${NC}"
    echo "   docker compose logs -f"
fi

if $BEPUSDT_OK; then
    echo ""
    echo -e "${BLUE}💰 BEpusdt 虚拟货币支付网关:${NC}"
    echo -e "  检测到容器  : $BEPUSDT_CONTAINER"
    echo -e "  配置支付通道时网关地址填写: http://宿主机IP:${BEPUSDT_PORT:-端口}/"
    echo -e "  ${YELLOW}在 Dujiao-Next 管理后台 → 支付渠道 → 新增 → 类型选'易支付'→ 方式选'USDT'${NC}"
fi

echo ""
echo -e "${BLUE}常用命令:${NC}"
echo "  查看日志    : docker compose logs -f"
echo "  重启服务    : docker compose restart"
echo "  停止服务    : docker compose down"
echo "  查看状态    : docker compose ps"
echo ""
