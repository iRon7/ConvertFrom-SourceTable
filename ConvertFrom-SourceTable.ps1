<#PSScriptInfo
.VERSION 0.0.25
.GUID 0019a810-97ea-4f9a-8cd5-4babecdc916b
.AUTHOR iRon
.DESCRIPTION Converts a source table (format-table) or markdown table to objects
.COMPANYNAME 
.COPYRIGHT 
.TAGS Read Input Convert Resource Table Format MarkDown
.LICENSEURI https://github.com/iRon7/ConvertFrom-SourceTable/LICENSE.txt
.PROJECTURI https://github.com/iRon7/ConvertFrom-SourceTable
.ICONURI https://raw.githubusercontent.com/iRon7/Join-Object/master/ConvertFrom-SourceTable.png
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
.PRIVATEDATA 
#>

<#
	.SYNOPSIS
	Converts a source table (format-table) or markdown table to objects.

	.DESCRIPTION
	The ConvertFrom-SourceTable cmdlet creates objects from a fixed column
	source table (format-table) or markdown table. The ConvertFrom-SourceTable
	cmdlet supports most data types using the following formating and alignment
	rules:
		Data that is left aligned will be parsed to the generic column type
		which is a string by default.
		
		The generic column type can be set by prefixing the column name with
		a standard (PowerShell) cast operator (a data type enclosed in
		square brackets, e.g.: "[Int]ID")
		
		Data that is right aligned will be interpreted (using Invoke-Expression).
	
	Definitions:
		The width of a source table column is outlined by header width, the
		ruler width and the width of the process data. The process data for
		single rows supplied through the pipeline (in comparison to a multi
		line string) is limited from the first row up and till the current row.
		
		A right aligned field is outlined by its containing data which has at
		least one leading white space character and no following white space
		characters or at least one leading white space character and placed in a
		right aligned column.
		
		A right aligned column is outlined by the header description which has
		at least one leading white space character and no following white space
		characters
		
		Note that the vertical header ruler of a source table is especially useful
		for defining the boundaries of a column and how its data is aligned and
		processed.
		
	Parameters
		No is parameters is required.

	.PARAMETER HorizontalRuler
		Defines the horizontal ruler character. The default is a hyphen ("-").

	.PARAMETER VerticalRuler
		Defines the vertical ruler character. The default is a vertical line ("|").

	.PARAMETER Markdown
		Threats the input table as a markdown table (-Markdown) or a source table
		(-Markdown:$False). By default, the input table is automatically recognized
		by the vertical ruler.

	.EXAMPLE 

		$Employee = ConvertFrom-SourceTable '
		Department  Name    Country
		----------  ----    -------
		Sales       Aerts   Belgium
		Engineering Bauer   Germany
		Sales       Cook    England
		Engineering Duval   France
		Marketing   Evans   England
		Engineering Fischer Germany
		'

	.EXAMPLE 

		$Color = ConvertFrom-SourceTable '
		Name       Value         RGB
		------- -------- -----------
		Black   0x000000       0,0,0
		White   0xFFFFFF 255,255,255
		Red     0xFF0000     255,0,0
		Lime    0x00FF00     0,255,0
		Blue    0x0000FF     0,0,255
		Yellow  0xFFFF00   255,255,0
		Cyan    0x00FFFF   0,255,255
		Magenta 0xFF00FF   255,0,255
		Silver  0xC0C0C0 192,192,192
		Gray    0x808080 128,128,128
		Maroon  0x800000     128,0,0
		Olive   0x808000   128,128,0
		Green   0x008000     0,128,0
		Purple  0x800080   128,0,128
		Teal    0x008080   0,128,128
		Navy    0x000080     0,0,128
		'

		PS C:\> $Color | Where {$_.Name -eq "Red"}

		RGB         Name    Value
		---         ----    -----
		{255, 0, 0} Red  16711680

	.EXAMPLE 

		$Color = ConvertFrom-SourceTable '
		|---------|----------|---------------|
		| Name    |    Value |           RGB |
		|---------|----------|---------------|
		| Black   | 0x000000 |       0, 0, 0 |
		| White   | 0xFFFFFF | 255, 255, 255 |
		| Red     | 0xFF0000 |     255, 0, 0 |
		| Lime    | 0x00FF00 |     0, 255, 0 |
		| Blue    | 0x0000FF |     0, 0, 255 |
		| Yellow  | 0xFFFF00 |   255, 255, 0 |
		| Cyan    | 0x00FFFF |   0, 255, 255 |
		| Magenta | 0xFF00FF |   255, 0, 255 |
		| Silver  | 0xC0C0C0 | 192, 192, 192 |
		| Gray    | 0x808080 | 128, 128, 128 |
		| Maroon  | 0x800000 |     128, 0, 0 |
		| Olive   | 0x808000 |   128, 128, 0 |
		| Green   | 0x008000 |     0, 128, 0 |
		| Purple  | 0x800080 |   128, 0, 128 |
		| Teal    | 0x008080 |   0, 128, 128 |
		| Navy    | 0x000080 |     0, 0, 128 |
		|---------|----------|---------------|
		'

	.EXAMPLE 

		$DateType = ConvertFrom-SourceTable '
		Type                   Value                      PowerShell Output
		----      ------------------                     ----------- ---------------------
		String    Hello World                          "Hello World" Hello World
		Number                   123                             123                   123
		Null                    Null                           $Null  
		Boolean                 True                           $True True
		Boolean                False                          $False False
		DateTime  D 1963-10-07T21:47    [DateTime]"1963-10-07 21:47" 1963-10-07 9:47:00 PM
		Array               1, "Two"                     @(1, "Two") {1, two}
		HashTable    @{One=1; Two=2}                 @{One=1; Two=2} {One, Two}
		Object     O @{One=1; Two=2} [PSCustomObject]@{One=1; Two=2} @{One=1; Two=2}
		'

	.EXAMPLE 

		$Directory = ConvertFrom-SourceTable '
		Mode    [DateTime]LastWriteTime         Length Name
		----    -----------------------         ------ ----
		-a---l  2018-04-16   7:15 PM              4071 ConvertFrom-Table.Tests.ps1
		-a---l  2018-04-22   9:19 PM              3104 ConvertFrom-Table.ps1
		'

	.LINK
		https://github.com/iRon7/ConvertFrom-SourceTable
