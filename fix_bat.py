import os

workspace_dir = r"E:\程式開發"
projects = [
    "baseball-scoreboard",
    "basketball",
    "KCG 控播",
    "livevote-pro",
    "newsflow",
    "srt-server",
    "wrestling-scoreboard",
    "問答小程式"
]

for proj in projects:
    bat_path = os.path.join(workspace_dir, proj, "打開開發者文件.bat")
    if not os.path.exists(bat_path):
        print(f"Not found: {bat_path}")
        continue
    
    with open(bat_path, "r", encoding="utf-8-sig") as f:
        content = f.read()
    
    # 1. 確保防護：先刪除舊的 docs\index.html
    # 2. 移除 pipe
    # 3. 如果失敗，從 index.html 復原
    
    old_encrypt_block = """rem 將原始 docs\index.html 複製到根目錄下為 index.html 作為編譯源
copy docs\index.html index.html > nul

rem 進行 Staticrypt 加密，輸出直接寫回 docs\index.html (這會完美覆蓋並加密！)"""

    new_encrypt_block = """rem 將原始 docs\index.html 複製到根目錄下為 index.html 作為編譯源
copy docs\index.html index.html > nul

rem [安全防護] 先刪除原有的 index.html，確保加密失敗時不會遺留未加密的檔案
if exist docs\index.html del docs\index.html > nul

rem 進行 Staticrypt 加密，輸出直接寫回 docs\index.html (不使用 pipe 以確保正確捕獲 Errorlevel)"""

    content = content.replace(old_encrypt_block, new_encrypt_block)
    
    # Remove pipe from call npx
    content = content.replace(' | findstr /V "npx"', '')
    
    old_error_block = """rem 刪除根目錄的臨時 raw 檔案
del index.html > nul

if %errorlevel% NEQ 0 (
    echo.
    echo ⚠️ 警告：AES-256 加密失敗（可能未安裝 Node.js/npx）。
    echo 系統將開啟未加密的本地手冊版本。
    echo.
    pause
    start docs\index.html
    exit
)"""

    new_error_block = """if %errorlevel% NEQ 0 (
    echo.
    echo ⚠️ 警告：AES-256 加密失敗（可能未安裝 Node.js/npx 或網路離線）。
    echo 系統將嘗試為您開啟未加密的本地手冊版本，但為了安全起見，不會將其同步到門戶。
    echo.
    pause
    rem 恢復未加密版本供本地檢視
    copy index.html docs\index.html > nul
    start docs\index.html
    del index.html > nul
    exit
)

rem 加密成功後，刪除根目錄的臨時 raw 檔案
del index.html > nul"""

    content = content.replace(old_error_block, new_error_block)
    
    with open(bat_path, "w", encoding="utf-8-sig") as f:
        f.write(content)
    
    print(f"Fixed {proj}")

# Now fix KCG即時翻譯 which is slightly different
kcg_path = os.path.join(workspace_dir, "KCG即時翻譯", "打開開發者文件.bat")
if os.path.exists(kcg_path):
    with open(kcg_path, "r", encoding="utf-8-sig") as f:
        kcg_content = f.read()
    
    kcg_content = kcg_content.replace(' | findstr /V "npx"', '')
    
    old_kcg_error = """if %errorlevel% NEQ 0 (
    echo.
    echo ⚠️ 警告：AES-256 加密失敗（防編譯可能未安裝 Node.js/npx）。
    echo 系統將開啟未加密的本地手冊版本。
    echo.
    pause
    start docs\index.html
    exit
)"""
    new_kcg_error = """if %errorlevel% NEQ 0 (
    echo.
    echo ⚠️ 警告：AES-256 加密失敗（防編譯可能未安裝 Node.js/npx 或網路離線）。
    echo 系統將開啟未加密的本地手冊版本。
    echo.
    pause
    start docs\index.html
    exit
)"""
    kcg_content = kcg_content.replace(old_kcg_error, new_kcg_error)
    
    with open(kcg_path, "w", encoding="utf-8-sig") as f:
        f.write(kcg_content)
    print("Fixed KCG即時翻譯")

