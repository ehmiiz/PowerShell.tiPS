#Requires -Version 3.0
Set-StrictMode -Version Latest

# Import all Classes and Private and Public functions from their respective directories, in that order.
[string[]] $classFilePaths =
	Get-ChildItem -Path $PSScriptRoot\Classes -Recurse -Filter '*.ps1' -Exclude '*.Tests.ps1' |
	Select-Object -ExpandProperty FullName

[string[]] $privateFunctionFilePaths =
	Get-ChildItem -Path $PSScriptRoot\Private -Recurse -Filter '*.ps1' -Exclude '*.Tests.ps1' |
	Select-Object -ExpandProperty FullName

[string[]] $publicFunctionFilePaths =
	Get-ChildItem -Path $PSScriptRoot\Public -Recurse -Filter '*.ps1' -Exclude '*.Tests.ps1' |
	Select-Object -ExpandProperty FullName

[string[]] $functionFilesToImport = $classFilePaths + $privateFunctionFilePaths + $publicFunctionFilePaths

$functionFilesToImport | ForEach-Object {
	[string] $filePath = $_

	try
	{
		Write-Debug "Dot-source importing functions/types from file '$filePath'."
		. $_
	}
	catch
	{
		Write-Error "Failed to dot-source import functions/types from file '$filePath': $_"
	}
}

Write-Debug 'Now that all types and functions are imported, initializing the module by reading in all the PowerShell tips.'
ReadAllPowerShellTipsFromJsonFileIntoTipsVariable

# Function and Alias exports are defined in the modules manifest (.psd1) file.
