function ReadAllPowerShellTipsFromJsonFileIntoTipsVariable
{
	[string] $moduleRootDirectoryPath = Split-Path -Path $PSScriptRoot -Parent
	[string] $powerShellTipsJsonFilePath = Join-Path -Path $moduleRootDirectoryPath -ChildPath 'PowerShellTips.json'
	[tiPS.PowerShellTip[]] $tipObjects =
		Get-Content -Path $powerShellTipsJsonFilePath -Raw |
		ConvertFrom-Json

	[hashtable] $tipHashtable = [ordered]@{}
	foreach ($tip in $tipObjects)
	{
		$tipHashtable[$tip.Id] = $tip
	}

	# Scope our $Tips variable to the entire module so the Get-PowerShellTips cmdlet can access it.
	New-Variable -Name 'Tips' -Value $tipHashtable -Option Constant -Scope Script
}
