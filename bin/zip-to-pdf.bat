@REM BatToExePortable

echo off

@REM # -----------------
@REM # 檢查有沒有參數

if not exist %1 (
  pause
  exit
)

@REM # -----------------
@REM # 確認環境

WHERE git
IF %ERRORLEVEL% NEQ 0 (
  ECHO git wasn't found 
  start "" https://git-scm.com/downloads

  pause
  exit
)

WHERE node
IF %ERRORLEVEL% NEQ 0 (
  ECHO node wasn't found 
  start "" https://nodejs.org/en/download/

  pause
  exit
)

WHERE docker-compose
IF %ERRORLEVEL% NEQ 0 (
  ECHO docker-compose wasn't found 
  start "" https://docs.docker.com/compose/install/

  pause
  exit
)

@REM # ---------------
@REM # 安裝或更新專案

set PROJECT_NAME=docker-ZIP-to-PDF

if not exist "%temp%\%PROJECT_NAME%" (
  c:
  cd %temp%
  git clone "https://github.com/pulipulichen/%PROJECT_NAME%.git"
  cd "%temp%\%PROJECT_NAME%"
) else (
  c:
  cd "%temp%\%PROJECT_NAME%"
  git reset --hard
  git pull --force
)

@REM # -----------------
@REM # 執行指令

for %%x in (%*) do (
  if not exist %%~x  (
    echo %%~x does not exist.
  ) else (
    node "%temp%\%PROJECT_NAME%\index.js" "%%~x"
  )
)