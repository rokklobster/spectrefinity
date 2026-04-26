$libs = @{}

$lib_files = @('common.scad', 'geometry.scad')
$model_files = @('tile.scad', 'clip.scad', 'bucket.scad')

if (-not (resolve-path $lib_files[0] -ErrorAction SilentlyContinue)) {
    Write-Host 'the script must be ran from the repo root'
    exit
}

foreach ($file in $lib_files) {
    $content = Get-Content $file -Raw
    $libs[$file] = $content
}

foreach ($file in $model_files) {
    $content = Get-Content $file -Raw

    foreach ($lib_file in $lib_files) {
        $include_line = "include <$lib_file>"
        if ($content -match [regex]::Escape($include_line)) {
            $content = $content -replace [regex]::Escape($include_line), $libs[$lib_file] -join "`n"
        }
    }

    Set-Content "merged/$file" -Value $content
}