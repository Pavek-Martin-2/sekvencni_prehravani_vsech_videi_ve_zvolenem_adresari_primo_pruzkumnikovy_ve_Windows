cls

# vytvoreni zastupce souboru + nastaveni vlastnosti zastupce

Set-PSDebug -Strict # jakakoliv nedeklarovana promenna pri jejim zavolani udela chybu skriptu

#$targetPath = "10" # zde manit pocet vterin slideshow mezi fotkama

$targetPath = ""
$n = ""

$mute = Read-Host "mute (a/n) ?"

if ( $mute -like "a" ) {
$targetPath += "MUTE"
$n += "MUTE"
}


$rychlost = Read-Host "rychlost [n]ormal [p]olovicni [d]vojnasobna ?"
if ( $rychlost -like "n"){
$n += " puvodni rychlost"
}elseif ( $rychlost -like "p" ){
$targetPath += " 0.5"
$n += " polovicni rychlost"
} elseif ( $rychlost -like "d" ){
$targetPath += " 2.0"
$n += " dvojnasobna rychlost"
} else {
$targetPath += [string] $rychlost
}

#echo $targetPath
#echo $n
#exit

$shortcutPath = "play_video_folder.exe – zástupce $n.lnk" # nazev zastupce videa
Remove-Item -Path $shortcutPath -ErrorAction SilentlyContinue
sleep -Milliseconds 300

$exec = "C:\tools\play_video_folder.exe"

$ikona_mpv = "C:\Program Files (x86)\mpv-x86_64\mpv.exe,0" # ikona programu mpv.exe (0) ma jenom jednu ikonu
$okno = @("7","1","3") # [0]=minimalizovane; [1]=normalni; [2]=maximalizovane okno konzole
$hot = "" # pradnej strings neudela polozku "Žádné" jako je to bezne ale udela prazdne policko takze musi tam bejt $NULL

# vytvoreni COM objektu
$WshShell = New-Object -ComObject WScript.Shell
# vytvoreni zástupce
$shortcut = $WshShell.CreateShortcut($shortcutPath)


# nastaveni vlastnosti zastupce programu
$shortcut.TargetPath = $exec # nastavení cíle v tomto pripade ale mpvs.bat vcetne cele cesty
$shortcut.Arguments = $targetPath # parametry ktere se predaji programu pri spusteni
$shortcut.Description = "$n" # komentar zastupce programu
$shortcut.WorkingDirectory = "" # spustit v
$shortcut.IconLocation = $ikona_mpv # ikona zastupce (ikonu si vezme z mpv.exe )
$shortcut.WindowStyle = $okno[1] # [0]=minimalizovane; [1]=normalni; [2]=maximalizovane okno konzole

if ( $hot.Length -ne 0 ){ # pokud nebude pouze, $hot = ""
$shortcut.Hotkey = $hot # klavesova zkratka spusteni zastupce
}

# ulozeni souboru zastupce *.lnk
$shortcut.Save()

Write-Host -ForegroundColor Yellow "by vytvoren novy soubor " -NoNewline
Write-Host -ForegroundColor Green '"' -NoNewline
Write-Host -ForegroundColor Green $shortcutPath -NoNewline
Write-Host -ForegroundColor Green '"'
sleep 3


