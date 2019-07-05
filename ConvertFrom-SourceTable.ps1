<#PSScriptInfo
.VERSION 0.2.6
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

[CmdletBinding()]Param()
Function ConvertFrom-SourceTable {
<#
	.SYNOPSIS
	Converts a source table (format-table) or markdown table to objects.

	.DESCRIPTION
	The ConvertFrom-SourceTable cmdlet creates objects from a fixed column
	source table (format-table) or markdown table. The ConvertFrom-SourceTable
	cmdlet supports most data types using the following formatting and alignment
	rules:
		Data that is left aligned will be parsed to the generic column type
		which is a string by default.

		The generic column type can be set by prefixing the column name with
		a standard (PowerShell) cast operator (a data type enclosed in
		square brackets, e.g.: "[Int]ID")

		Data that is right aligned will be evaluated.

	Definitions:
		The width of a source table column is outlined by the header width,
		the ruler width and the width of the data.

		Data alignment is defined by the first and last character or space
		in field of the outlined column.

		Column alignment (which is used for a default field alignment) is
		defined by the first and last character or space of the header and
		the ruler of the outlined column.

	.PARAMETER InputObject
		Specifies the source table strings to be converted to objects.
		Enter a variable that contains the source table strings or type a
		command or expression that gets the source table strings.
		You can also pipe the source table strings to ConvertFrom-SourceTable.

		Note that piped table data strings are intermediately processed and
		released for the next cmdlet. In this mode, there is a higher
		possibility that floating data can't be determined to be part of
		a specific column (as there is no overview of the table data that
		follows). To resolve this use the -Ruler parameter.

	.PARAMETER Header
		A string that defines the header line of an headless table. The header
		is used to define the (property) names, the size and alignment of the
		column, therefore it is key that the columns names are properly aligned
		with the rest of the column (including any table indents).
		The -Header parameter might also include the ruler functionality by
		omitting any ruler. In this case, all the horizontal ruler characters
		will be replaced by spaces.

	.PARAMETER Ruler
		A string that replaces any ruler in the input table which helps to
		define character columns in occasions where the table column margins
		are indefinable.

	.PARAMETER HorizontalRuler
		Defines the horizontal ruler character. The default is a hyphen ("-").

	.PARAMETER VerticalRuler
		Defines the vertical ruler character. The default is a vertical line ("|").

	.PARAMETER Literal
		The -Literal parameter will prevent any right aligned data to be evaluated.

	.PARAMETER Markdown
		Threats the input table as a markdown table (-Markdown) or a source
		table (-Markdown:$False). By default, this parameter is automatically
		defined based on the existence of a vertical ruler character in the
		header.

	.PARAMETER Floating
		By default introductions in floating tables with a ruler that are not
		streamed through the pipeline are automatically skipped.
		If the -Floating switch is provided for for a pipeline input, the
		streaming of objects will start at the ruler (streamed floating tables
		can't be rulerless).
		If the floating is explicitly disabled (-Floating:$False), the header
		is presumed to be on the first line, even if the table is not streamed.

	.EXAMPLE

		$Colors = ConvertFrom-SourceTable '
		Name       Value         RGB
		----       -----         ---
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

		PS C:\> $Colors | Where {$_.Name -eq "Red"}

		Name    Value RGB
		----    ----- ---
		Red  16711680 {255, 0, 0}

	.EXAMPLE

		$Employees = ConvertFrom-SourceTable '
		| Department  | Name    | Country |
		| ----------- | ------- | ------- |
		| Sales       | Aerts   | Belgium |
		| Engineering | Bauer   | Germany |
		| Sales       | Cook    | England |
		| Engineering | Duval   | France  |
		| Marketing   | Evans   | England |
		| Engineering | Fischer | Germany |
		'

	.EXAMPLE

		$ChangeLog = ConvertFrom-SourceTable '
		[Version] [DateTime]Date Author      Comments
		--------- -------------- ------      --------
		0.0.10    2018-05-03     Ronald Bode First design
		0.0.20    2018-05-09     Ronald Bode Pester ready version
		0.0.21    2018-05-09     Ronald Bode removed support for String[] types
		0.0.22    2018-05-24     Ronald Bode Better "right aligned" definition
		0.0.23    2018-05-25     Ronald Bode Resolved single column bug
		0.0.24    2018-05-26     Ronald Bode Treating markdown table input as an option
		0.0.25    2018-05-27     Ronald Bode Resolved error due to blank top lines
		'

	.EXAMPLE

		$Files = ConvertFrom-SourceTable -Literal '
		Mode                LastWriteTime         Length Name
		----                -------------         ------ ----
		d----l       11/16/2018   8:30 PM                Archive
		-a---l        5/22/2018  12:05 PM          (726) Build-Expression.ps1
		-a---l       11/16/2018   7:38 PM           2143 CHANGELOG
		-a---l       11/17/2018  10:42 AM          14728 ConvertFrom-SourceTable.ps1
		-a---l       11/17/2018  11:04 AM          23909 ConvertFrom-SourceTable.Tests.ps1
		-a---l         8/4/2018  11:04 AM         (6237) Import-SourceTable.ps1
		'

	.LINK
		Online Version: https://github.com/iRon7/ConvertFrom-SourceTable
#>
	[CmdletBinding()][OutputType([Object[]])]Param (
		[Parameter(ValueFromPipeLine = $True)][String[]]$InputObject, [String]$Header, [String]$Ruler,
		[Char]$HorizontalRuler = '-', [Char]$VerticalRuler = '|', [Switch]$Literal, [Switch]$Markdown, [Switch]$Floating
	)
	Begin {
		If (!$PSBoundParameters.ContainsKey('Floating')) {Remove-Variable 'Floating'; $Floating = $Null}	# Tristate ($True/$False/$Null)
		Function Null {$Null}; Function True {$True}; Function False {$False};								# Wrappers
		$Align = @{Left = 1; Right = 2; Center =3}
		$HRx = "\x{0:X2}" -f [Int]$HorizontalRuler; $VRx = "\x{0:X2}" -f [Int]$VerticalRuler
		$RulerPattern = "^[$HRx$VRx\s]*$HRx[$HRx$VRx\s]*$"
		$Mask, $Skip = $Null; $RowIndex = 0; $Columns = @()
		$Property = New-Object System.Collections.Specialized.OrderedDictionary								# Include support from PSv2
		Function Debug-Column {
			If ($Mask) {Write-Debug (($Mask | ForEach-Object {If ($_) {"$_"} Else {" "}}) -Join "")}
			$Length = If ($Mask) {$Mask.Length} Else {$Ruler.Length}
			$ColumnInfo = 1..$Length | ForEach-Object {" "}
			For ($i = 0; $i -lt $Columns.Length; $i++) {$Column = $Columns[$i]
				For ($c = $Column.Start; $c -le $Column.End; $c++) {$ColumnInfo[$c] = "-"}
				$ColumnInfo[($Column.Start + $Column.End) / 2] = "$i"[-1]
				If ($Column.Aligned -eq $Align.Right) {$ColumnInfo[$Column.Start] = "<"}
				If ($Column.Aligned -eq $Align.Left)  {$ColumnInfo[$Column.End]   = ">"}
			}
			Write-Debug ($ColumnInfo -Join "")
		}
		Function Mask([String[]]$Line) {	# Bit 2: Header and Ruler | Bit 1: Header and Ruler and Data | Bit 0: Header or Ruler or Data
			$Line | ForEach-Object {
				$New = $Null -eq $Mask
				If ($New) {([Ref]$Mask).Value = New-Object Byte[] $_.Length}
				$Length = If ($_.Length -gt $Mask.Length) {$_.Length} Else {$Mask.Length}
				For ($i = 0; $i -lt $Length; $i++) {
					If ($i -ge $Mask.Length) {([Ref]$Mask).Value += 0}
					If ($_[$i] -Match '\S') {
						If ($New) {$Mask[$i] = 7}
						Else {$Mask[$i] = $Mask[$i] -bOr 1}
					} Else {$Mask[$i] = $Mask[$i] -bAnd 5}
				}
			}
		}
		Function Slice([String]$String, [Int]$Start, [Int]$End = [Int]::MaxValue) {
			If ($Start -lt 0) {$End += $Start; $Start = 0}
			If ($End -ge 0 -and $Start -lt $String.Length) {
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
		$Lines = $InputObject -Split '[\r\n]+'
		$First, $Last = $Null; $Skip = 0
		If (!$Columns) {
			If ($Null -eq $Floating -and ($Header -or $Ruler)) {$Floating = $False}
			If (!$Header -or !$Ruler) {
				For ($i = 0; $i -lt $Lines.Length; $i++) {$Line = $Lines[$i]
					If ($Line.Trim()) {
						If ($Line -Match $RulerPattern) {
							If ($Header -or $Null -ne $First) {
								If (!$PSBoundParameters.ContainsKey('Ruler')) {$Ruler = $Line}
								Break
							}
						} Else {
							If ($Null -eq $First) {$First = $i}
							$Last = $i
							If ($Floating -eq $False) {Break}
						}
					}
				}
			}
			If ($Null -ne $First) {
				If ($Ruler) {
					If (!$PSBoundParameters.ContainsKey('Header')) {$Header = $Lines[$Last]}
					$Skip = $Last + 1
				} ElseIf ($Floating -eq $False -or ($Null -eq $Floating -and $Last -gt $First)) {
					If (!$Header) {
						$Header = $Lines[$First]
						$Skip = $First + 1
					}
					$Ruler = $Header -Replace '\S', $HorizontalRuler
					$Header = $Header -Replace $HRx, " "
				} Else {
					If (!$PSBoundParameters.ContainsKey('Header')) {$Header = $Lines[$Last]}
				}
			}
			If ($Header -and $Ruler) {
				If (!$PSBoundParameters.ContainsKey('Markdown')) {$Markdown = $Header -Match $VRx}
				If ($Markdown) {
					$Matches = If ($Ruler) {($Ruler | Select-String "$HRx+" -AllMatches).Matches}
						Else {($Header | Select-String "[^$VRx]+\w[^$VRx]+" -AllMatches).Matches}
					ForEach ($Match in $Matches) {
						$Start = $Match.Index; $End = $Match.Index + $Match.Length - 1
						If ($Header[$Start] -NotMatch '\S' -and $Header[$End] -NotMatch '\S') {$Start++; $End--}
						$Type, $Name = TypeName "$(Slice -String $Header -Start $Start -End $End)".Trim()
						$Aligned = If ($Header[$Start] -Match '\S' -and $Header[$End]   -NotMatch '\S') {$Align.Left}
							   ElseIf ($Header[$End]   -Match '\S' -and $Header[$Start] -NotMatch '\S') {$Align.Right}
						If ($Type) {$Type = Try {[Type]$Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
						$Columns += @{Name = $Name; Type = $Type; Start = $Start; End = $End; Aligned = $Aligned}
						$Property.Add($Name, $Null)
					}
				} Else {
					If (!$Mask) {
						Mask $Header, $Ruler
						$Lines | Select-Object -Skip $Skip | Where-Object {$_} | Foreach-Object {Mask $_}
					}
					$InWord = $False; $Start = $Null
					For ($i = 0; $i -le $Mask.Length; $i++) {
						$Masked = $i -lt $Mask.Length -and $Mask[$i]
						If ($Masked -and !$InWord) {$InWord = $True; $Start = $i}
						ElseIf (!$Masked -and $InWord) {$InWord = $False
							$End = $i - 1
							$Type, $Name = TypeName "$(Slice -String $Header -Start $Start -End $End)".Trim()
							If ($Name) {
								If ($Type) {$Type = Try {[Type]$Type} Catch{Write-Error -ErrorRecord (ErrorRecord $Header)}}
								$Columns += @{Name = $Name; Type = $Type; Start = $Start; End = $End; Aligned = $Null}
								$Property.Add($Name, $Null)
							}
						}
					}
				}
			}
		} ElseIf ($Mask) {$Lines | Select-Object -Skip $Skip | Where-Object {$_} | Foreach-Object {Mask $_}}
		If ($Columns) {
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
							$Field = Slice -String $Line -Start $Column.Start -End $Column.End
							$Property[$Column.Name] =
								If ($Field -is [String]) {
									$Value = $Field.Trim()
									If (!$Literal -and $Value -gt "") {
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
}; Set-Alias cfst ConvertFrom-SourceTable
