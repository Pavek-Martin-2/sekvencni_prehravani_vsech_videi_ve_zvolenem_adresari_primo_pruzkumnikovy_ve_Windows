cls
<#
play_video_folder_81.ps1

prehrava vsechny videa v adrtesari pouziva $PWD pro vytvoreni vsech videji ve zvolenem adresari
spousti se v pruzkumnikovy z adresniho radku
ma moznosti parametru :
play_video_folder help ( vypise napovedu )
play_video_folder mute ( bez zvuku )
play_video_folder 0.5 ( pro polovicni rychlost prehravani )
play_video_folder 2.0 ( pro dvojnasobnou rychlost prehravani )
play_video_folder mute 0.5 ( bez zvuku a polovicni rychlost prehravani )
play_video_folder mute 2.0 ( bez zvuku dvojnasobna rychlost prehravani )
play_video_folder 0.5 mute ( bez zvuku dvojnasobna rychlost prehravani )
play_video_folder 2.0 mute ( bez zvuku dvojnasobna rychlost prehravani )

na poradi argumentu nzalezi napr. "play_video_folder mute 2.0" je totez jako "play_video_folder mute 2.0"
pouziti dvou protichudnych parametru "0.5" a "2.0" najedno skonci upozornenim a chybou
paramety lze pouzit, zadni, jeden nebo dva
mohou byt "mute" "0.5" "2.0"
na poradi nezalezi, vysledek je stejny ( mimo parametru help )
zadane parametry budou aplikovany a sekvencni prehrani vsech videi ve zvolenem adresari
skok na dalsi video je klavesou "q"
pro ukonceni, zmacknout klavesu "f" jako fullscreen a pak zavrit okno PowerShellu
klavesnice stale funguje takze kdyz spustite prehravani vsecho bez "mute" a pak si to rozmislite
tak kalvesou "m" zvuk vypnete ale u dalsiho videa uz zase pobezi, takze by se muselo mackat "m" stale

spusti se v pruzkumnikovi z adresniho radku vcetne parametru jako muj predchozi skrip "slideshow"
pro prohlizeni obrazku, viz. screenshoty v repozirari slideshow"
negeneruje zadnej davkovej soubor na ramdisku apod. rovnou prehrava sam o sobe, coz si myslim ze je lepsi
a chtel by se touhle cestou ubyrat i v budoucnu, pokud to pujde

PS : parametr "0.5" bez "mute" asi nedava moc smysl ale dal jsem to tam taky, bude slyset spomalene huhlani
pomoci parametru "--msg-level=all=no" je potacenej veskerej verbose prehravace "mpv.exe" ( delalo to bordel )
lehci verze je pak parametr "--msg-level=statusline=no" kerej potacuje jen "procenta" prehravaneho videa
takze novinka, chodte se radit na Goggle AI, nikdy me to nezklamalo ... ( Frantisek at de taky ( na Google AI))
#>

if ( $args[0] -like "help" ) {
Write-Warning "moznosti jsou :"
echo "play_video_folder help ( tato napoveda )"
echo "play_video_folder"
echo "play_video_folder mute"
echo "play_video_folder mute 0.5 ( nebo opacne poradi )"
echo "play_video_folder mute 2.0"
echo "play_video_folder 0.5"
echo "play_video_folder 2.0"
sleep 10
exit
}

# test command "mpv"
$c1 ="mpv" # mpv nekde v ceste PATH ( %CD% v cmd.exe )
if (-not (Get-Command $c1 -ErrorAction SilentlyContinue )) {
Write-Warning "prikaz $c1 nenalezen"
sleep 3
exit 1
}

$pole_include = @("*.mp4", "*.avi", "*.mpg"," *.flc", "*.flv" ) # tady se daj pridavat formaty
# neni case sensitive  takze "*.AVI" je totez jako "*.avi"

$files_celkem = @()
$files_celkem += @(Get-ChildItem -file -Name)
$celkem_souboru = $files_celkem.Length

#
$delka_args = $args.length
#echo "celkem args $delka_args"

$mute = 0
$polovicni_rychlost = 0
$dvojnasobna_rychlost = 0

