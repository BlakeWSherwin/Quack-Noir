Add-Type -AssemblyName System.Drawing

$sheetPath = 'g:\My Drive\Games\Quack Noir\assets\dealer-sheet.png'
$cols = 8
$rows = 4
$alphaThreshold = 0

function Get-Bounds {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [int]$StartX,
        [int]$StartY,
        [int]$Width,
        [int]$Height,
        [int]$AlphaThreshold = 0
    )
    $minX = $Width
    $minY = $Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $Height; $y++) {
        for ($x = 0; $x -lt $Width; $x++) {
            $color = $Bitmap.GetPixel($StartX + $x, $StartY + $y)
            if ($color.A -gt $AlphaThreshold) {
                if ($x -lt $minX) { $minX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    if ($maxX -ge 0 -and $maxY -ge 0) {
        return [PSCustomObject]@{
            X = $StartX + $minX
            Y = $StartY + $minY
            Width = $maxX - $minX + 1
            Height = $maxY - $minY + 1
        }
    }
    else {
        return $null
    }
}

$bitmap = [System.Drawing.Bitmap]::FromFile($sheetPath)
try {
    $frameWidth = [Math]::Floor($bitmap.Width / $cols)
    $frameHeight = [Math]::Floor($bitmap.Height / $rows)
    Write-Output ("Sheet: {0}" -f $sheetPath)
    Write-Output ("  size: {0} x {1}" -f $bitmap.Width, $bitmap.Height)
    Write-Output ("  frame size (grid): {0} x {1}" -f $frameWidth, $frameHeight)
    $frameIndex = 0
    for ($row = 0; $row -lt $rows; $row++) {
        for ($col = 0; $col -lt $cols; $col++) {
            $x = $col * $frameWidth
            $y = $row * $frameHeight
            $bounds = Get-Bounds -Bitmap $bitmap -StartX $x -StartY $y -Width $frameWidth -Height $frameHeight -AlphaThreshold $alphaThreshold
            if ($bounds) {
                Write-Output ("  frame {0}: row={1} col={2} x={3} y={4} w={5} h={6}" -f $frameIndex, $row, $col, $bounds.X, $bounds.Y, $bounds.Width, $bounds.Height)
            } else {
                Write-Output ("  frame {0}: row={1} col={2} empty" -f $frameIndex, $row, $col)
            }
            $frameIndex++
        }
    }
}
finally {
    $bitmap.Dispose()
}
