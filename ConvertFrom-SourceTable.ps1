<#PSScriptInfo
.VERSION 0.3.12
.GUID 0019a810-97ea-4f9a-8cd5-4babecdc916b
.AUTHOR iRon
.DESCRIPTION Converts a fixed column table to objects.
.COMPANYNAME
.COPYRIGHT
.TAGS Read Input Convert Resource Table Format MarkDown
.LICENSE https://github.com/iRon7/ConvertFrom-SourceTable/LICENSE.txt
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
    Converts a fixed column table to objects.

    .DESCRIPTION
    The ConvertFrom-SourceTable cmdlet creates objects from a fixed column
    source table (format-table) possibly surrounded by horizontal and/or
    vertical rulers. The ConvertFrom-SourceTable cmdlet supports most data
    types using the following formatting and alignment rules:

        Data that is left aligned will be parsed to the generic column type
        which is a string by default.

        Data that is right aligned will be evaluated.

        Data that is justified (using the full column with) is following the
        the header alignment and evaluated if the header is right aligned.

        The default column type can be set by prefixing the column name with
        a standard (PowerShell) cast operator (a data type enclosed in
        square brackets, e.g.: "[Int]ID")

    Definitions:
        The width of a source table column is outlined by the header width,
        the ruler width and the width of the data.

        Column and Data alignment (none, left, right or justified) is defined
        by the existence of a character at the start or end of a column.

        Column alignment (which is used for a default field alignment) is
        defined by the first and last character or space of the header and
        the ruler of the outlined column.

    .PARAMETER InputObject
        Specifies the source table strings to be converted to objects.
        Enter a variable that contains the source table strings or type a
        command or expression that gets the source table strings.
        You can also pipe the source table strings to ConvertFrom-SourceTable.

        Note that streamed table rows are intermediately processed and
        released for the next cmdlet. In this mode, there is a higher
        possibility that floating tables or column data cannot be determined
        to be part of a specific column (as there is no overview of the table
        data that follows). To resolve this, use one of the folowing ruler or
        header specific parameters.

    .PARAMETER Header
        A string that defines the header line of an headless table or a multiple
        strings where each item represents the column name.
        In case the header contains a single string, it is used to define the
        (property) names, the size and alignment of the column, therefore it is
        key that the columns names are properly aligned with the rest of the
        column (including any table indents).
        If the header contains multiple strings, each string will be used to
        define the property names of each object. In this case, column alignment
        is based on the rest of the data and possible ruler.

    .PARAMETER Ruler
        A string that replaces any (horizontal) ruler in the input table which
        helps to define character columns in occasions where the table column
        margins are indefinable.

    .PARAMETER HorizontalDash
        This parameter (Alias -HDash) defines the horizontal ruler character.
        By default, each streamed table row (or a total raw table) will be
        searched for a ruler existing out of horizontal dash characters ("-"),
        spaces and possible vertical dashes. If the ruler is found, the prior
        line is presumed to be the header. If the ruler is not found within
        the first (two) streamed data lines, the first line is presumed the
        header line.
        If -HorizontalDash explicitly defined, all (streamed) lines will be
        searched for a matching ruler.
        If -HorizontalDash is set to `$Null`, the first data line is presumed
        the header line (unless the -VerticalDash parameter is set).

    .PARAMETER VerticalDash
        This parameter (Alias -VDash) defines the vertical ruler character.
        By default, each streamed table row (or a total raw table) will be
        searched for a header with vertical dash characters ("|"). If the
        header is not found within the first streamed data line, the first
        line is presumed the header line.
        If -VerticalDash explicitly defined, all (streamed) lines will be
        searched for a header with a vertical dash character.
        If -VerticalDash is set to `$Null`, the first data line is presumed
        the header line (unless the -HorizontalDash parameter is set).

    .PARAMETER Junction
        The -Junction parameter (default: "+") defines the character used for
        the junction between the horizontal ruler and vertical ruler.

    .PARAMETER Anchor
        The -Anchor parameter (default: ":") defines the character used for
        the alignedment anchor. If used in the header row, it will be used to
        define the default alignment, meaning that justified (full width)
        values will be evaluted.

    .PARAMETER Omit
        A string of characters to omit from the header and data. Each omitted
        character will be replaced with a space.

    .PARAMETER Literal
        The -Literal parameter will prevent any right aligned data to be
        evaluated.

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
        [Parameter(ValueFromPipeLine = $True)][String[]]$InputObject, [String[]]$Header, [String]$Ruler,
        [Alias("HDash")][Char]$HorizontalDash = '-', [Alias("VDash")][Char]$VerticalDash = '|',
        [Char]$Junction = '+', [Char]$Anchor = ':', [String]$Omit, [Switch]$Literal
    )
    Begin {
        Enum Alignment {None; Left; Right; Justified}
        Enum Mask {All = 8; Header = 4; Ruler = 2; Data = 1}
        $Auto = !$PSBoundParameters.ContainsKey('HorizontalDash') -and !$PSBoundParameters.ContainsKey('VerticalDash')
        $HRx = If ($HorizontalDash) {'\x{0:X2}' -f [Int]$HorizontalDash}
        $VRx = If ($VerticalDash)   {'\x{0:X2}' -f [Int]$VerticalDash}
        $JNx = If ($Junction)       {'\x{0:X2}' -f [Int]$Junction}
        $ANx = If ($Anchor)         {'\x{0:X2}' -f [Int]$Anchor}
        $RulerPattern = If ($VRx) {"^[$HRx$VRx$JNx$ANx\s]*$HRx[$HRx$VRx$JNx$ANx\s]*$"} ElseIf ($HRx) {"^[$HRx\s]*$HRx[$HRx\s]*$"} Else {'\A(?!x)x'}
        If (!$PSBoundParameters.ContainsKey('Ruler') -and $HRx) {Remove-Variable 'Ruler'; $Ruler = $Null}
        If (!$Ruler -and !$HRx -and !$VRx) {$Ruler = ''}
        If ($Ruler) {$Ruler = $Ruler -Split '[\r\n]+' | Where-Object {$_.Trim()} | Select-Object -First 1}
        $HeaderLine = If (@($Header).Count -gt 1) {''} ElseIf ($Header) {$Header}
        $TopLine = If ($HeaderLine) {''}
        $LastLine, $OuterLeftColumn, $OuterRightColumn, $Mask = $Null
        $RowIndex = 0; $Padding = 0; $Columns = New-Object Collections.Generic.List[HashTable]
        $Property = New-Object System.Collections.Specialized.OrderedDictionary								# Include support from PSv2
        Function Null {$Null}; Function True {$True}; Function False {$False};								# Wrappers
        Function Debug-Column {
            If ($VRx) {Write-Debug $Mask}
            Else {Write-Debug (($Mask | ForEach-Object {If ($_) {'{0:x}' -f $_} Else {' '}}) -Join '')}
            $CharArray = (' ' * ($Columns[-1].End + 1)).ToCharArray()
            For ($i = 0; $i -lt $Columns.Count; $i++) {$Column = $Columns[$i]
                For ($c = $Column.Start + $Padding; $c -le $Column.End - $Padding; $c++) {$CharArray[$c] = '-'}
                $CharArray[($Column.Start + $Column.End) / 2] = "$i"[-1]
                If ($Column.Alignment -bAnd [Alignment]::Left)  {$CharArray[$Column.Start + $Padding] = ':'}
                If ($Column.Alignment -bAnd [Alignment]::Right) {$CharArray[$Column.End - $Padding]   = ':'}
            }
            Write-Debug ($CharArray -Join '')
        }
        Function Mask([String]$Line, [Byte]$Or = [Mask]::Data) {
            $Init = [Mask]::All * ($Null -eq $Mask)
            If ($Init) {([Ref]$Mask).Value = New-Object Collections.Generic.List[Byte]}
            For ($i = 0; $i -lt ([Math]::Max($Mask.Count, $Line.Length)); $i++) {
                If ($i -ge $Mask.Count) {([Ref]$Mask).Value.Add($Init)}
                $Mask[$i] = If ($Line[$i] -Match '\S') {$Mask[$i] -bOr $Or} Else {$Mask[$i] -bAnd (0xFF -bXor [Mask]::All)}
            }
        }
        Function Slice([String]$String, [Int]$Start, [Int]$End = [Int]::MaxValue) {
            If ($Start -lt 0) {$End += $Start; $Start = 0}
            If ($End -ge 0 -and $Start -lt $String.Length) {
                If ($End -lt $String.Length) {$String.Substring($Start, $End - $Start + 1)} Else {$String.Substring($Start)}
            } Else {$Null}
        }
        Function TypeName([String]$TypeName) {
            If ($Literal) {
                $Null, $TypeName.Trim()
            } Else {
                $Null = $TypeName.Trim() -Match '(\[(.*)\])?\s*(.*)'
                $Matches[2]
                If($Matches[3]) {$Matches[3]} Else {$Matches[2]}
            }
        }
        Function ErrorRecord($Line, $Start, $End, $Message) {
            $Exception = New-Object System.InvalidOperationException "
$Message
+ $($Line -Replace '[\s]', ' ')
+ $(' ' * $Start)$('~' * ($End - $Start + 1))
"
            New-Object Management.Automation.ErrorRecord $Exception,
                $_.Exception.ErrorRecord.FullyQualifiedErrorId,
                $_.Exception.ErrorRecord.CategoryInfo.Category,
                $_.Exception.ErrorRecord.TargetObject
        }
    }
    Process {
        $Lines = $InputObject -Split '[\r\n]+'
        If ($Omit) {
            $Lines = @(ForEach ($Line in $Lines) {
                ForEach ($Char in [Char[]]$Omit) {$Line = $Line.Replace($Char, ' ')}
                $Line
            })
        }
        $NextIndex, $DataIndex = $Null
        If (!$Columns) {
            For ($Index = 0; $Index -lt $Lines.Length; $Index++) {
                $Line = $Lines[$Index]
                If ($Line.Trim()) {
                    If ($Null -ne $HeaderLine) {
                        If ($Null -ne $Ruler) {
                            If ($Line -NotMatch $RulerPattern) {$DataIndex = $Index}
                        } Else {
                            If ($Line -Match $RulerPattern) {$Ruler = $Line}
                            Else {
                                $Ruler = ''
                                $DataIndex = $Index
                            }
                        }
                    } Else {
                        If ($Null -ne $Ruler) {
                            If ($LastLine -and (!$VRx -or $Ruler -NotMatch $VRx -or $LastLine -Match $VRx) -and $Line -NotMatch $RulerPattern) {
                                $HeaderLine = $LastLine
                                $DataIndex = $Index
                            }
                        } Else {
                            If (!$RulerPattern) {
                                $HeaderLine = $Line
                            } ElseIf ($LastLine -and (!$VRx -or $Line -NotMatch $VRx -or $LastLine -Match $VRx) -and $Line -Match $RulerPattern) {
                                $HeaderLine = $LastLine
                                If (!$Ruler) {$Ruler = $Line}
                            }
                        }
                    }
                    If ($Line -NotMatch $RulerPattern) {
                        If ($VRx -and $Line -Match $VRx -and $TopLine -NotMatch $VRx) {$TopLine = $Line; $NextIndex = $Null}
                        ElseIf ($Null -eq $TopLine) {$TopLine = $Line}
                        ElseIf ($Null -eq $NextIndex) {$NextIndex = $Index}
                        $LastLine = $Line
                    }
                    If ($DataIndex) {Break}
                }
            }
            If (($Auto -or ($VRx -and $TopLine -Match $VRx)) -and $Null -ne $NextIndex) {
                If ($Null -eq $HeaderLine) {
                    $HeaderLine = $TopLine
                    If ($Null -eq $Ruler) {$Ruler = ''}
                    $DataIndex = $NextIndex
                } ElseIf ($Null -eq $Ruler) {
                    $Ruler = ''
                    $DataIndex = $NextIndex
                }
            }
            If ($Null -ne $DataIndex) {
                $HeaderLine = $HeaderLine.TrimEnd()
                If ($TopLine -NotMatch $VRx) {
                    $VRx = ''
                    If ($Ruler -NotMatch $ANx) {$ANx = ''}
                }
                If ($VRx) {
                    $Index = 0; $Start = 0; $Length = $Null; $Padding = [Int]::MaxValue
                    If ($Ruler) {
                        $Start = $Ruler.Length - $Ruler.TrimStart().Length
                        If ($Ruler.Length -gt $HeaderLine.Length) {$HeaderLine += ' ' * ($Ruler.Length - $HeaderLine.Length)}
                    }
                    $Mask = '?' * $Start
                    ForEach ($Column in ($HeaderLine.SubString($Start) -Split $VRx)) {
                        If ($Null -ne $Length) {$Mask += '?' * $Length + $VerticalDash}
                        $Length = $Column.Length
                        $Type, $Name = If (@($Header).Count -le 1) {TypeName $Column.Trim()}
                                       ElseIf ($Index -lt @($Header).Count) {TypeName $Header[$Index]}
                        If ($Name) {
                            $End = $Start + $Length - 1
                            $Padding = [Math]::Min($Padding, $Column.Length - $Column.TrimStart().Length)
                            If ($Ruler -or $End -lt $HeaderLine.Length -1) {$Padding = [Math]::Min($Padding, $Column.Length - $Column.TrimEnd().Length)}
                            $Columns.Add(@{Index = $Index; Name = $Column; Type = $Null; Start = $Start; End = $End})
                            $Property.Add($Name, $Null)
                        }
                        $Index++; $Start += $Column.Length + 1
                    }
                    $Mask += '*'
                    ForEach ($Column in $Columns) {
                        $Anchored = $Ruler -and $ANx -and $Ruler -Match $ANx
                        If (!$Ruler) {
                            If ($Column.Start -eq 0) {
                                $Column.Start = [Math]::Max($HeaderLine.Length - $HeaderLine.TrimStart().Length - $Padding, 0)
                                $OuterLeftColumn = $Column
                            } ElseIf ($Column.End -eq $HeaderLine.Length -1) {
                                $Column.End = $HeaderLine.TrimEnd().Length + $Padding
                                $OuterRightColumn = $Column
                            }
                        }
                        $Column.Type, $Column.Name = TypeName $Column.Name.Trim()
                        If ($Anchored) {
                            $Column.Alignment = [Alignment]::None
                            If ($Ruler[$Column.Start] -Match $ANx) {$Column.Alignment = $Column.Alignment -bor [Alignment]::Left}
                            If ($Ruler[$Column.End]   -Match $ANx) {$Column.Alignment = $Column.Alignment -bor [Alignment]::Right}
                        } Else {
                            $Column.Alignment = [Alignment]::Justified
                            If ($HeaderLine[$Column.Start + $Padding] -NotMatch '\S') {$Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Left}
                            If ($HeaderLine[$Column.End   - $Padding] -NotMatch '\S') {$Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Right}
                        }
                    }
                } Else {
                    Mask $HeaderLine ([Mask]::Header)
                    If ($Ruler) {Mask $Ruler ([Mask]::Ruler)}
                    $Lines | Select-Object -Skip $DataIndex | Where-Object {$_.Trim()} | Foreach-Object {Mask $_}
                    If (!$Ruler -and $HRx) {									# Connect (rulerless) single spaced headers where either column is empty
                        $InWord = $False; $WordMask = 0
                        For ($i = 0; $i -le $Mask.Count; $i++) {
                            If($i -lt $Mask.Count) {$WordMask = $WordMask -bor $Mask[$i]}
                            $Masked = $i -lt $Mask.Count -and $Mask[$i]
                            If ($Masked -and !$InWord) {$InWord = $True; $Start = $i}
                            ElseIf (!$Masked -and $InWord) {
                                $InWord = $False; $End = $i - 1
                                If ([Mask]::Header -eq $WordMask -bAnd 7) {		# only header
                                    If ($Start -ge 2 -and $Mask[$Start - 2] -band [Mask]::Header) {$Mask[$Start - 1] = [Mask]::Header}
                                    ElseIf (($End + 2) -lt $Mask.Count -and $Mask[$End + 2] -band [Mask]::Header) {$Mask[$End + 1] = [Mask]::Header}
                                }
                                $WordMask = 0
                            }
                        }
                    }
                    $InWord = $False; $Index = 0; $Start = $Null
                    For ($i = 0; $i -le $Mask.Count; $i++) {
                        $Masked = $i -lt $Mask.Count -and $Mask[$i]
                        If ($Masked -and !$InWord) {$InWord = $True; $Start = $i; $WordMask = 0}
                        ElseIf ($InWord) {
                            $WordMask = $WordMask -bor $Mask[$i]
                            If (!$Masked) {
                                $InWord = $False; $End = $i - 1
                                $WordMask = $WordMask -bor $Mask[$i]
                                $Type, $Name = If (@($Header).Count -le 1) {TypeName "$(Slice -String $HeaderLine -Start $Start -End $End)".Trim()}
                                               ElseIf ($Index -lt @($Header).Count) {TypeName $Header[$Index]}
                                If ($Name) {
                                    If ($Columns.Where{$_.Name -eq $Name}) {Write-Warning "Duplicate column name: $Name."}
                                    Else {
                                        If ($Type) {
                                            $Type = Try {[Type]$Type} Catch {
                                                Write-Error -ErrorRecord (ErrorRecord -Line $HeaderLine -Start $Start -End $End -Message (
                                                    "Unknown type {0} in header at column '{1}'" -f $Type, $Name
                                                ))
                                            }
                                        }
                                        $Columns.Add(@{Index = $Index++; Name = $Name; Type = $Type; Start = $Start; End = $End; Alignment = $Null; Mask = $WordMask})
                                        $Property.Add($Name, $Null)
                                    }
                                }
                            }
                        }
                    }
                }
                $RulerPattern = If ($Ruler) {'^' + ($Ruler -Replace "[^$HRx]", "[$VRx$JNx$ANx\s]" -Replace "[$HRx]", "[$HRx]")} Else {'\A(?!x)x'}
            }
        }
        If ($Columns) {
            If ($VRx) {
                ForEach ($Line in ($Lines | Where-Object {$_ -like $Mask})) {
                    If ($OuterLeftColumn) {
                        $Start = [Math]::Max($Line.Length - $Line.TrimStart().Length - $Padding, 0)
                        If ($Start -lt $OuterLeftColumn.Start) {
                            $OuterLeftColumn.Start = $Start
                            $OuterLeftColumn.Alignment = $Column.Alignment -band -bnot [Alignment]::Left
                        }
                    } ElseIf ($OuterRightColumn) {
                        $End = $Line.TrimEnd().Length + $Padding
                        If ($End -gt $OuterRightColumn.End) {
                            $OuterRightColumn.End = $End
                            $OuterRightColumn.Alignment = $Column.Alignment -band -bnot [Alignment]::Right
                        }
                    }
                }
            } Else {
                $HeadMask = If ($Ruler) {[Mask]::Header -bOr [Mask]::Ruler} Else {[Mask]::Header}
                $Lines | Select-Object -Skip (0 + $DataIndex) | Where-Object {$_.Trim()} | Foreach-Object {Mask $_}

                If (!$RowIndex) {
                    For ($c = $Columns.Count - 1; $c -ge 0; $c--) {$Column = $Columns[$c]
                        $MaskStart = $Mask[$Column.Start];         $MaskEnd = $Mask[$Column.End]
                        $HeadStart = $MaskStart -bAnd $HeadMask;   $HeadEnd = $MaskEnd -bAnd $HeadMask
                        $AllStart  = $MaskStart -bAnd [Mask]::All; $AllEnd  = $MaskEnd -bAnd [Mask]::All
                        $IsLeftAligned  = ($HeadStart -eq $HeadMask -and $HeadEnd -ne $HeadMask) -Or ($AllStart -and !$AllEnd)
                        $IsRightAligned = ($HeadStart -ne $HeadMask -and $HeadEnd -eq $HeadMask) -Or (!$AllStart -and $AllEnd)
                        If ($IsLeftAligned)  {$Column.Alignment = $Column.Alignment -bOr [Alignment]::Left}
                        If ($IsRightAligned) {$Column.Alignment = $Column.Alignment -bOr [Alignment]::Right}
                    }
                }

                For ($c = $Columns.Count - 1; $c -ge 0; $c--) {$Column = $Columns[$c]

                    $NextRight = If ($c -lt $Columns.Count) {$Columns[$c + 1]}
                    $MaxEnd = If ($NextRight) {$NextRight.Start - 2} Else {$Mask.Count - 1}
                    For ($i = $Column.End + 1; $i -le $MaxEnd; $i++) {
                        If ($Mask[$i]) {
                            $Column.End = $i
                            $Column.Alignment = $Column.Alignment -bor [Alignment]::Left
                         } Else {Break}
                    }

                    $NextLeft = If ($c -gt 0) {$Columns[$c - 1]}
                    $MinStart = If ($NextLeft) {$NextLeft.End + 2} Else {0}
                    For ($i = $Column.Start - 1; $i -ge $MinStart; $i--) {
                        If ($Mask[$i]) {
                            $Column.Start = $i
                            $Column.Alignment = $Column.Alignment -bor [Alignment]::Right
                        } Else {Break}
                    }
                }

                For ($c = 0; $c -lt $Columns.Count; $c++) {$Column = $Columns[$c]

                    If ($Column.Alignment -ne [Alignment]::Left) {
                        $NextLeft = If ($c -gt 0) {$Columns[$c - 1]}
                        $MinStart = If ($NextLeft) {$NextLeft.End + 2} Else {0}
                        $Start = $Null
                        For ($i = $Column.Start - 1; $i -ge $MinStart; $i--) {
                            If ($Mask[$i]) {$Start = $i}
                            ElseIf ($Null -ne $Start) {
                                $Column.Start = $Start; $Start = $Null
                                $Column.Alignment = $Column.Alignment -bor [Alignment]::Right
                            }
                        }
                        If ($Null -ne $Start) {
                            $Column.Start = $Start; $Start = $Null
                            $Column.Alignment = $Column.Alignment -bor [Alignment]::Right
                        }
                    }

                    If ($Column.Alignment -ne [Alignment]::Right) {
                        $NextRight = If ($c -lt $Columns.Count) {$Columns[$c + 1]}
                        $MaxEnd = If ($NextRight) {$NextRight.Start - 2} Else {$Mask.Count - 1}
                        $End = $Null
                        For ($i = $Column.End + 1; $i -le $MaxEnd; $i++) {
                            If ($Mask[$i]) {$End = $i}
                            ElseIf ($Null -ne $End) {
                                $Column.End = $End; $End = $Null
                                $Column.Alignment = $Column.Alignment -bor [Alignment]::Left
                            }
                        }
                        If ($Null -ne $End) {
                            $Column.End = $End; $End = $Null
                            $Column.Alignment = $Column.Alignment -bor [Alignment]::Left
                        }
                    }
                }
            }
            If ($DebugPreference -ne 'SilentlyContinue' -and !$RowIndex) {Write-Debug ($HeaderLine -Replace '\s', ' '); Debug-Column}
            ForEach ($Line in ($Lines | Select-Object -Skip ([Int]$DataIndex))) {
                If ($Line.Trim() -and ($Line -NotMatch $RulerPattern)) {
                    $RowIndex++
                    If ($DebugPreference -ne 'SilentlyContinue') {Write-Debug ($Line -Replace '\s', ' ')}
                    $Fields = If ($VRx -and $Line -notlike $Mask) {$Line -Split $VRx}
                    ForEach($Column in $Columns) {
                        $Property[$Column.Name] = If ($Fields) {
                            $Fields[$Column.Index].Trim()
                        } Else {
                            $Field = Slice -String $Line -Start $Column.Start -End $Column.End
                            If ($Field -is [String]) {
                                $Tail = $Field.TrimStart()
                                $Value = $Tail.TrimEnd()
                                If (!$Literal -and $Value -gt '') {
                                    $IsLeftAligned  = $Field.Length - $Tail.Length -eq $Padding
                                    $IsRightAligned = $Tail.Length - $Value.Length -eq $Padding
                                    $Alignment = If ($IsLeftAligned -ne $IsRightAligned) {
                                         If ($IsLeftAligned) {[Alignment]::Left} Else {[Alignment]::Right}
                                    } Else {$Column.Alignment}
                                    If ($Alignment -eq [Alignment]::Right) {
                                        Try {&([Scriptblock]::Create($Value))}
                                        Catch {$Value
                                            Write-Error -ErrorRecord (ErrorRecord -Line $Line -Start $Column.Start -End $Column.End -Message (
                                                "The expression '{0}' in row {1} at column '{2}' can't be evaluated. Check the syntax or use the -Literal switch." -f $Value, $RowIndex, $Column.Name
                                            ))
                                        }
                                    } ElseIf ($Column.Type) {
                                        Try {&([Scriptblock]::Create("[$($Column.Type)]`$Value"))}
                                        Catch {$Value
                                            Write-Error -ErrorRecord (ErrorRecord -Line $Line -Start $Column.Start -End $Column.End -Message (
                                                "The value '{0}' in row {1} at column '{2}' can't be converted to type {1}." -f $Valuee, $RowIndex, $Column.Name, $Column.Type
                                            ))
                                        }
                                    } Else {$Value}
                                } Else {$Value}
                            } Else {''}
                        }
                    }
                    New-Object PSObject -Property $Property
                }
            }
            If ($DebugPreference -ne 'SilentlyContinue' -and $RowIndex) {Debug-Column}
        }
    }
}; Set-Alias cfst ConvertFrom-SourceTable
