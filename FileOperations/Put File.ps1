# Step 1: Load the WinSCP .NET assembly
Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

# Step 2: Set up the session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "your.sftp.server"   # Replace with your SFTP server
    UserName = "yourUsername"        # Replace with your username
    Password = "yourPassword"        # Replace with your password
    SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" # Replace with your host key fingerprint
}

# Step 3: Create a new session and connect
$session = New-Object WinSCP.Session

try {
    # Step 4: Open the session
    $session.Open($sessionOptions)

    # Step 5: Define the local and remote paths
    $localPath = "C:\path\to\your\files\*"  # Replace with the path of your local files
    $remotePath = "/path/on/remote/server/" # Replace with your remote directory

    # Step 6: Upload files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Automatic

    $transferOperationResult = $session.PutFiles($localPath, $remotePath, $False, $transferOptions)

    # Step 7: Check for any errors
    if ($transferOperationResult.IsSuccess) {
        Write-Host "Files uploaded successfully!"
    } else {
        Write-Host "Errors occurred:"
        foreach ($transfer in $transferOperationResult.Transfers) {
            Write-Host "  $($transfer.FileName): $($transfer.Error)"
        }
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
} finally {
    # Step 8: Close the session
    $session.Dispose()
}
