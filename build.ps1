# =====================================================================
# DevPortal One-Click Sync & AES-256 Staticrypt Encryption Script
# =====================================================================
param(
    [Parameter(Mandatory=$false)]
    [string]$Password
)

$ErrorActionPreference = "Stop"

# UTF-8 Base64 Decoding Helper Function
function Get-UTF8String($base64) {
    $bytes = [System.Convert]::FromBase64String($base64)
    return [System.Text.Encoding]::UTF8.GetString($bytes)
}

# Base64 Translated Chinese Strings (Unicode-Safe)
$Str_HeaderLine       = "=================================================="
$Str_TitleBanner      = "DevPortal Security Deployment - AES-256 Lock"
$Str_Prompt           = Get-UTF8String "6KuL6Ly45YWl5oKo5biM5pyb6Kit5a6a55qEIEFFUy0yNTYg5Yqg5a+G5a+G56K8ICjovLjlhaXmmYLlrZflhYPmnIPpmrHol48p"
$Str_SyncingBanner    = "Syncing Project Documentation Directories..."
$Str_Found            = Get-UTF8String "55m854++5bCI5qGI5omL5YaKOiA="
$Str_SyncSuccess      = Get-UTF8String "ICAgLT4g5qqU5qGI5ZCM5q2l5oiQ5YqfIQ=="
$Str_Skip             = Get-UTF8String "6Lez6YGO5bCI5qGIOiA="
$Str_SkipReason       = Get-UTF8String "IChkb2NzIOebrumMhOS4ree8uuWwkSBpbmRleC5odG1sKQ=="
$Str_NoDocs           = Get-UTF8String "5pyq5Zyo5Lu75L2V6YSw6L+R5bCI5qGI5Lit55m854++IGRvY3NcaW5kZXguaHRtbOOAguWDheacg+WKoOWvhuWFpeWPo+mmlumggeOAgg=="
$Str_EncryptBanner    = "Compiling Cryptographic AES-256 Protection..."
$Str_Encrypting       = Get-UTF8String "4pqhIOato+WcqOWft+ihjCBBRVMtMjU2IOmdnOaFi+WKoOWvhuWuieWFqOe3qOitry4uLg=="
$Str_PortalTitle      = Get-UTF8String "6ZaL55m86ICF5oqA6KGT5omL5YaK5pW05ZCI6ZaA5oi2IHwgRGV2UG9ydGFs"
$Str_Instructions     = Get-UTF8String "5pys5oqA6KGT5omL5YaK6ZaA5oi25Y+XIEFFUy0yNTYg5Yqg5a+G5L+d6K2377yM6KuL6Ly45YWl5a2Y5Y+W5a+G56K844CC"
$Str_ErrorMsg         = Get-UTF8String "5a+G56K86Yyv6Kqk77yM6KuL6YeN5paw6Ly45YWl77yB"
$Str_Placeholder      = Get-UTF8String "6KuL6Ly45YWl5a2Y5Y+W5a+G56K8Li4u"
$Str_BtnLabel         = Get-UTF8String "6amX6K2J5Lim6Kej5a+G"
$Str_Remember         = Get-UTF8String "6KiY5L2P5a+G56K8"
$Str_EncryptPortal    = Get-UTF8String "5q2j5Zyo5Yqg5a+G5YWl5Y+j6aaW6aCBIChpbmRleC5odG1sKS4uLg=="
$Str_PortalSuccess    = Get-UTF8String "ICAg4pyUIOWFpeWPo+mmlumggeWKoOWvhuWujOaIkCE="
$Str_PortalFail       = Get-UTF8String "5YWl5Y+j6aaW6aCB5Yqg5a+G5aSx5pWX77yB"
$Str_EncryptSub       = Get-UTF8String "5q2j5Zyo5Yqg5a+G5a2Q5bCI5qGI5omL5YaK57ay6aCBLi4u"
$Str_EncryptingSub    = Get-UTF8String "5Yqg5a+G5LitOiA="
$Str_SubTitleSuffix   = Get-UTF8String "IOaKgOihk+aJi+WGiiB8IOWuieWFqOmpl+itiQ=="
$Str_SubPrefix        = Get-UTF8String "5pys5bCI5qGIICg="
$Str_SubSuffix        = Get-UTF8String "KSDkuYvmiYvlhorlj5cgQUVTLTI1NiDliqDlr4bkv53orbfvvIzoq4vovLjlhaXlrZjlj5blr4bnorzjgII="
$Str_SubSuccessPrefix = Get-UTF8String "ICAg4pyUIOWwiOahiCAo"
$Str_SubSuccessSuffix = Get-UTF8String "KSDmiYvlhorliqDlr4blrozmiJAh"
$Str_Congrats1        = Get-UTF8String "8J+OiSDmga3llpzvvIFEZXZQb3J0YWwg5ZCM5q2l6IiH5aSa5bGk57Sa5Yqg5a+G5L2c5qWt5oiQ5Yqf5a6M5oiQ77yB"
$Str_Congrats2        = Get-UTF8String "5oKo54++5Zyo5Y+v5Lul5a6J5YWo5Zyw5bCH5pW05YCLIGRvY3MtcG9ydGFsIOWwiOahiOaOqOmAgeiHsyBHaXRIdWIgUGFnZXMg55m85L2I44CC"

