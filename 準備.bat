@echo off
:: Force UTF-8 encoding for nice console fonts and characters
chcp 65001 > nul

title 開發者手冊門戶編譯與加密安全部署系統

echo =====================================================================
echo  [DevPortal Security Console]
echo  準備執行：技術手冊一鍵自動編譯、同步與 AES-256 加密保護...
echo =====================================================================
echo.
echo 提示：此腳本將自動執行以下操作：
echo  1. 自動呼叫各子專案 Python 編譯器，更新本地未加密文檔
echo  2. 同步並物理清除發布目錄下的 unencrypted *.md 檔案與編譯代碼 (對策 B)
echo  3. 注入防快取標籤與返回首頁懸浮按鈕
echo  4. 呼叫 npx staticrypt 進行軍規級 AES-256 全網頁加密
echo.
echo ---------------------------------------------------------------------

powershell -ExecutionPolicy Bypass -File "build.ps1"

echo.
echo =====================================================================
echo  執行完畢！請按任意鍵關閉此視窗...
echo =====================================================================
pause > nul
