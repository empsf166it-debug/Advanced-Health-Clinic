$baseDir = "c:\Users\Shalani A\Documents\Shalan\Own Websites(August)\Advanced Health Clinic"

# Define fresh, premium Unsplash IDs for each category
$categories = @{
    Hero = @("1519494026892-80bbd2d6fd0d", "1538108149393-cebb47acdd4e", "1516549655169-df83a0774514", "1551076805-e18690c5e53b", "1581594693702-fbdc51b2763b", "1586773860418-d37222d8fce3", "1573497491208-6b1acb260507", "1584036561584-b034f921ab00")
    Doctors = @("1559839734-2b71ea197ec2", "1612349317150-e413f6a5b16d", "1594824436951-7f12bc58a086", "1622253692010-333f2da6031d", "1537368910025-700350fe46c7", "1651008376811-b90baee60c1f", "1527613426421-4c6b653457a4", "1580482598-cde8c7dbdcc7", "1506126613615-32e6a3782b52", "1499597395995-eb95be613041", "1504439468489-c8920d796a29", "1581056771107-24ca5f033842", "1583314812-70b10e5ed5d1", "1491841550275-ad7854e35ca6", "1475510219669-2cb83d162a05", "1551069613-11db694b9ff3", "1503387762-592deb58ef4e")
    Gallery = @("1512678080530-7760d81faba6", "1580281657527-47f249e8f4fc", "1525207436034-7a422eb7f4aa", "1511174511562-58e1cced8ab2", "1579684385127-1ef15d508118", "1505751172876-fa1923c5c528", "1554734802-bd9efbc99c56", "1581452449-d3e925b6a71d", "1582750433449-648ed127d0fc", "1543362908-11ec26d03de7", "1574672620-e4a839fdf7d1", "1579684453377-48efffd18320", "1507413245164-6160d8298b31", "1603398938378-e54eab446dde", "1494390248081-4e521a5940db")
    Services = @("1576091160550-2173dba999ef", "1551884051-69ab9c8a9018", "1544005313-94ddf0286df2", "1505576399279-565b52d4ac71", "1483363385293-80e304b50035", "1581594693-3d0d829bfdb5", "1532938911079-1b06ac7ceec7", "1527063462-817b11634b31", "1526256262350-7da7584cf5eb", "1477332552846-ac6c150bb002", "1474133465910-c41f71dfb33e", "1571772996231-1e2ba52e4f45", "1556228578-0d85b1a4d571")
    Blog = @("1507003211169-0a1dd7228f2d", "1516321497487-313f66ce3ef0", "1497215968147-399248238fcd", "1484863137850-59afcfe05386", "1582298538-4e897937400d", "1464822759023-fed622ff2c3b", "1438761681033-6461ffad8d80", "1533090161767-e6ffed986c88", "1517487881594-2787fef5ebf7", "1491176219808-1f1981fb9bb7")
}

# Fix: Remove known broken ID 1538108149393-cebb47acdd4e from everywhere and replace with 1584308666744-24d5c474f2ae
$categories.Hero = $categories.Hero | Where-Object { $_ -ne "1538108149393-cebb47acdd4e" }
$categories.Hero += "1584308666744-24d5c474f2ae"

# Collect all current IDs from files
$allFiles = Get-ChildItem -Path $baseDir -Filter *.html
$globalIdPool = @()

foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw
    $matches = Select-String -InputObject $content -Pattern 'images\.unsplash\.com/photo-([a-zA-Z0-9\-]+)' -AllMatches
    if ($matches) {
        foreach ($m in $matches.Matches) {
            $globalIdPool += $m.Groups[1].Value
        }
    }
}

$globalIdPool = $globalIdPool | Sort-Object -Unique | Where-Object { $_ -ne "1538108149393-cebb47acdd4e" }

# Helper to get a random ID from a pool and remove it
$assignedIds = @()
function Get-UniqueId ($poolName) {
    # Combine the preferred category pool with the global pool as fallback
    $pool = $categories[$poolName] + $globalIdPool
    
    foreach ($id in $pool | Get-Random -Count 100) {
        if ($assignedIds -notcontains $id) {
            $script:assignedIds += $id
            return $id
        }
    }
    return "1576091160550-2173dba999ef" # absolute fallback
}

# Perform Replacement
foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Determine page category
    $cat = "Services"
    if ($file.Name -match "index|home|contact|login|signup") { $cat = "Hero" }
    elseif ($file.Name -match "doctor|about|testimonial") { $cat = "Doctors" }
    elseif ($file.Name -match "gallery") { $cat = "Gallery" }
    elseif ($file.Name -match "blog") { $cat = "Blog" }
    
    # Find all Unsplash URLs in the file
    $matches = Select-String -InputObject $content -Pattern 'images\.unsplash\.com/photo-([a-zA-Z0-9\-]+)' -AllMatches
    if ($matches) {
        # Create a mapping for this file's replacements
        $replacements = @{}
        foreach ($m in $matches.Matches) {
            $oldId = $m.Groups[1].Value
            if (-not $replacements.ContainsKey($oldId)) {
                $newId = Get-UniqueId $cat
                $replacements[$oldId] = $newId
            }
        }
        
        # Apply replacements
        foreach ($oldId in $replacements.Keys) {
            $newId = $replacements[$oldId]
            $content = $content -replace "photo-$oldId", "photo-$newId"
        }
        
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Output "Updated $($file.Name) with $($replacements.Count) unique images."
    }
}

Write-Output "Total unique images assigned: $($assignedIds.Count)"