# Staticrypt Theme Configurations
$PrimaryColor = "#818cf8"
$SecondaryColor = "#0b0f19"

# 1. Dynamic Password Prompt (only if not passed via parameter)
if ([string]::IsNullOrWhiteSpace($Password)) {
    Write-Host "`n$Str_HeaderLine" -ForegroundColor Cyan
    Write-Host $Str_TitleBanner -ForegroundColor Cyan
    Write-Host $Str_HeaderLine -ForegroundColor Cyan
    $Password = Read-Host $Str_Prompt -MaskInput
}

if ([string]::IsNullOrWhiteSpace($Password)) {
    Write-Error "Password cannot be empty! Canceled build."
    Exit
}

# 2. Define directory structure
$ParentDir = Split-Path -Parent $PSScriptRoot
$PortalDir = Join-Path $ParentDir "docs-portal"
$DestProjectsDir = Join-Path $PortalDir "projects"

# Ensure projects directory exists
if (!(Test-Path $DestProjectsDir)) {
    New-Item -ItemType Directory -Path $DestProjectsDir | Out-Null
}

# 3. Scan & Sync docs
Write-Host "`n$Str_HeaderLine" -ForegroundColor Cyan
Write-Host $Str_SyncingBanner -ForegroundColor Cyan
Write-Host $Str_HeaderLine -ForegroundColor Cyan

$Projects = Get-ChildItem -Path $ParentDir -Directory | Where-Object { 
    $_.Name -ne "docs-portal" -and (Test-Path (Join-Path $_.FullName "docs"))
}

$KcgTranslatorName = Get-UTF8String "S0NH5Y2z5pmC57+76K2v" # KCG即時翻譯
$KcgSubtitlesName  = Get-UTF8String "S0NH5Y2z5pmC5a2X5bmV" # KCG即時字幕

$SyncedProjectsCount = 0