for ( $aa = 0; $aa -le $delka_args; $aa++ ) {
$arg = $args[$aa]
#echo $arg
if ( $arg -like "mute" ){ $mute = 1 }
if ( $arg -like "0.5" ) { $polovicni_rychlost = 1 } 
if ( $arg -like "2.0" ) { $dvojnasobna_rychlost = 1 }
}

# kontrola, zadany dva protichudne parametry
if (( $polovicni_rychlost -eq 1 ) -and ( $dvojnasobna_rychlost -eq 1 )) {
Write-Warning "chybne zadani parametru"
echo "zadej : play_video_folder help"
sleep 3
exit
}


if (((
( $delka_args -ne 0 ) -and
( $polovicni_rychlost -eq 0 ) -and
( $dvojnasobna_rychlost -eq 0 ) -and 
( $mute -eq 0 )
))) {
Write-Warning "chybne zadani parametru"
echo "zadej : play_video_folder help"
sleep 3
exit
sleep 3
exit
}


# PWD
[string] $path = Get-Location
$d_path = $path.Length
#echo $d_path
if ($d_path -ne 3 ){ $path += "\" }
write-host -ForegroundColor cyan $path

Write-Host -ForegroundColor White "mute = $mute"
Write-Host -ForegroundColor White "polovicni_rychlost = $polovicni_rychlost"
Write-Host -ForegroundColor White "dvojnasobna_rychlost = $dvojnasobna_rychlost"

#
$files = @()
#$files += Get-ChildItem -Include $pole_include -Name
$files += @(Get-ChildItem -Include $pole_include -Name) | Sort-Object
$d_files = $files.Length

if ($d_files -eq 0 ) {
Write-Warning "zadne videa v adresari" # neni co prohlizet, ostreni chyby
sleep 3
exit
}

write-host -ForegroundColor Green "celkem vsech souboru v adresari $celkem_souboru"
write-host -ForegroundColor Green "celkem videi v adresari $d_files"
sleep -Milliseconds 500

$poc = 1

for ( $bb = 0; $bb -le $d_files -1 ; $bb++ ) {
$video = $files[$bb]

if ( $poc % 2 -eq 1 ){ $barva = "Yellow" } else { $barva = "Cyan"} # suda  a licha barva
# suda a licha hodnota $poc bude stridat barvu textu
write-host -ForegroundColor $barva "prehravam video $poc / $d_files"
write-host -ForegroundColor $barva $video
sleep 1

# mpv --msg-level=statusline=no video.mp4 ( potaceni, hlaseni, procenta prehravaneho videa )
# mpv --msg-level=all=no video.mp4 ( uplne ticho v konzoli )

# delal jsem pokusi se sestvenim radku parametu jako promenny a spustenim pomoci prikazu
# & mpv $parametry $video 
# ale nic nefungovalo, takze toto byla druha moznost jak to udelat pomoci nekolika podminek, skoda :(
if ($delka_args -eq 0) {
& mpv --fs --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}

if ((( $mute -eq 0 ) -and ( $polovicni_rychlost -eq 1 ) -and ( $dvojnasobna_rychlost -eq 0 ))) {
& mpv --fs --speed=0.5 --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}

if ((( $mute -eq 0 ) -and ( $polovicni_rychlost -eq 0 ) -and ( $dvojnasobna_rychlost -eq 1 ))) {
& mpv --fs --speed=2.0 --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}
#
if ((( $mute -eq 1 ) -and ( $polovicni_rychlost -eq 0 ) -and ( $dvojnasobna_rychlost -eq 0 ))) {
& mpv --fs -mute --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}

if ((( $mute -eq 1 ) -and ( $polovicni_rychlost -eq 1 ) -and ( $dvojnasobna_rychlost -eq 0 ))) {
& mpv --fs -mute --speed=0.5 --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}

if ((( $mute -eq 1 ) -and ( $polovicni_rychlost -eq 0 ) -and ( $dvojnasobna_rychlost -eq 1 ))) {
& mpv --fs -mute --speed=2.0 --msg-level=all=no --osd-level=3 --osd-font-size=30 $video
}

$poc++
}

write-host -ForegroundColor Green "HOTOVO"
sleep 1
