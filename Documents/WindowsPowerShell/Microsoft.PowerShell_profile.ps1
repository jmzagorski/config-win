set-location $env:userprofile

$Shell = $Host.UI.RawUI

# Get username:
[System.Security.Principal.WindowsPrincipal]$global:currentUser =
New-Object System.Security.Principal.WindowsPrincipal(
[System.Security.Principal.WindowsIdentity]::GetCurrent()
)
if($global:currentUser.IsInRole(
[System.Security.Principal.WindowsBuiltInRole]::Administrator)
) {
  $user = "root";
} else {
  $userParts = $global:currentUser.Identities.Name.Split('\')
  $user = if ($userParts.Length -ge 1) { $userparts[1] } else { $userParts[0] }
}
$Shell.WindowTitle =  $user + "@" + [System.Net.Dns]::GetHostName() + " (v" + (Get-Host).Version + ")";

$size = $Shell.WindowSize
$size.width=70
$size.height=25
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=70
$size.height=5000
$Shell.BufferSize = $size

function Diff-WorkTree {
  $pf = $env:ProgramFiles;
  $profile = $env:UserProfile;

  & "$pf\Git\bin\git" --git-dir=$profile\.config\config-win --work-tree=$profile $args
}

function Linux-Touch {
  [cmdletbinding()]
  Param (
    [string]$file
  )
  "" | out-file $file
}
function Linux-Head {
  [cmdletbinding()]
  Param (
    [int]$lines = 10
  )
  $input | select -first $lines
}
function Linux-Less {
  $input | out-host -paging
}
function Linux-Open {
  [cmdletbinding()]
  Param (
    [string]$path
  )
  (New-Object -Com Shell.Application).Open($path)
}

Set-Alias -Name config -Value Diff-WorkTree -Description "Allows config files to stay home"
# this gives me the bash command history keys
Set-PSReadLineOption -EditMode Emacs
Set-Alias -Name touch -Value Linux-Touch -Description "creates an empty file"
Set-Alias -Name less -Value Linux-Less -Description "paginates long input"
Set-Alias -Name head -Value Linux-Head -Description "truncates the results by number of lines"
Set-Alias -Name open -Value Linux-Open -Description "opens the input"

#Clear-Host

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function prompt {
  #$p = Split-Path -leaf -path (Get-Location)
  #"$p> "
  $base = $user + "@" + [System.Net.Dns]::GetHostName() + ":"
  $path = "$($executionContext.SessionState.Path.CurrentLocation)"
  $prefix = if ($user -eq "root") { "#" } else { "$" }
  $userPrompt = "$($prefix * ($nestedPromptLevel + 1)) "

  Write-Host "`n$base" -NoNewline -ForegroundColor "green"
  Write-Host $path.Replace($env:userprofile, "~") -NoNewLine

  return $userPrompt
}
