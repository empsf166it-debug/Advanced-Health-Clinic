$baseDir = "c:\Users\Shalani A\Documents\Shalan\Own Websites(August)\Advanced Health Clinic"
$idsToUse = @("1504439468489-c8920d796a29", "1507413245164-6160d8298b31", "1565516086-5381f964a38f", "1581056771-33568285514b", "1584982751601-97d8cb0f66fc")
$dupeId = "1559839734-2b71ea197ec2"

$idx = 0
$filesToFix = @("home-2.html", "index.html", "testimonials.html")

foreach ($f in $filesToFix) {
    $path = Join-Path $baseDir $f
    $content = Get-Content $path -Raw
    
    $matches = [regex]::Matches($content, "images\.unsplash\.com/photo-$dupeId")
    $offset = 0
    foreach ($m in $matches) {
        if ($idx -lt $idsToUse.Count) {
            $newId = $idsToUse[$idx]
            $idx++
            $oldLen = $m.Value.Length
            $newStr = "images.unsplash.com/photo-$newId"
            $content = $content.Substring(0, $m.Index + $offset) + $newStr + $content.Substring($m.Index + $offset + $oldLen)
            $offset += ($newStr.Length - $oldLen)
        }
    }
    Set-Content -Path $path -Value $content -NoNewline
}
Write-Output "Fixed remaining duplicates."
