$p='g:\My Drive\Games\Quack Noir\QuackNoirTest-New.html'
$lines=Get-Content -LiteralPath $p
$last = $null
for ($i=0; $i -lt 5206; $i++) {
    if ($lines[$i] -match '\(function') { $last = $i+1 }
}
Write-Host "Last (function before 5206 at line: $last"
