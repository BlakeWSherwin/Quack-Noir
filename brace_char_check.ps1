$p = 'g:\My Drive\Games\Quack Noir\QuackNoirTest-New.html'
$content = Get-Content -LiteralPath $p -Raw
$lineStarts = @()
$pos = 0
foreach ($line in $content -split "\r?\n") { $lineStarts += $pos; $pos += ($line.Length + 1) }

$cum = 0
for ($i = 0; $i -lt $content.Length; $i++) {
    $ch = $content[$i]
    if ($ch -eq '{') { $cum++ }
    elseif ($ch -eq '}') { $cum-- }
    if ($cum -lt 0) {
        # find line number
        $line = ($lineStarts | Where-Object { $_ -le $i } | Measure-Object).Count
        $col = $i - $lineStarts[$line-1] + 1
        Write-Host "First negative at char pos $i (line $line, col $col)."
        $contextStart = [Math]::Max(0, $i-40)
        $contextEnd = [Math]::Min($content.Length-1, $i+40)
        $ctx = $content.Substring($contextStart, $contextEnd - $contextStart + 1)
        Write-Host "Context: ...$ctx..."
        break
    }
}
if ($cum -ge 0) { Write-Host "No char-level negative found, final cumulative=$cum" }
