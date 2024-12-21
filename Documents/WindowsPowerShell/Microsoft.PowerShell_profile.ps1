set-location $env:userprofile

$Shell = $Host.UI.RawUI
Set-PSReadlineOption -BellStyle None

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

function Diff-WorkTree {
  $pf = $env:ProgramFiles;
  $profile = $env:UserProfile;

  & "$pf\Git\bin\git" --git-dir=$env:appdata\dotfiles --work-tree=$profile $args
}

Set-Alias -Name config -Value Diff-WorkTree -Description "Allows config files to stay home"
Set-PSReadLineOption -EditMode Emacs

function prompt {
  $base = $user
  $path = "$($executionContext.SessionState.Path.CurrentLocation)"
  $prefix = if ($user -eq "root") { "#" } else { "$" }
  $userPrompt = "$($prefix * ($nestedPromptLevel + 1)) "

  Write-Host "`n$base" -NoNewline
  Write-Host $path.Replace($env:userprofile, "~") -NoNewLine

  return $userPrompt
}
