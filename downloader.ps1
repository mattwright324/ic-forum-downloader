# Set path to current script location
$path = $MyInvocation.MyCommand.Path
if (!$path) {$path = $psISE.CurrentFile.Fullpath}
if ($path)  {$path = Split-Path $path -Parent}
Set-Location $path

# Settings
$forumPattern = "https://forums.getpaint.net/applications/core/interface/file/attachment.php?id="
$folder = -join("/", ([uri]$forumPattern).Authority, "/");
$outputLocation = -join($path, $folder)
$begin = 1
$end = 100

mkdir -p $outputLocation -Force

Write-Host $forumPattern
Write-Host $outputLocation

for ($i = $begin; $i -le $end; $i++) {
    $url = -join($forumPattern, $i)
    
    Write-Host
    try {
        $download = Invoke-WebRequest -Uri $url

        $content = [System.Net.Mime.ContentDisposition]::new($download.Headers["Content-Disposition"])
        Write-Host $download.Headers
        if ($content.ToString() -like "*=UTF-8''*") {
            $fileName = ($content.ToString() -split "UTF\-8''")[1]
        } else {
            $fileName = $content.FileName
        }

        # Files without extension of type unknown are likely zip files
        if ($fileName -notlike  '\.' -And $download.Headers["Content-Type"] -like "*application/x-unknown*") {
            $fileName = -join($fileName, '.zip');
        }
        
        $filePath = -join($outputLocation, $fileName)
        $file = [System.IO.FileStream]::new($filePath, [System.IO.FileMode]::Create)
        $file.Write($download.Content, 0, $download.RawContentLength)
        $file.Close()

        Write-Host $url
        $debug = -join($fileName, ", size: ", $download.RawContentLength)
        Write-Host $debug
    } catch {
        Write-Host $url -ForegroundColor red
    }
}

