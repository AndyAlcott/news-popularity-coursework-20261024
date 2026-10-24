Set-Location $PSScriptRoot
# Java 在启动窗口按 Ctrl+C 停止；这里只停止本项目 Redis，保留数据卷。
docker compose stop
