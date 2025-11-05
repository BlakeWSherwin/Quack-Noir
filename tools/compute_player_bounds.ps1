Add-Type -AssemblyName System.Drawing

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

$idlePath = 'g:\My Drive\Games\Quack Noir\assets\player-side.png'
$walkPath = 'g:\My Drive\Games\Quack Noir\assets\playerwalk-sheet.png'

$idle = [System.Drawing.Bitmap]::FromFile($idlePath)
try {
    $bounds = Get-Bounds -Bitmap $idle -StartX 0 -StartY 0 -Width $idle.Width -Height $idle.Height -AlphaThreshold 0
    Write-Output "Idle ($idlePath)" 
    Write-Output ("  size: {0} x {1}" -f $idle.Width, $idle.Height)
    if ($bounds) {
        Write-Output ("  bounds: x={0} y={1} w={2} h={3}" -f $bounds.X, $bounds.Y, $bounds.Width, $bounds.Height)
    } else {
        Write-Output "  bounds: (no opaque pixels)"
    }
}
finally {
    $idle.Dispose()
}

$walk = [System.Drawing.Bitmap]::FromFile($walkPath)
try {
    $cols = 8
    $rows = 2
    $frameWidth = [Math]::Floor($walk.Width / $cols)
    $frameHeight = [Math]::Floor($walk.Height / $rows)
    Write-Output "Walk ($walkPath)"
    Write-Output ("  sheet size: {0} x {1}" -f $walk.Width, $walk.Height)
    Write-Output ("  frame size (grid): {0} x {1}" -f $frameWidth, $frameHeight)
    $frameIndex = 0
    for ($row = 0; $row -lt $rows; $row++) {
        for ($col = 0; $col -lt $cols; $col++) {
            $x = $col * $frameWidth
            $y = $row * $frameHeight
            $bounds = Get-Bounds -Bitmap $walk -StartX $x -StartY $y -Width $frameWidth -Height $frameHeight -AlphaThreshold 0
            $frameIndex++
            if ($bounds) {
                Write-Output ("  frame {0}: row={1} col={2} x={3} y={4} w={5} h={6}" -f ($frameIndex - 1), $row, $col, $bounds.X, $bounds.Y, $bounds.Width, $bounds.Height)
            } else {
                Write-Output ("  frame {0}: row={1} col={2} empty" -f ($frameIndex - 1), $row, $col)
            }
        }
    }
}
finally {
    $walk.Dispose()
}
