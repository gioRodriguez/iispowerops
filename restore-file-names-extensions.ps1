$files = Get-ChildItem -Path '.\*.*'
$files | ForEach-Object {
	$originalExtension = ([System.IO.Path]::GetExtension($_))
    $finalExtension = '.'+([System.IO.Path]::GetExtension($_).split('_')[1])
    Rename-Item $_ ($_ -replace $originalExtension, $finalExtension) -ErrorAction SilentlyContinue
}

$files = Get-ChildItem -Path '.\**\*.*'
$files | ForEach-Object {
	$originalExtension = ([System.IO.Path]::GetExtension($_))
    $finalExtension = '.'+([System.IO.Path]::GetExtension($_).split('_')[1])
    Rename-Item $_ ($_ -replace $originalExtension, $finalExtension) -ErrorAction SilentlyContinue
}