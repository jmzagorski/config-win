# config-win
Windows configuration files for various programs

Configuration for Powershell, cmder, conemu and for building vim from source

## Clone
```powershell
mkdir $env:appdata\dotfiles
git clone --separate-git-dir=$env:appdata\dotfiles https://github.com/jmzagorski/config-win.git $env:tmp\dotfiles
cd $env:tmp\dotfiles
mv .git $env:appdata\dotfiles
cd $env:userprofile
mv $env:tmp\dotfiles\* .
config config status.showUntrackedFiles no
```

_the config alias should already be present in the powershell profile_
