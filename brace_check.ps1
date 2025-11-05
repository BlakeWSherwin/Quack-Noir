$p = 'g:\My Drive\Games\Quack Noir\QuackNoirTest-New.html'
$lines = Get-Content -LiteralPath $p -ErrorAction Stop
$cum = 0
$firstNeg = $null
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    $opens = ([regex]::Matches($line,'\{')).Count
    $closes = ([regex]::Matches($line,'\}')).Count
    $cum += $opens - $closes
    if ($firstNeg -eq $null -and $cum -lt 0) { $firstNeg = $i + 1; break }
}
if ($firstNeg) { Write-Host "First negative brace balance at line $firstNeg; cumulative=$cum" } else { Write-Host "No negative cumulative detected; final cumulative=$cum" }

# Print surrounding context
$start = ($firstNeg - 6); if ($start -lt 1) { $start = 1 }
$end = $start + 18
Write-Host "--- Context lines $start..$end ---"
for ($j=$start; $j -le $end; $j++) { $ln = (Get-Content -LiteralPath $p -TotalCount $j | Select-Object -Last 1); Write-Host ("{0,6}: {1}" -f $j, $ln) }
