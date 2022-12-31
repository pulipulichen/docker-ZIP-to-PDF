
echo off

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


for %%x in (%*) do (
  if not exist "%%~x"  (
    echo %%~x does not exist.
  ) else (
    node "%temp%\%PROJECT_NAME%\index.js" "%%~x"
  )
)