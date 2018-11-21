
param (
    [string]$action = "dload"
 )

$actions = "dload", "uninstall", "upgrade", "clean"
if($action -notin $actions) {
    Write-Host "invalid $action" -ForegroundColor Red
    exit
}

$packages = 
("file1", "1.1.483.0"),
("file2", "7.0.5")

$baseUrl = "-baseurl-"

foreach ($package in $packages) {
    Write-Host "$($action)ing $package..." -foregroundcolor "magenta"

    $url = "$baseUrl/$($package[0])/$($package[0]).$($package[1]).nupkg" 
    $outFile ="$($package[0]).$($package[1]).nupkg.zip"
    Write-Host $url

    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie 
    $cookie.Name = "SESSION"
    $cookie.Value = "-blah-"
    $cookie.Domain = "-domain-"

    $session.Cookies.Add($cookie);

    Invoke-WebRequest -Uri $url -OutFile $outFile -WebSession $session -SkipCertificateCheck
}
