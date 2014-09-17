function fname($path) { split-path $path -leaf }
function strip_ext($fname) { $fname -replace '\.[^\.]*$', '' }
function env($name,$val='__get') {
	if($val -eq '__get') { [environment]::getEnvironmentVariable($name,'User') }
	else { [environment]::setEnvironmentVariable($name,$val,'User') }
}
function strip_path($orig_path, $dir) {
	$stripped = [string]::join(';', @( $orig_path.split(';') | ? { $_ -and $_ -ne $dir } ))
	return ($stripped -ne $orig_path), $stripped
}
function ensure_first_in_path($dir) {
	$dir = resolve-path $dir

	# future sessions
	$null, $currpath = strip_path (env 'path') $dir
	env 'path' "$dir;$currpath"

	# this session
	$null, $env:path = strip_path $env:path $dir
	$env:path = "$dir;$env:path"
}