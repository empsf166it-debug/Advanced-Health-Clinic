$ids = @("1474133465910-c41f71dfb33e", "1491176219808-1f1981fb9bb7", "1507003211169-0a1dd7228f2d", "1516321497487-313f66ce3ef0", "1527613426421-4c6b653457a4", "1580482598-cde8c7dbdcc7")
$filesToFix = @("gallery.html", "home-2.html", "index.html", "testimonials.html")
$baseDir = "c:\Users\Shalani A\Documents\Shalan\Own Websites(August)\Advanced Health Clinic"

$globalUsed = @()
Get-ChildItem -Path $baseDir -Filter *.html | ForEach-Object {
    $c = Get-Content $_.FullName -Raw
    $m = Select-String -InputObject $c -Pattern 'images\.unsplash\.com/photo-([a-zA-Z0-9\-]+)' -AllMatches
    if ($m) { foreach ($x in $m.Matches) { $globalUsed += $x.Groups[1].Value } }
}

function Get-FreshId () {
    foreach ($i in $ids) {
        if ($globalUsed -notcontains $i) {
            $script:globalUsed += $i
            return $i
        }
    }
    return "1559839734-2b71ea197ec2"
}

foreach ($f in $filesToFix) {
    $path = Join-Path $baseDir $f
    $content = Get-Content $path -Raw
    
    # We will do regex replace with evaluator but powershell doesn't easily support callback replace natively without a bit of code.
    # Let's do it line by line or match by match.
    $matches = [regex]::Matches($content, 'images\.unsplash\.com/photo-([a-zA-Z0-9\-]+)')
    $seenInFile = @{}
    $offset = 0
    foreach ($m in $matches) {
        $id = $m.Groups[1].Value
        if ($seenInFile.ContainsKey($id)) {
            # It's a duplicate! We need a fresh ID.
            $newId = Get-FreshId
            # Replace at specific index
            $oldLen = $m.Value.Length
            $newStr = "images.unsplash.com/photo-$newId"
            $content = $content.Substring(0, $m.Index + $offset) + $newStr + $content.Substring($m.Index + $offset + $oldLen)
            $offset += ($newStr.Length - $oldLen)
        } else {
            $seenInFile[$id] = $true
        }
    }
    Set-Content -Path $path -Value $content -NoNewline
}
Write-Output "Fixed duplicates."
