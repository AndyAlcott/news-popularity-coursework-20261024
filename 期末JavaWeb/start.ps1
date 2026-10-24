$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (Test-Path '.\local.ps1') { . '.\local.ps1' }
if (-not $env:DB_PASSWORD) { throw '请先在 local.ps1 中设置本地 DB_PASSWORD，参照 README.md。' }
if (-not $env:NEWS_PYTHON) {
    $env:NEWS_PYTHON = (conda run -n news_popularity python -c "import sys; print(sys.executable)" | Where-Object { $_ -like '*.exe' } | Select-Object -Last 1).Trim()
}
if (-not $env:NEWS_ANALYSIS) { $env:NEWS_ANALYSIS = Join-Path $PSScriptRoot 'python' }
if (-not (Test-Path (Join-Path $env:NEWS_ANALYSIS 'models\random_forest.joblib'))) { throw '未找到模型，请先运行期中 train.py 或使用附带的 python 目录。' }
docker compose up -d
if ($LASTEXITCODE -ne 0) { throw 'Redis 启动失败' }
if (-not (Test-Path 'target\news-popularity-1.0.0.jar')) {
    mvn package -DskipTests
    if ($LASTEXITCODE -ne 0) { throw 'Maven 构建失败' }
}
# 为当前 Java 进程使用已验证的项目临时目录，避免本机默认目录的 NIO 兼容问题。
$runtimeTemp = Join-Path $PSScriptRoot '.runtime-temp'
New-Item -ItemType Directory -Force $runtimeTemp | Out-Null
java "-Djdk.net.unixdomain.tmpdir=$runtimeTemp" -jar target\news-popularity-1.0.0.jar
