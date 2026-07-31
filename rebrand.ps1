$dir = "c:\Users\Shalani A\Documents\Shalan\Own Websites(August)\Advanced Health Clinic"
$files = Get-ChildItem -Path $dir -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace names
    $content = $content -replace "Advanced Health Clinic", "Mediora"
    $content = $content -replace "Advanced Health", "Mediora"
    
    # Replace URL instances
    $content = $content -replace "advancedhealthclinic\.com", "mediora.com"
    
    # Insert favicon if missing
    if (-not $content.Contains("favicon.svg")) {
        $content = $content -replace "</title>", "</title>`r`n    <link rel=`"icon`" href=`"favicon.svg`" type=`"image/svg+xml`">"
    }
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Rebrand completed successfully for $($files.Count) files."