#>
Function ConvertFrom-SourceTable {
	[OutputType([Object[]])]Param (
		[Parameter(ValueFromPipeLine = $True)][String[]]$Table,
		[Char]$HorizontalRuler = '-', [Char]$VerticalRuler = '|', [Switch]$Markdown
	)
	Begin {
		Function Null {$Null}; Function True {$True}; Function False {$False};	# Wrappers
		Function O([HashTable]$Property) {New-Object PSObject -Property $Property}
		Set-Alias D Get-Date
		$HRx = "\x{0:X2}" -f [Int]$HorizontalRuler; $VRx = "\x{0:X2}" -f [Int]$VerticalRuler
		$RulerPattern = "^[$HRx$VRx\s]*$HRx[$HRx$VRx\s]*$"
		$Header, $Ruler = $Null; $RowIndex = 0; $Columns = @(); $Property = @{}
		Function Slice([Int]$Start, [Int]$End = [Int]::MaxValue, [Parameter(ValueFromPipeLine = $True, Mandatory = $True)][String]$String) {
			If ($Start -lt 0) {$End += $Start; $Start = 0}
			If ($End -gt 0 -and $Start -lt $String.Length) {
				If ($End -lt $String.Length) {$String.Substring($Start, $End - $Start + 1)} Else {$String.Substring($Start)}
			} Else {$Null}
		}
		Function Fit([String]$Line) {
			For ($i = 0; $i -lt $Columns.Length; $i++) {$Column = @($Columns)[$i]
				$Min = If ($i -gt 0) {$Columns[$i - 1].End + 2} Else {0}
				While ($Column.Start -gt $Min -and $Line[$Column.Start - 1] -Match '\S') {$Column.Start--}
				$Max = If ($i -lt $Columns.Length - 1) {$Columns[$i + 1].Start - 2} Else {$Line.Length}
				While ($Column.End -lt $Max -and $Line[$Column.End + 1] -Match '\S') {$Column.End++}
				$Column.Right = $Header[$Column.Start] -Match '\s' -and $Header[$Column.End] -Match '\S'
			}
		}
		Function TypeName($TypeName) {
			$Null = $TypeName -Match "(\[(.*)\])?(.+)"
			$Matches[2], $Matches[3].Trim()
		}
		Function ErrorRecord($Row) {
			$ErrorRecord = $_.Exception.ErrorRecord
			$Exception = New-Object System.InvalidOperationException @"
$($_.Exception.Message)
At column '$($Column.Name)' in $(&{If($RowIndex) {"data row $RowIndex"} Else {"the header row"}})
+ $($Row -Replace "[\s]", " ")
+ $(" " * $Column.Start)$("~" * ($Column.End - $Column.Start + 1))
"@
			New-Object Management.Automation.ErrorRecord $Exception,
				$ErrorRecord.FullyQualifiedErrorId,
				$ErrorRecord.CategoryInfo.Category,
				$ErrorRecord.TargetObject
		}
	}
	Process {
		$Table | ForEach-Object {
			$Lines = $_ -Split '[\r\n]+'
			$Head = 0; $Count = 0
			ForEach ($Line in $Lines) {
				If ($Line -Match $RulerPattern) {$Ruler = $Line}
				ElseIf ($Header) {
					If (!$Columns) {
						If (!$Ruler) {$Ruler = $Header}
						If (!$MyInvocation.BoundParameters.Markdown.IsPresent) {$Markdown = $Header -Match $VRx}
						If ($Markdown) {
							$Margin = $Header -NotMatch "\w$VRx|$VRx\w"
							$Columns = ForEach ($Match in ($Header | Select-String "[^$VRx]+\w[^$VRx]+" -AllMatches).Matches) {
								$Column = @{Value = $Null; Start = $Match.Index + $Margin; End = $Match.Index + $Match.Length - 1 - $Margin; Right = $null}
								$Column.Type, $Column.Name = TypeName $Match.Value.Trim()
								$Column.Right = $Header[$Column.Start] -Match '\s' -and $Header[$Column.End] -Match '\S'
								If ($Column.Type) {$Column.Type = Try {[Type]$Column.Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
								$Column
							}
						} Else {
							$Columns = ForEach ($Match in (&{If ($Ruler) {$Ruler} Else {$Header}} | Select-String "\S+" -AllMatches).Matches) {
								$Column = @{Value = $Null; Start = $Match.Index; End = $Match.Index + $Match.Length - 1; Right = $null}
								$Column.Type, $Column.Name = TypeName ($Header | Slice $Column.Start $Column.End).Trim()
								If ($Column.Type) {$Column.Type = Try {[Type]$Column.Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
								$Column
							}
							If (!$Ruler) {Fit $Header}
						}
						$Head = $Count
					}
					If (!$Markdown) {Fit $Line}
				} ElseIf ($Line.Trim()) {$Header = $Line}
				$Count++
			}
			ForEach ($Line in ($Lines | Select-Object -Skip $Head)) {
				If ($Columns -and $Line.Trim()) {
					If ($Line -NotMatch $RulerPattern) {
						$RowIndex++
						ForEach($Column in $Columns) {
							$Field = $Line | Slice $Column.Start $Column.End
							$Property[$Column.Name] =
								If ($Field -is [String]) {
									$Value = $Field.Trim()
									If ($Value -gt "") {
										If ($Field -Match '\S$' -and ($Field -Match '^\s' -or $Column.Right)) {
											Try {Invoke-Expression $Value} 
											Catch {$Value; Write-Error -ErrorRecord (ErrorRecord)}
										} ElseIf ($Column.Type) {
											Try {Invoke-Expression "[$($Column.Type)]'$Value'"} 
											Catch {$Value; Write-Error -ErrorRecord (ErrorRecord $Row)}
										} Else {$Value}
									} Else {$Value}
								} Else {$Field}
						}
						New-Object PSObject -Property $Property
					}
				}
			}
		}
	}
}; Set-Alias cfst ConvertFrom-SourceTable
