<#PSScriptInfo
.VERSION 0.1.00
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
		Online Version: https://github.com/iRon7/ConvertFrom-SourceTable
#>
[CmdletBinding()]Param()
Function ConvertFrom-SourceTable {
	[CmdletBinding()][OutputType([Object[]])]Param (
		[Parameter(ValueFromPipeLine = $True)][String[]]$Table,
		[Char]$HorizontalRuler = '-', [Char]$VerticalRuler = '|', [Switch]$Markdown
	)
	Begin {
		Function Null {$Null}; Function True {$True}; Function False {$False};	# Wrappers
		Function O([HashTable]$Property) {New-Object PSObject -Property $Property}
		Set-Alias D Get-Date
		$Align = @{Left = 1; Right = 2; Center =3}
		$HRx = "\x{0:X2}" -f [Int]$HorizontalRuler; $VRx = "\x{0:X2}" -f [Int]$VerticalRuler
		$RulerPattern = "^[$HRx$VRx\s]*$HRx[$HRx$VRx\s]*$"
		$Ruler, $Mask, $Skip = $Null; $IsData = $False; $RowIndex = 0; $Columns = @()
		$Property = New-Object System.Collections.Specialized.OrderedDictionary				# Include support from PSv2
		Function Debug-Column {
			If (!$MarkDown) {Write-Debug (($Mask | ForEach-Object {If ($_) {"$_"} Else {" "}}) -Join "")}
			$Length = If ($MarkDown) {$Ruler.Length} Else {$Mask.Length}
			$ColumnInfo = 1..$Length | ForEach-Object {" "}
			For ($i = 0; $i -lt $Columns.Length; $i++) {$Column = $Columns[$i]
				For ($c = $Column.Start; $c -le $Column.End; $c++) {$ColumnInfo[$c] = "-"}
				$ColumnInfo[($Column.Start + $Column.End) / 2] = "$i"[-1]
				If ($Column.Aligned -eq $Align.Right) {$ColumnInfo[$Column.Start] = "<"}
				If ($Column.Aligned -eq $Align.Left)  {$ColumnInfo[$Column.End]   = ">"}
			}
			Write-Debug ($ColumnInfo -Join "")
		}
		Function Slice([String]$String, [Int]$Start, [Int]$End = [Int]::MaxValue) {
			If ($Start -lt 0) {$End += $Start; $Start = 0}
			If ($End -gt 0 -and $Start -lt $String.Length) {
				If ($End -lt $String.Length) {$String.Substring($Start, $End - $Start + 1)} Else {$String.Substring($Start)}
			} Else {$Null}
		}
		Function TypeName([String]$TypeName) {
			$Null = $TypeName.Trim() -Match '(\[(.*)\])?\s*(.*)'
			$Matches[2], (&{If($Matches[3]) {$Matches[3]} Else {$Matches[2]}})
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
			$Skip = 0
			ForEach ($Line in $Lines) {
				If ($Line.Trim()) {
					$IsHeader = $False; $IsRuler = $Line -Match $RulerPattern
					If ($IsRuler) {}
					ElseIf ($Header) {$IsData = $True}
					Else {
						$IsHeader = $True; $Header = $Line
						If (!$Columns -and !$PSBoundParameters.Markdown.IsPresent) {$Markdown = $Header -Match $VRx}
						If (!$MarkDown) {$Mask = New-Object Byte[] $Header.Length}	# Bit 2: Header and Ruler | Bit 1: Header and Ruler and Data | Bit 0: Header or Ruler or Data
					}
					If ($Null -ne $Mask) {
						$Length = If ($Line.Length -gt $Mask.Length) {$Line.Length} Else {$Mask.Length}
						For ($i = 0; $i -lt $Length; $i++) {
							If ($i -ge $Mask.Length) {$Mask += 0}
							If ($Line[$i] -Match '\S') {
								If ($IsHeader) {$Mask[$i] = 7}
								Else {$Mask[$i] = $Mask[$i] -bOr 1}
							} ElseIf (!$IsHeader) {$Mask[$i] = $Mask[$i] -bAnd 5}
						}
					}
				}
				If (!$IsData) {$Skip++}
			}

			If ($Header) {
				If (!$Columns) {
					If ($Markdown) {
						$Margin = $Header -NotMatch "\w$VRx|$VRx\w"
						ForEach ($Match in ($Header | Select-String "[^$VRx]+\w[^$VRx]+" -AllMatches).Matches) {
							$Column = @{Start = $Match.Index + $Margin; End = $Match.Index + $Match.Length - 1 - $Margin}
							$Column.Type, $Column.Name = TypeName $Match.Value
							If     ($Header[$Column.Start] -Match '\S' -and $Header[$Column.End]   -NotMatch '\S') {$Column.Aligned = $Align.Left}
							ElseIf ($Header[$Column.End]   -Match '\S' -and $Header[$Column.Start] -NotMatch '\S') {$Column.Aligned = $Align.Right}
							If ($Column.Type) {$Column.Type = Try {[Type]$Column.Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
							$Columns += $Column; $Property.Add($Column.Name, $Null)
						}
					} Else {
						$MaskString = ($Mask | ForEach-Object {If ($_) {"X"} Else {" "}}) -Join ""
						ForEach ($Match in ($MaskString | Select-String "X+" -AllMatches).Matches) {
							$Column = @{Start = $Match.Index; End = $Match.Index + $Match.Length - 1}
							$Name = "$(Slice $Header $Column.Start $Column.End)".Trim()
							If ($Name) {
								$Column.Type, $Column.Name = TypeName $Name
								If ($Column.Type) {$Column.Type = Try {[Type]$Column.Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
								$Columns += $Column; $Property.Add($Column.Name, $Null)
							}
						}
					}
				}

				If ($Mask) {
					For ($c = 0; $c -lt $Columns.Length; $c++) {$Column = $Columns[$c]

						$NextRight = If ($c -lt $Columns.Length) {$Columns[$c + 1]}
						$Margin = If ($NextRight) {$NextRight.Start - 2} Else {$Mask.Length - 1}
						$Justify = If ($NextRight) {$NextRight.Aligned -eq $Align.Left} Else {$True}
						If ($Column.Aligned -ne $Align.Right) {
							For ($i = $Column.End + 1; $i -le $Margin; $i++) {If ($Mask[$i]) {$Column.End  = $i} ElseIf (!$Justify) {Break}}
						}

						$NextLeft = If ($c -gt 0) {$Columns[$c - 1]}
						$Margin = If ($NextLeft) {$NextLeft.End + 2} Else {0}
						$Justify = If ($NextLeft) {$NextLeft.Aligned -eq $Align.Right} Else {$True}
						If ($Column.Aligned -ne $Align.Left) {
							For ($i = $Column.Start - 1; $i -ge $Margin; $i--) {If ($Mask[$i]) {$Column.Start = $i} ElseIf (!$Justify) {Break}}
						}

						If (!$Column.Aligned) {
							$IsLeftAligned  = ($Mask[$Column.Start] -bAnd 4) -and !($Mask[$Column.end]   -bAnd 2)
							$IsRightAligned = ($Mask[$Column.end]   -bAnd 4) -and !($Mask[$Column.Start] -bAnd 2)
							If ($IsLeftAligned -ne $IsRightAligned) {$Column.Aligned = If ($IsLeftAligned) {$Align.Left} Else {$Align.Right}}
							If ($Column.Aligned) {If ($c -gt 0) {$c = $c - 2}}
						}
					}
				}

				If ($DebugPreference -ne "SilentlyContinue" -and !$RowIndex) {Write-Debug ($Header -Replace "\s", " "); Debug-Column}
				ForEach ($Line in ($Lines | Select-Object -Skip $Skip)) {
					If ($Columns -and $Line.Trim()) {
						If ($Line -NotMatch $RulerPattern) {
							$RowIndex++
							If ($DebugPreference -ne "SilentlyContinue") {Write-Debug ($Line -Replace "\s", " ")}
							ForEach($Column in $Columns) {
								$Field = Slice $Line $Column.Start $Column.End
								$Property[$Column.Name] =
									If ($Field -is [String]) {
										$Value = $Field.Trim()
										If ($Value -gt "") {
											$IsLeftAligned  = ($Line[$Column.Start] -Match '\S')
											$IsRightAligned = ($Line[$Column.End]   -Match '\S')
											$Aligned = If ($IsLeftAligned -ne $IsRightAligned) {
												 If ($IsLeftAligned) {$Align.Left} Else {$Align.Right}
											} Else {$Column.Aligned}
											If ($Aligned -eq $Align.Right) {
												Try {&([Scriptblock]::Create($Value))}
												Catch {$Value; Write-Error -ErrorRecord (ErrorRecord $Line)}
											} ElseIf ($Column.Type) {
												Try {&([Scriptblock]::Create("[$($Column.Type)]`$Value"))}
												Catch {$Value; Write-Error -ErrorRecord (ErrorRecord $Line)}
											} Else {$Value}
										} Else {$Value}
									} Else {""}
							}
							New-Object PSObject -Property $Property
						}
					}
				}
				If ($DebugPreference -ne "SilentlyContinue" -and $RowIndex) {Debug-Column}
			}
		}
	}
}; Set-Alias cfst ConvertFrom-SourceTable
