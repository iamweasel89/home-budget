# setup.ps1 - Установка проекта "Домашняя бухгалтерия" с нуля
# Запускайте из любой папки. Скрипт сам найдёт проект или создаст его.

param(
    [string]$InstallPath = "$HOME\Documents\GitHub\home-budget"
)

Write-Host "=== УСТАНОВКА 'ДОМАШНЯЯ БУХГАЛТЕРИЯ' ===" -ForegroundColor Cyan
Write-Host "Время: $(Get-Date)`n" -ForegroundColor Gray

# 1. Проверка Git
Write-Host "[1] Проверка Git..." -ForegroundColor Yellow
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "   ❌ Git не установлен." -ForegroundColor Red
    Write-Host "   Скачайте с https://git-scm.com/ и перезапустите." -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Git: $(git --version)" -ForegroundColor Green

# 2. Проверка Node.js
Write-Host "`n[2] Проверка Node.js..." -ForegroundColor Yellow
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "   ❌ Node.js не установлен." -ForegroundColor Red
    Write-Host "   Скачайте LTS с https://nodejs.org/ и перезапустите." -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Node.js: $(node --version)" -ForegroundColor Green

# 3. Проверка Clasp
Write-Host "`n[3] Проверка Clasp..." -ForegroundColor Yellow
if (-not (Get-Command clasp -ErrorAction SilentlyContinue)) {
    Write-Host "   ⚠️  Устанавливаю Clasp..." -ForegroundColor Yellow
    npm install -g @google/clasp 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Не удалось установить Clasp." -ForegroundColor Red
        exit 1
    }
}
Write-Host "   ✅ Clasp: $(clasp --version)" -ForegroundColor Green

# 4. Клонирование или обновление проекта
Write-Host "`n[4] Проект..." -ForegroundColor Yellow
if (Test-Path $InstallPath) {
    Write-Host "   📂 Папка уже существует. Обновляю..." -ForegroundColor Gray
    Set-Location $InstallPath
    git pull origin main 2>$null
} else {
    Write-Host "   📦 Клонирую репозиторий..." -ForegroundColor Green
    git clone https://github.com/iamweasel89/home-budget.git $InstallPath 2>$null
    if (-not (Test-Path $InstallPath)) {
        Write-Host "   ❌ Не удалось клонировать." -ForegroundColor Red
        exit 1
    }
    Set-Location $InstallPath
}

# 5. Конфигурация
Write-Host "`n[5] Конфигурация..." -ForegroundColor Yellow
$configPath = "$InstallPath\templates\config.json"
if (-not (Test-Path $configPath)) {
    Write-Host "   ⚠️  Создаю шаблон конфига..." -ForegroundColor Yellow
    @{spreadsheet_id=""; google_account=""; script_id=""; created=(Get-Date -Format "yyyy-MM-dd")} |
        ConvertTo-Json | Set-Content $configPath -Encoding UTF8
}
$config = Get-Content $configPath | ConvertFrom-Json

# 6. Запрос ID таблицы (если пусто)
if ([string]::IsNullOrEmpty($config.spreadsheet_id)) {
    Write-Host "`n[6] Google Таблица" -ForegroundColor Cyan
    Write-Host "   1. Создать новую" -ForegroundColor Gray
    Write-Host "   2. Указать существующую" -ForegroundColor Gray
    $choice = Read-Host "   Выбор (1 или 2)"
    if ($choice -eq "1") {
        Start-Process "https://sheets.new"
        Write-Host "   Создайте таблицу и скопируйте её ID из адресной строки." -ForegroundColor Gray
        $config.spreadsheet_id = Read-Host "   Введите ID таблицы"
    } elseif ($choice -eq "2") {
        $config.spreadsheet_id = Read-Host "   Введите ID существующей таблицы"
    }
}

# 7. Авторизация Clasp (выбор аккаунта в браузере)
Write-Host "`n[7] Авторизация Google..." -ForegroundColor Cyan
Write-Host "   Откроется браузер — выберите аккаунт для работы с таблицей." -ForegroundColor Yellow
Read-Host "   Нажмите Enter для продолжения"
clasp login --no-localhost
# Получаем email авторизованного аккаунта
$claspWhoami = clasp whoami 2>&1
if ($claspWhoami -match "Logged in as (.+)") {
    $config.google_account = $matches[1]
    Write-Host "   ✅ Аккаунт: $($config.google_account)" -ForegroundColor Green
} else {
    Write-Host "   ❌ Не удалось определить аккаунт." -ForegroundColor Red
    exit 1
}

# 8. Сохранение конфига
$config | ConvertTo-Json | Set-Content $configPath -Encoding UTF8
Write-Host "   ✅ Конфиг сохранён." -ForegroundColor Green

# 9. Итог
Write-Host "`n=== УСТАНОВКА ЗАВЕРШЕНА ===" -ForegroundColor Cyan
Write-Host "Проект: $InstallPath" -ForegroundColor White
Write-Host "Аккаунт: $($config.google_account)" -ForegroundColor White
Write-Host "Таблица: $($config.spreadsheet_id)" -ForegroundColor White
Write-Host "`nДеплой:" -ForegroundColor Yellow
Write-Host "   .\launchpad\deploy.ps1 -Mode New" -ForegroundColor Green
Write-Host "   (запустите из папки проекта)" -ForegroundColor Gray
