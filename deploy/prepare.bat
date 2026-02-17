@echo off
chcp 65001 >nul
echo.
echo ╔══════════════════════════════════════════╗
echo ║   Dujiao-Next 部署文件准备脚本 (Windows) ║
echo ╚══════════════════════════════════════════╝
echo.

REM 获取脚本所在目录（即 deploy 目录）
set DEPLOY_DIR=%~dp0
REM 项目根目录的上级
set ROOT_DIR=%DEPLOY_DIR%..\..\

echo [1/3] 复制后端二进制文件...
if not exist "%DEPLOY_DIR%backend" mkdir "%DEPLOY_DIR%backend"
copy /Y "%DEPLOY_DIR%..\dujiao-next" "%DEPLOY_DIR%backend\dujiao-next" >nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ 后端二进制文件已复制
) else (
    echo   ❌ 复制失败，请检查文件路径
)

echo.
echo [2/3] 复制管理后台源码...
set ADMIN_SRC=%ROOT_DIR%admin-0.0.1-beta\admin-0.0.1-beta
if exist "%ADMIN_SRC%\package.json" (
    copy /Y "%ADMIN_SRC%\package.json" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\package-lock.json" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\index.html" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\vite.config.ts" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\tsconfig.json" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\tsconfig.app.json" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\tsconfig.node.json" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\postcss.config.js" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\tailwind.config.js" "%DEPLOY_DIR%admin\" >nul
    copy /Y "%ADMIN_SRC%\components.json" "%DEPLOY_DIR%admin\" >nul
    xcopy /E /I /Y /Q "%ADMIN_SRC%\src" "%DEPLOY_DIR%admin\src" >nul
    xcopy /E /I /Y /Q "%ADMIN_SRC%\public" "%DEPLOY_DIR%admin\public" >nul
    echo   ✅ 管理后台源码已复制
) else (
    echo   ❌ 未找到管理后台源码目录: %ADMIN_SRC%
)

echo.
echo [3/3] 复制用户前端源码...
set USER_SRC=%ROOT_DIR%user-main\user-main
if exist "%USER_SRC%\package.json" (
    copy /Y "%USER_SRC%\package.json" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\package-lock.json" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\index.html" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\vite.config.ts" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\tsconfig.json" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\tsconfig.app.json" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\tsconfig.node.json" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\postcss.config.js" "%DEPLOY_DIR%user\" >nul
    copy /Y "%USER_SRC%\tailwind.config.js" "%DEPLOY_DIR%user\" >nul
    xcopy /E /I /Y /Q "%USER_SRC%\src" "%DEPLOY_DIR%user\src" >nul
    xcopy /E /I /Y /Q "%USER_SRC%\public" "%DEPLOY_DIR%user\public" >nul
    echo   ✅ 用户前端源码已复制
) else (
    echo   ❌ 未找到用户前端源码目录: %USER_SRC%
)

echo.
echo ══════════════════════════════════════════
echo  准备完成！deploy 目录已包含所有部署文件
echo.
echo  接下来请:
echo  1. 修改 deploy\config.yml 中的 JWT 密钥
echo  2. 将整个 deploy 文件夹上传到服务器
echo  3. 在服务器上执行 ./deploy.sh
echo ══════════════════════════════════════════
echo.
pause
