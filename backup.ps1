param (
    $localPath = "c:\backup\",
    $remotePath = "/home/user/",
    $fileName = "backup"
	$zipPath = "C:\Program Files\7-Zip\7z.exe"
)
         
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "example.com"
        UserName = "user"
        Password = "mypassword"
    }
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
 
        # Format timestamp
        $stamp = $(Get-Date -Format "yyyyMMddHHmmss")
 
        $synchronizationResult =
		$session.SynchronizeDirectories(
        [WinSCP.SynchronizationMode]::local, ($remotePath + "\sync"), ($localPath)), $False)
		# Throw on any error to emulate the (default) "option batch abort" mode
		$synchronizationResult.Check()

		if (-not (test-path "$zipPath")) {throw "$zipPath needed"} 
		set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"  
		
		sz a -mx=9 ($localPath+$fileName + "." + $stamp + ".zip") ($localPath + "\sync")





		}
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch [Exception]
{
    Write-Host ("Error: {0}" -f $_.Exception.Message)
    exit 1
}