foreach ($Proj in $Projects) {
    $ProjDocsPath = Join-Path $Proj.FullName "docs"
    
    # 專案名稱對應邏輯：如果專案資料夾是 "KCG即時翻譯"，發布時使用 "KCG即時字幕"
    $TargetProjName = $Proj.Name
    if ($Proj.Name -eq $KcgTranslatorName) {
        $TargetProjName = $KcgSubtitlesName
    }
    
    $TargetDir = Join-Path $DestProjectsDir $TargetProjName
    
    # 3.5 自動偵測並執行子專案的 Python 文檔編譯器 (對策 B 極致自動化)
    $CompileScript = Join-Path $ProjDocsPath "compile_docs.py"
    if (Test-Path $CompileScript) {
        Write-Host "   -> [Auto-Compile] Running python docs compiler..." -ForegroundColor Gray
        try {
            # 暫時設定環境變數以防 Windows 預設 CP950 終端機在列印 Emoji (如 🏀, 📺, 📡) 時產生 UnicodeEncodeError 崩潰
            $OldEnvEncoding = $env:PYTHONIOENCODING
            $env:PYTHONIOENCODING = "utf-8"
            
            # 呼叫 python 同步編譯，在專案目錄下進行編譯
            Start-Process python -ArgumentList "compile_docs.py" -WorkingDirectory $ProjDocsPath -NoNewWindow -Wait
            
            $env:PYTHONIOENCODING = $OldEnvEncoding
        } catch {
            Write-Warning "      [Warning] Could not execute Python compiler. Ensure 'python' is in PATH. Error: $_"
        }
    }
    
    if (Test-Path (Join-Path $ProjDocsPath "index.html")) {
        Write-Host "$Str_Found$TargetProjName" -ForegroundColor Green
        
        if (Test-Path $TargetDir) {
            Remove-Item -Recurse -Force $TargetDir | Out-Null
        }
        New-Item -ItemType Directory -Path $TargetDir | Out-Null
        
        Copy-Item -Path "$ProjDocsPath\*" -Destination $TargetDir -Recurse -Force | Out-Null
        
        # 排除並刪除未加密的原始 Markdown 與編譯 Python 檔案，落實對策B以確保安全性
        Get-ChildItem -Path $TargetDir -File -Recurse | Where-Object { $_.Extension.ToLower() -in @('.md', '.py') } | Remove-Item -Force | Out-Null
        
        # 動態插入「返回門戶」按鈕 (於未加密 HTML 狀態下注入)
        $TargetIndexHtml = Join-Path $TargetDir "index.html"
        if (Test-Path $TargetIndexHtml) {
            $HtmlContent = [System.IO.File]::ReadAllText($TargetIndexHtml, [System.Text.Encoding]::UTF8)
            $BackButton = Get-UTF8String "PGRpdiBpZD0iZGV2cG9ydGFsLWJhY2stdG8taG9tZSIgc3R5bGU9InBvc2l0aW9uOiBmaXhlZDsgYm90dG9tOiAyMHB4OyByaWdodDogMjBweDsgei1pbmRleDogOTk5OTk7IGZvbnQtZmFtaWx5OiAtYXBwbGUtc3lzdGVtLCBCbGlua01hY1N5c3RlbUZvbnQsICdTZWdvZSBVSScsIFJvYm90bywgc2Fucy1zZXJpZjsiPgogICAgPGEgaHJlZj0iLi4vLi4vaW5kZXguaHRtbCIgc3R5bGU9ImRpc3BsYXk6IGZsZXg7IGFsaWduLWl0ZW1zOiBjZW50ZXI7IGp1c3RpZnktY29udGVudDogY2VudGVyOyBnYXA6IDhweDsgcGFkZGluZzogMTBweCAxNnB4OyBiYWNrZ3JvdW5kOiByZ2JhKDE1LCAyMywgNDIsIDAuNzUpOyBib3JkZXI6IDFweCBzb2xpZCByZ2JhKDI1NSwgMjU1LCAyNTUsIDAuMTIpOyBib3JkZXItcmFkaXVzOiAxMnB4OyBjb2xvcjogI2YxZjVmOTsgdGV4dC1kZWNvcmF0aW9uOiBub25lOyBmb250LXNpemU6IDEzcHg7IGZvbnQtd2VpZ2h0OiA2MDA7IGJhY2tkcm9wLWZpbHRlcjogYmx1cigxMnB4KTsgLXdlYmtpdC1iYWNrZHJvcC1maWx0ZXI6IGJsdXIoMTJweCk7IGJveC1zaGFkb3c6IDAgOHB4IDMycHggcmdiYSgwLCAwLCAwLCAwLjI0KTsgdHJhbnNpdGlvbjogYWxsIDAuM3MgY3ViaWMtYmV6aWVyKDAuMTYsIDEsIDAuMywgMSk7Ij4KICAgICAgICA8c3ZnIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjE2IiBoZWlnaHQ9IjE2IiBmaWxsPSJub25lIiBzdHJva2U9ImN1cnJlbnRDb2xvciIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiIHN0eWxlPSJkaXNwbGF5OiBibG9jazsgbWFyZ2luOiAwOyI+PHBhdGggZD0iTTMgOWw5LTcgOSA3djExYTIgMiAwIDAgMS0yIDJINWEyIDIgMCAwIDEtMi0yeiI+PC9wYXRoPjxwb2x5bGluZSBwb2ludHM9IjkgMjIgOSAxMiAxNSAxMiAxNSAyMiI+PC9wb2x5bGluZT48L3N2Zz4KICAgICAgICA8c3Bhbj7ov5Tlm57ploDmiLY8L3NwYW4+CiAgICA8L2E+CjwvZGl2Pgo8c3R5bGU+CiAgICAjZGV2cG9ydGFsLWJhY2stdG8taG9tZSBhOmhvdmVyIHsKICAgICAgICBiYWNrZ3JvdW5kOiByZ2JhKDk5LCAxMDIsIDI0MSwgMC45KSAhaW1wb3J0YW50OwogICAgICAgIGJvcmRlci1jb2xvcjogcmdiYSgxMjksIDE0MCwgMjQ4LCAwLjQpICFpbXBvcnRhbnQ7CiAgICAgICAgdHJhbnNmb3JtOiB0cmFuc2xhdGVZKC0ycHgpOwogICAgICAgIGJveC1zaGFkb3c6IDAgMTJweCAzMHB4IHJnYmEoOTksIDEwMiwgMjQxLCAwLjM2KSAhaW1wb3J0YW50OwogICAgICAgIGNvbG9yOiAjZmZmZmZmICFpbXBvcnRhbnQ7CiAgICB9CiAgICAjZGV2cG9ydGFsLWJhY2stdG8taG9tZSBhOmFjdGl2ZSB7CiAgICAgICAgdHJhbnNmb3JtOiB0cmFuc2xhdGVZKDApOwogICAgfQo8L3N0eWxlPg=="
            
            # A. 注入防快取 Meta 標籤 (確保每次讀取都是最新版本且不留本機暫存)
            if ($HtmlContent -match "(?i)<head[^>]*>") {
                $HeadTag = $Matches[0]
                # 為安全起見，直接使用 $HeadTag 尋找 head 位置並在其後方插入
                $InsertHeadIndex = $HtmlContent.IndexOf($HeadTag) + $HeadTag.Length
                $NoCacheMeta = "`n    <meta http-equiv=""Cache-Control"" content=""no-cache, no-store, must-revalidate"">`n    <meta http-equiv=""Pragma"" content=""no-cache"">`n    <meta http-equiv=""Expires"" content=""0"">"
                $HtmlContent = $HtmlContent.Insert($InsertHeadIndex, $NoCacheMeta)
            }
            
            # B. 注入返回門戶懸浮按鈕
            if ($HtmlContent -match "(?i)<body[^>]*>") {
                $BodyTag = $Matches[0]
                $InsertIndex = $HtmlContent.IndexOf($BodyTag) + $BodyTag.Length
                $HtmlContent = $HtmlContent.Insert($InsertIndex, "`n$BackButton")
            }
            
            [System.IO.File]::WriteAllText($TargetIndexHtml, $HtmlContent, [System.Text.Encoding]::UTF8)
        }
        
        Write-Host $Str_SyncSuccess -ForegroundColor DarkGreen
        $SyncedProjectsCount++
    } else {
        Write-Host "$Str_Skip$TargetProjName$Str_SkipReason" -ForegroundColor Yellow
    }
}

