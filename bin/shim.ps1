param($source, $name, $arg, $dir, [switch]$help)

. "$psscriptroot/../lib/util.ps1"

$shimdir = "~/appdata/local/shims"
$usage = "usage: shim <source> [name] [args] [dir]"

if('/?', '--help' -contains $source -or $help) { $usage; exit }
if(!$source) { "shim: source missing"; $usage; exit 1; }
if(!(test-path $source)) { "shim: couldn't find $source"; exit 1 }

if(!$name) { $name = strip_ext (fname $source) }

if(!$dir) {
	# create in shim dir
	if(!(test-path $shimdir)) { mkdir $shimdir > $null }
	$dir = resolve-path $shimdir
	ensure_first_in_path $dir
}

$shim = "$dir\$($name.tolower())"

# note: use > for first line to replace file, then >> to append following lines
echo "`$path = '$source'" > "$shim.ps1"
if($arg) {
	echo "`$args = '$($arg -join "', '")', `$args" >> "$shim.ps1"
}
echo 'if($myinvocation.expectingInput) { $input | & $source @args } else { & $path @args }' >> "$shim.ps1"

if($source -match '\.exe$') {
	# for programs with no awareness of any shell
	cp "$psscriptroot\..\lib\shim.exe" "$shim.exe" -force
	echo "path = $(resolve-path $source)" | out-file "$shim.shim" -encoding oem
	if($arg) {
		echo "args = $arg" | out-file "$shim.shim" -encoding oem -append
	}
} elseif($source -match '\.((bat)|(cmd))$') {
	# shim .bat, .cmd so they can be used by programs with no awareness of PSH
	"@`"$(resolve-path $source)`" $arg %*" | out-file "$shim.cmd" -encoding oem
} elseif($source -match '\.ps1$') {
	# make ps1 accessible from cmd.exe
	"@powershell -noprofile -ex unrestricted `"& '$(resolve-path $source)' %*;exit `$lastexitcode`"" | out-file "$shim.cmd" -encoding oem
}

