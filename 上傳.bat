@echo off
chcp 65001 > nul

title 門戶系統一鍵自動 Git 部署發布工具

echo =====================================================================
echo  [DevPortal Git Deployer]
echo  準備開始：將已編譯加密之手冊門戶推送至 GitHub Pages...
echo =====================================================================
echo.

:: Git 自動化上傳
echo  開始自動推送到 GitHub 倉庫...
echo ---------------------------------------------------------------------

:: 檢查是否為 Git 倉庫
if not exist ".git" (
    echo ?? [提示] 檢測到此目錄尚未初始化 Git 倉庫。
    echo 正在嘗試自動初始化本地 Git...
    git init
)

echo 正在將檔案加入 Git 暫存區...
git add .

echo 正在建立安全部署提交 (Commit)...
git commit -m "Deploy encrypted developer manuals via DevPortal"

echo 正在強制覆蓋推送至遠端 GitHub 伺服器...
:: 獲取當前分支名稱
for /f "tokens=*" %%i in ('git branch --show-current') do set BRANCH=%%i
if "%BRANCH%"=="" set BRANCH=main

git push origin %BRANCH% --force

if %errorlevel% neq 0 (
    echo.
    echo ? [錯誤] 推送至 GitHub 失敗！
    echo 請確認：
    echo  1. 您是否已關聯遠端倉庫 (git remote add origin ...)。
    echo  2. 網路連線與 SSH/HTTPS 授權是否正常。
    echo  3. 您對該倉庫是否有推送權限。
) else (
    echo.
    echo ?? [成功] 技術手冊已成功強制覆蓋推送至 GitHub！
)

:end
echo.
echo =====================================================================
echo  發布流程執行完畢！請按任意鍵關閉此視窗...
echo =====================================================================
pause