if ($SyncedProjectsCount -eq 0) {
    Write-Warning $Str_NoDocs
}

# 4. Compile with AES-256 (StatiCrypt)
Write-Host "`n$Str_HeaderLine" -ForegroundColor Cyan
Write-Host $Str_EncryptBanner -ForegroundColor Cyan
Write-Host $Str_HeaderLine -ForegroundColor Cyan

# A. Encrypt Portal Landing Page
Write-Host $Str_EncryptPortal -ForegroundColor White
npx -y staticrypt src/index.html `
  -d . `
  -p "$Password" `
  -c false `
  --short `
  --template-title "$Str_PortalTitle" `
  --template-color-primary "$PrimaryColor" `
  --template-color-secondary "$SecondaryColor" `
  --template-instructions "$Str_Instructions" `
  --template-error "$Str_ErrorMsg" `
  --template-placeholder "$Str_Placeholder" `
  --template-button "$Str_BtnLabel" `
  --template-remember "$Str_Remember" | Out-Null

if (Test-Path "index.html") {
    Write-Host $Str_PortalSuccess -ForegroundColor Green
} else {
    Write-Error $Str_PortalFail
}

# B. Encrypt Subprojects
if ($SyncedProjectsCount -gt 0) {
    Write-Host "`n$Str_EncryptSub" -ForegroundColor White
    $CopiedIndices = Get-ChildItem -Path $DestProjectsDir -Filter "index.html" -Recurse -Depth 2
    
    # Create temp directory for safe encryption
    $TempEncryptDir = Join-Path $PortalDir "temp_encrypt"
    if (Test-Path $TempEncryptDir) {
        Remove-Item -Recurse -Force $TempEncryptDir | Out-Null
    }
    New-Item -ItemType Directory -Path $TempEncryptDir | Out-Null
    
    foreach ($IndexFile in $CopiedIndices) {
        $ProjDir = Split-Path $IndexFile.FullName -Parent
        $ProjName = Split-Path $ProjDir -Leaf
        Write-Host "$Str_EncryptingSub$ProjName/index.html" -ForegroundColor White
        
        $SubTitle = "$ProjName$Str_SubTitleSuffix"
        $SubInstructions = "$Str_SubPrefix$ProjName$Str_SubSuffix"
        
        # Copy raw file to temp directory
        $TempRawFile = Join-Path $TempEncryptDir "index.html"
        Copy-Item -Path $IndexFile.FullName -Destination $TempRawFile -Force | Out-Null
        
        # Encrypt from temp and write back to project directory
        npx -y staticrypt "$TempRawFile" `
          -d "$ProjDir" `
          -p "$Password" `
          -c false `
          --short `
          --template-title "$SubTitle" `
          --template-color-primary "$PrimaryColor" `
          --template-color-secondary "$SecondaryColor" `
          --template-instructions "$SubInstructions" `
          --template-error "$Str_ErrorMsg" `
          --template-placeholder "$Str_Placeholder" `
          --template-button "$Str_BtnLabel" `
          --template-remember "$Str_Remember" | Out-Null
          
        Write-Host "$Str_SubSuccessPrefix$ProjName$Str_SubSuccessSuffix" -ForegroundColor Green
    }
    
    # Clean up temp directory
    Remove-Item -Recurse -Force $TempEncryptDir | Out-Null
}

Write-Host "`n$Str_HeaderLine" -ForegroundColor Green
Write-Host $Str_Congrats1 -ForegroundColor Green
Write-Host $Str_Congrats2 -ForegroundColor Green
Write-Host "$Str_HeaderLine`n" -ForegroundColor Green
