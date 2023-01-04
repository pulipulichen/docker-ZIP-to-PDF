#include <MsgBoxConstants.au3>
#include <FileConstants.au3>

Global $sPROJECT_NAME = "docker-ZIP-to-PDF"
Global $sFILE_EXT = "zip"

;~ MsgBox($MB_SYSTEMMODAL, "Title", "This message box will timeout after 10 seconds or select the OK button.", 10)

Local $sUseParams = true
Local $sFiles[]
If $CmdLine[0] = 0 Then
	$sUseParams = false
	Local $sMessage = "Select File"
	Local $sFileOpenDialog = FileOpenDialog($sMessage, @DesktopDir & "\", "ZIP (*." & $sFILE_EXT & ")", $FD_FILEMUSTEXIST + $FD_MULTISELECT)
	$sFiles = StringSplit($sFileOpenDialog, "|")
EndIf

;~ ---------------------

Local $result = 0

$result = ShellExecuteWait('WHERE', 'git')
If $result = 0 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install GIT.")
	ShellExecute("https://git-scm.com/downloads")
	Exit
EndIf

$result = ShellExecuteWait('WHERE', 'node')
If $result = 0 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install Node.js.")
	ShellExecute("https://nodejs.org/en/download/")
	Exit
EndIf

$result = ShellExecuteWait('WHERE', 'docker-compose')
If $result = 0 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install Docker Desktop.")
	ShellExecute("https://docs.docker.com/compose/install/")
	Exit
EndIf

$result = ShellExecuteWait('docker', 'version')
If $result = 0 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please start Docker Desktop.")
	Exit
EndIf

;~ ---------------------

Local $sProjectFolder = "%temp%\" & $sPROJECT_NAME
If FileExists($sProjectFolder) Then
	FileChangeDir("%temp%")
	ShellExecuteWait("git", "clone" "https://github.com/pulipulichen/" & $sPROJECT_NAME & ".git")
	FileChangeDir($sProjectFolder)
Else
	FileChangeDir($sProjectFolder)
	ShellExecuteWait("git", "reset" "--hard")
	ShellExecuteWait("git", "pull" "--force")
EndIf

;~ ---------------------

Local $sProjectFolderCache = $sProjectFolder & ".cache"
If No FileExists($sProjectFolderCache) Then
	DirCreate($sProjectFolderCache)
EndIf

$result = ShellExecuteWait("fc", $sProjectFolder & "\Dockerfile", $sProjectFolderCache & "\Dockerfile")
If $result = 0 then
	ShellExecuteWait("docker-compose", "build")
	FileCopy($sProjectFolder & "\Dockerfile", $sProjectFolderCache & "\Dockerfile", $FC_OVERWRITE)
EndIf

$result = ShellExecuteWait("fc", $sProjectFolder & "\package.json", $sProjectFolderCache & "\package.json")
If $result = 0 then
	ShellExecuteWait("docker-compose", "build")
EndIf

FileCopy($sProjectFolder & "\Dockerfile", $sProjectFolderCache & "\Dockerfile", $FC_OVERWRITE)
FileCopy($sProjectFolder & "\package.json", $sProjectFolderCache & "\package.json", $FC_OVERWRITE)

;~ ---------------------

If $sUseParams = true Then
	For $i = 1 To $CmdLine[0]
		If No FileExists($CmdLine[$i]) Then
			MsgBox($MB_SYSTEMMODAL, $sPROJECT_NAME, "File not found: " & $CmdLine[$i])
		Else
			ShellExecuteWait("node", $sProjectFolder & "\index.js", $CmdLine[$i])
		EndIf
	Next
Else
	For $i = 2 To $sFiles[0] Then
		ShellExecuteWait("node", $sProjectFolder & "\index.js", $sFiles[$i])
	Next
EndIf