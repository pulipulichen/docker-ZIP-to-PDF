#include <MsgBoxConstants.au3>
#include <FileConstants.au3>

Global $sPROJECT_NAME = "docker-ZIP-to-PDF"
Global $sFILE_EXT = "ZIP (*.zip)"

;~ MsgBox($MB_SYSTEMMODAL, "Title", "This message box will timeout after 10 seconds or select the OK button.", 10)
Local $sWorkingDir = @WorkingDir

;~ ---------------------

Local $result = 0

$result = ShellExecuteWait('WHERE', 'git', "", "open", @SW_HIDE)
If $result = 1 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install GIT.")
	ShellExecute("https://git-scm.com/downloads", "", "open", @SW_HIDE)
	Exit
EndIf

$result = ShellExecuteWait('WHERE', 'node', "", "open", @SW_HIDE)
If $result = 1 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install Node.js.")
	ShellExecute("https://nodejs.org/en/download/", "", "open", @SW_HIDE)
	Exit
EndIf

$result = ShellExecuteWait('WHERE', 'docker-compose', "", "open", @SW_HIDE)
If $result = 1 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please install Docker Desktop.")
	ShellExecute("https://docs.docker.com/compose/install/", "", "open", @SW_HIDE)
	Exit
EndIf

$result = ShellExecuteWait('docker', 'version', "", "open", @SW_HIDE)
If $result = 1 then
	MsgBox($MB_SYSTEMMODAL, "Environment Setting", "Please start Docker Desktop.")
	Exit
EndIf

;~ ---------------------
;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "1")
; Local $sProjectFolder = @TempDir & "\" & $sPROJECT_NAME
Local $sProjectFolder = @HomeDrive & @HomePath & "\docker-app\" & $sPROJECT_NAME
;~ MsgBox($MB_SYSTEMMODAL, FileExists($sProjectFolder), $sProjectFolder)
If Not FileExists($sProjectFolder) Then
	FileChangeDir(@HomeDrive & @HomePath & "\docker-app\")
	ShellExecuteWait("git", "clone https://github.com/pulipulichen/" & $sPROJECT_NAME & ".git")
	FileChangeDir($sProjectFolder)
Else
	FileChangeDir($sProjectFolder)
	ShellExecuteWait("git", "reset --hard", "", "open", @SW_HIDE)
	ShellExecuteWait("git", "pull --force", "", "open", @SW_HIDE)
EndIf

;~ ---------------------
;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "2")
Local $sProjectFolderCache = $sProjectFolder & ".cache"
If Not FileExists($sProjectFolderCache) Then
	DirCreate($sProjectFolderCache)
EndIf

$result = ShellExecuteWait("fc", '"' & $sProjectFolder & "\Dockerfile" & '" "' & $sProjectFolderCache & "\Dockerfile" & '"', "", "open", @SW_HIDE)
If $result = 1 then
	ShellExecuteWait("docker-compose", "build")
	FileCopy($sProjectFolder & "\Dockerfile", $sProjectFolderCache & "\Dockerfile", $FC_OVERWRITE)
EndIf

$result = ShellExecuteWait("fc", '"' & $sProjectFolder & "\package.json" & '" "' & $sProjectFolderCache & "\package.json" & '"', "", "open", @SW_HIDE)
If $result = 1 then
	ShellExecuteWait("docker-compose", "build")
EndIf

FileCopy($sProjectFolder & "\Dockerfile", $sProjectFolderCache & "\Dockerfile", $FC_OVERWRITE)
FileCopy($sProjectFolder & "\package.json", $sProjectFolderCache & "\package.json", $FC_OVERWRITE)

;~ ---------------------
;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "3")

Local $sUseParams = true
Local $sFiles[]
If $CmdLine[0] = 0 Then
	$sUseParams = false
	;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "4.0")
	Local $sMessage = "Select File"
	Local $sFileOpenDialog = FileOpenDialog($sMessage, @DesktopDir & "\", $sFILE_EXT , $FD_FILEMUSTEXIST + $FD_MULTISELECT)
	$sFiles = StringSplit($sFileOpenDialog, "|")
EndIf
 
If $sUseParams = true Then
	For $i = 1 To $CmdLine[0]
		If Not FileExists($CmdLine[$i]) Then
			If Not FileExists($sWorkingDir & "/" & $CmdLine[$i]) Then
				MsgBox($MB_SYSTEMMODAL, $sPROJECT_NAME, "File not found: " & $CmdLine[$i])
			Else
				;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "4.1")
				ShellExecuteWait("node", $sProjectFolder & "\index.js" & ' "' & $sWorkingDir & "/" & $CmdLine[$i] & '"')	
			EndIf
		Else
			;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "4.2")
			ShellExecuteWait("node", $sProjectFolder & "\index.js" & ' "' & $CmdLine[$i] & '"')
		EndIf
	Next
Else
	;MsgBox($MB_SYSTEMMODAL, "Environment Setting", "4.3")
	For $i = 1 To $sFiles[0]
		FileChangeDir($sProjectFolder)
		;MsgBox($MB_SYSTEMMODAL, "Environment Setting", $sProjectFolder & "\index.js" & ' "' & $sFiles[$i] & '"')
		ShellExecuteWait("node", $sProjectFolder & "\index.js" & ' "' & $sFiles[$i] & '"')
	Next
EndIf