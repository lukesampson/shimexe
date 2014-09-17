$fwdir = gci C:\Windows\Microsoft.NET\Framework\ -dir | sort -desc | select -first 1

$out = "$(resolve-path $psscriptroot\..\lib)\shim.exe"

pushd $psscriptroot
& "$($fwdir.fullname)\csc.exe" /nologo /out:$out shim.cs
popd