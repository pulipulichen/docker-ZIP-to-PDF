
echo off

set PROJECT_NAME=docker-ZIP-to-PDF


set USE_PARAMS="true"
set USER_SELECT=""

if "%~1"=="" (
  set USE_PARAMS="false"
)

WHERE git
IF %ERRORLEVEL% NEQ 0 (
  ECHO git wasn't found 
  start "" https://git-scm.com/downloads

  ECHO "Please install git and REBOOT to activate it."
  pause
  exit
)

WHERE node
IF %ERRORLEVEL% NEQ 0 (
  ECHO node wasn't found 
  start "" https://nodejs.org/en/download/

  ECHO "Please install node and REBOOT to activate it."
  pause
  exit
)

WHERE docker-compose
IF %ERRORLEVEL% NEQ 0 (
  ECHO docker-compose wasn't found 
  start "" https://docs.docker.com/compose/install/

  ECHO "Please install Docker Desktop and REBOOT twice to activate it."
  pause
  exit
)

docker version
IF %ERRORLEVEL% NEQ 0 (
  ECHO "Please start Docker Desktop."
  pause
  exit
)

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

md "%temp%\%PROJECT_NAME%.cache"
if not exist "%temp%\%PROJECT_NAME%.cache" mkdir "%temp%\%PROJECT_NAME%.cache"

fc "%temp%\%PROJECT_NAME%\Dockerfile" "%temp%\%PROJECT_NAME%.cache\Dockerfile" > nul
if errorlevel 1 (
  docker-compose build
  xcopy "%temp%\%PROJECT_NAME%\package.json" "%temp%\%PROJECT_NAME%.cache\" /Y
)

fc "%temp%\%PROJECT_NAME%\package.json" "%temp%\%PROJECT_NAME%.cache\package.json" > nul
if errorlevel 1 (
  docker-compose build
)

xcopy "%temp%\%PROJECT_NAME%\Dockerfile" "%temp%\%PROJECT_NAME%.cache\" /Y
xcopy "%temp%\%PROJECT_NAME%\package.json" "%temp%\%PROJECT_NAME%.cache\" /Y

for %%x in (%*) do (
  if not exist "%%~x"  (
    echo %%~x does not exist.
  ) else (
    node "%temp%\%PROJECT_NAME%\index.js" "%%~x"
  )
)