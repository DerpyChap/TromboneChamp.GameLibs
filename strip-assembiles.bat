@echo off 

set toPublicize=Assembly-CSharp.dll Assembly-CSharp-firstpass.dll
set toIgnore=UnityEngine.PhysicsModule.dll

set exePath=%1
echo exePath: %exePath% 

@REM Remove quotes
set exePath=%exePath:"=%

set managedPath=%exePath:.exe=_Data\Managed%
echo managedPath: %managedPath%

set outPath=%~dp0\package\lib

@REM Strip all assemblies, but keep them private.
%~dp0\tools\NStrip.exe "%managedPath%" -o %outPath%

@REM Strip and publicize assemblies from toPublicize.
(for %%a in (%toPublicize%) do (
  echo a: %%a

  %~dp0\tools\NStrip.exe "%managedPath%\%%a" -o "%outPath%\%%a" -cg -p --cg-exclude-events
))

@REM Copy ignored assemblies, leaving them unstripped
(for %%b in (%toIgnore%) do (
  echo overwriting: %%b

  copy "%managedPath%\%%b" "%outPath%\%%b"
))

pause
