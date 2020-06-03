:: Prerequisites (see INSTALLpc.txt on vim repo for more info)
:: For Visual Studio C++ 2017 x86 build

@echo off

echo ==========================================================================
echo ** Building VIM/GVIM
echo ** 32 bit
echo ==========================================================================

where /q git || ECHO Git must be installed. && EXIT /B

IF ["%VCINSTALLDIR%"] == [] (
  echo "Cannot find VC install dir. Make sure you ran this in the visual studio command prompt"
  exit /b %errorlevel%
)

if exist src (
  cd src
  git pull
  cd ..
) else (
  git clone https://github.com/vim/vim src
)

IF NOT EXIST src  (
  echo "Cannot find vim source code. Maybe there was a problem with 'git clone'?"
  echo %errorlevel%
  exit /b %errorlevel%
)

call "%VCINSTALLDIR%\Auxiliary\Build\vcvars32.bat"

set GUI=no
set DYNAMIC_PYTHON=yes
set PYTHON=C:\Program Files (x86)\Python27
set PYTHON_VER=
set DYNAMIC_PYTHON3=yes
set PYTHON3=%LOCALAPPDATA%\Programs\Python\Python36-32
set NETBEANS=no
set FEATURES=HUGE
set CPUNR=i686
set WINVER=0x501
set OLE=no
set OPTIMIZE=SPEED
set CSCOPE=yes
set LIB=%LIB%;%LOCALAPPDATA%\Programs\Python\Python36-32\libs
set DYNAMIC_RUBY=
set RUBY=
set RUBY_VER=
set RUBY_API_VER_LONG=

set SRC=%USERPROFILE%\builds\vim\src
set DST=%USERPROFILE%\vim\current

if exist "%USERPROFILE%\vim\runtime" (
  rmdir /S /Q "%USERPROFILE%\vim\runtime"
)

if exist "%DST%" (
  move /Y "%DST%" "%USERPROFILE%\vim\prior"
)

for /l %%x in (1, 1, 2) do (
  if %%x==2 set GUI=yes

  cd src\src\
  nmake -f Make_mvc.mak clean
  nmake -f Make_mvc.mak
  cd ..
  cd ..

  xcopy %SRC%\runtime "%DST%" /D /E /H /I /Y %*
  xcopy %SRC%\src\xxd\xxd.exe "%DST%\*" /D /Y %*
  xcopy %SRC%\src\GvimExt\gvimext.dll "%DST%\*" /D /Y %*
  xcopy %SRC%\src\*.exe "%DST%\*" /D /Y %*
)


mklink /D "%USERPROFILE%\vim\runtime" "%USERPROFILE%\vim\current"

rmdir /S /Q src

echo ==========================================================================
echo ** vim installed in %USERPROFILE%\vim\current
echo ** vim runtime in %USERPROFILE%\vim\runtime
echo ** prior vim moved to %USERPROFILE%\vim\prior
echo ==========================================================================
