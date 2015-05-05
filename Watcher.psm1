function Watcher {
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$true)]
	[System.Management.Automation.ScriptBlock]$block
)
 
	$watcher = New-Object System.IO.FileSystemWatcher
	$watcher.Path = get-location
	$watcher.IncludeSubdirectories = $true
	$watcher.EnableRaisingEvents = $false
	$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName
	 
	while($true){
		$result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
		if($result.TimedOut){
			continue;
		}
		write-host "Change(s) in " + $result.Name
		invoke-command -scriptblock $block
	}

}

Export-ModuleMember Watcher