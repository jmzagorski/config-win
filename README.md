# config-win
Windows configuration files for various programs

Configuration for Powershell, cmder, conemu and for building vim from source

## Clone
```powershell
mkdir $env:userprofile\.config
git clone --separate-git-dir=$env:userprofile\.config\config-win https://github.com/jmzagorski/config-win.git $env:userprofile\config-win-tmp
cd $env:userprofile\config-win-tmp
mv .git $env:userprofile\.config\config-win
cd $env:userprofile
mv $env:userprofile\config-win-tmp\* .
rm -r $env:userprofile\config-win-tmp
config config status.showUntrackedFiles no
```
