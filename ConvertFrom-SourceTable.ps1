<#PSScriptInfo
.VERSION 0.4.0
.GUID 0019a810-97ea-4f9a-8cd5-4babecdc916b
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS Read Input Convert Resource Table Format MarkDown
.LICENSE https://github.com/iRon7/ConvertFrom-SourceTable/LICENSE.txt
.PROJECTURI https://github.com/iRon7/ConvertFrom-SourceTable
.ICON https://raw.githubusercontent.com/iRon7/Join-Object/master/ConvertFrom-SourceTable.png
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

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
[CmdletBinding()][OutputType([Object[]])] param(
    [Parameter(ValueFromPipeLine = $True)] [String[]]$InputObject,[String[]]$Header,[string]$Ruler,
    [Alias("HDash")] [char]$HorizontalDash = '-',[Alias("VDash")] [char]$VerticalDash = '|',
    [char]$Junction = '+',[char]$Anchor = ':',[string]$Omit,[switch]$Literal
)
begin {
    enum Alignment{ None; Left; Right; Justified }
    enum Mask{ All = 8; Header = 4; Ruler = 2; Data = 1 }
    $Auto = !$PSBoundParameters.ContainsKey('HorizontalDash') -and !$PSBoundParameters.ContainsKey('VerticalDash')
    $HRx = if ($HorizontalDash) { '\x{0:X2}' -f [int]$HorizontalDash }
    $VRx = if ($VerticalDash) { '\x{0:X2}' -f [int]$VerticalDash }
    $JNx = if ($Junction) { '\x{0:X2}' -f [int]$Junction }
    $ANx = if ($Anchor) { '\x{0:X2}' -f [int]$Anchor }
    $RulerPattern = if ($VRx) { "^[$HRx$VRx$JNx$ANx\s]*$HRx[$HRx$VRx$JNx$ANx\s]*$" } elseif ($HRx) { "^[$HRx\s]*$HRx[$HRx\s]*$" } else { '\A(?!x)x' }
    if (!$PSBoundParameters.ContainsKey('Ruler') -and $HRx) { Remove-Variable 'Ruler'; $Ruler = $Null }
    if (!$Ruler -and !$HRx -and !$VRx) { $Ruler = '' }
    if ($Ruler) { $Ruler = $Ruler -split '[\r\n]+' | Where-Object { $_.Trim() } | Select-Object -First 1 }
    $HeaderLine = if (@($Header).Count -gt 1) { '' } elseif ($Header) { $Header }
    $TopLine = if ($HeaderLine) { '' }
    $LastLine,$OuterLeftColumn,$OuterRightColumn,$Mask = $Null
    $RowIndex = 0; $Padding = 0; $Columns = New-Object Collections.Generic.List[HashTable]
    $Property = New-Object System.Collections.Specialized.OrderedDictionary             # Include support from PSv2
    function Null { $Null }; function True { $True }; function False { $False };        # Wrappers
    function Debug-Column {
        if ($VRx) { Write-Debug $Mask }
        else { Write-Debug (($Mask | ForEach-Object { if ($_) { '{0:x}' -f $_ } else { ' ' } }) -join '') }
        $CharArray = (' ' * ($Columns[-1].End + 1)).ToCharArray()
        for ($i = 0; $i -lt $Columns.Count; $i++) { $Column = $Columns[$i]
            for ($c = $Column.Start + $Padding; $c -le $Column.End - $Padding; $c++) { $CharArray[$c] = '-' }
            $CharArray[($Column.Start + $Column.End) / 2] = "$i"[-1]
            if ($Column.Alignment -band [Alignment]::Left) { $CharArray[$Column.Start + $Padding] = ':' }
            if ($Column.Alignment -band [Alignment]::Right) { $CharArray[$Column.End - $Padding] = ':' }
        }
        Write-Debug ($CharArray -join '')
    }
    function Mask ([string]$Line,[byte]$Or = [Mask]::Data) {
        $Init = [Mask]::All * ($Null -eq $Mask)
        if ($Init) { ([ref]$Mask).Value = New-Object Collections.Generic.List[Byte] }
        for ($i = 0; $i -lt ([math]::Max($Mask.Count,$Line.Length)); $i++) {
            if ($i -ge $Mask.Count) { ([ref]$Mask).Value.Add($Init) }
            $Mask[$i] = if ($i -lt $Line.Length -and $Line[$i] -match '\S') { $Mask[$i] -bor $Or } else { $Mask[$i] -band (0xFF -bxor [Mask]::All) }
        }
    }
    function Slice ([string]$String,[int]$Start,[int]$End = [int]::MaxValue) {
        if ($Start -lt 0) { $End += $Start; $Start = 0 }
        if ($End -ge 0 -and $Start -lt $String.Length) {
            if ($End -lt $String.Length) { $String.Substring($Start,$End - $Start + 1) } else { $String.Substring($Start) }
        } else { $Null }
    }
    function TypeName ([string]$TypeName) {
        if ($Literal) {
            $Null,$TypeName.Trim()
        } else {
            $Null = $TypeName.Trim() -match '(\[(.*)\])?\s*(.*)'
            $Matches[2]
            if ($Matches[3]) { $Matches[3] } else { $Matches[2] }
        }
    }
    function ErrorRecord ($Line,$Start,$End,$Message) {
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
process {
    $Lines = $InputObject -split '[\r\n]+'
    if ($Omit) {
        $Lines = @(
            foreach ($Line in $Lines) {
                    foreach ($Char in [Char[]]$Omit) { $Line = $Line.Replace($Char,' ') }
                    $Line
            }
        )
    }
    $NextIndex,$DataIndex = $Null
    if (!$Columns) {
        for ($Index = 0; $Index -lt $Lines.Length; $Index++) {
            $Line = $Lines[$Index]
            if ($Line.Trim()) {
                if ($Null -ne $HeaderLine) {
                    if ($Null -ne $Ruler) {
                        if ($Line -notmatch $RulerPattern) { $DataIndex = $Index }
                    } else {
                        if ($Line -match $RulerPattern) { $Ruler = $Line }
                        else {
                            $Ruler = ''
                            $DataIndex = $Index
                        }
                    }
                } else {
                    if ($Null -ne $Ruler) {
                        if ($LastLine -and (!$VRx -or $Ruler -notmatch $VRx -or $LastLine -match $VRx) -and $Line -notmatch $RulerPattern) {
                            $HeaderLine = $LastLine
                            $DataIndex = $Index
                        }
                    } else {
                        if (!$RulerPattern) {
                            $HeaderLine = $Line
                        } elseif ($LastLine -and (!$VRx -or $Line -notmatch $VRx -or $LastLine -match $VRx) -and $Line -match $RulerPattern) {
                            $HeaderLine = $LastLine
                            if (!$Ruler) { $Ruler = $Line }
                        }
                    }
                }
                if ($Line -notmatch $RulerPattern) {
                    if ($VRx -and $Line -match $VRx -and $TopLine -notmatch $VRx) { $TopLine = $Line; $NextIndex = $Null }
                    elseif ($Null -eq $TopLine) { $TopLine = $Line }
                    elseif ($Null -eq $NextIndex) { $NextIndex = $Index }
                    $LastLine = $Line
                }
                if ($DataIndex) { break }
            }
        }
        if (($Auto -or ($VRx -and $TopLine -match $VRx)) -and $Null -ne $NextIndex) {
            if ($Null -eq $HeaderLine) {
                $HeaderLine = $TopLine
                if ($Null -eq $Ruler) { $Ruler = '' }
                $DataIndex = $NextIndex
            } elseif ($Null -eq $Ruler) {
                $Ruler = ''
                $DataIndex = $NextIndex
            }
        }
        if ($Null -ne $DataIndex) {
            $HeaderLine = $HeaderLine.TrimEnd()
            if ($TopLine -notmatch $VRx) {
                $VRx = ''
                if ($Ruler -notmatch $ANx) { $ANx = '' }
            }
            if ($VRx) {
                $Index = 0; $Start = 0; $Length = $Null; $Padding = [int]::MaxValue
                if ($Ruler) {
                    $Start = $Ruler.Length - $Ruler.TrimStart().Length
                    if ($Ruler.Length -gt $HeaderLine.Length) { $HeaderLine += ' ' * ($Ruler.Length - $HeaderLine.Length) }
                }
                $Mask = '?' * $Start
                foreach ($Column in ($HeaderLine.Substring($Start) -split $VRx)) {
                    if ($Null -ne $Length) { $Mask += '?' * $Length + $VerticalDash }
                    $Length = $Column.Length
                    $Type,$Name = if (@($Header).Count -le 1) { TypeName $Column.Trim() }
                    elseif ($Index -lt @($Header).Count) { TypeName $Header[$Index] }
                    if ($Name) {
                        $End = $Start + $Length - 1
                        $Padding = [math]::Min($Padding,$Column.Length - $Column.TrimStart().Length)
                        if ($Ruler -or $End -lt $HeaderLine.Length - 1) { $Padding = [math]::Min($Padding,$Column.Length - $Column.TrimEnd().Length) }
                        $Columns.Add(@{ Index = $Index; Name = $Column; Type = $Null; Start = $Start; End = $End })
                        $Property.Add($Name,$Null)
                    }
                    $Index++; $Start += $Column.Length + 1
                }
                $Mask += '*'
                foreach ($Column in $Columns) {
                    $Anchored = $Ruler -and $ANx -and $Ruler -match $ANx
                    if (!$Ruler) {
                        if ($Column.Start -eq 0) {
                            $Column.Start = [math]::Max($HeaderLine.Length - $HeaderLine.TrimStart().Length - $Padding,0)
                            $OuterLeftColumn = $Column
                        } elseif ($Column.End -eq $HeaderLine.Length - 1) {
                            $Column.End = $HeaderLine.TrimEnd().Length + $Padding
                            $OuterRightColumn = $Column
                        }
                    }
                    $Column.Type,$Column.Name = TypeName $Column.Name.Trim()
                    if ($Anchored) {
                        $Column.Alignment = [Alignment]::None
                        if ($Ruler[$Column.Start] -match $ANx) { $Column.Alignment = $Column.Alignment -bor [Alignment]::Left }
                        if ($Ruler[$Column.End] -match $ANx) { $Column.Alignment = $Column.Alignment -bor [Alignment]::Right }
                    } else {
                        $Column.Alignment = [Alignment]::Justified
                        if ($HeaderLine[$Column.Start + $Padding] -notmatch '\S') { $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Left }
                        if ($Column.End - $Padding -ge $HeaderLine.Length -or $HeaderLine[$Column.End - $Padding] -notmatch '\S') { $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Right }
                    }
                }
            } else {
                Mask $HeaderLine ([Mask]::Header)
                if ($Ruler) { Mask $Ruler ([Mask]::Ruler) }
                $Lines | Select-Object -Skip $DataIndex | Where-Object { $_.Trim() } | ForEach-Object { Mask $_ }
                if (!$Ruler -and $HRx) {                    # Connect (rulerless) single spaced headers where either column is empty
                    $InWord = $False; $WordMask = 0
                    for ($i = 0; $i -le $Mask.Count; $i++) {
                        if ($i -lt $Mask.Count) { $WordMask = $WordMask -bor $Mask[$i] }
                        $Masked = $i -lt $Mask.Count -and $Mask[$i]
                        if ($Masked -and !$InWord) { $InWord = $True; $Start = $i }
                        elseif (!$Masked -and $InWord) {
                            $InWord = $False; $End = $i - 1
                            if ([Mask]::Header -eq $WordMask -band 7) { # only header
                                if ($Start -ge 2 -and $Mask[$Start - 2] -band [Mask]::Header) { $Mask[$Start - 1] = [Mask]::Header }
                                elseif (($End + 2) -lt $Mask.Count -and $Mask[$End + 2] -band [Mask]::Header) { $Mask[$End + 1] = [Mask]::Header }
                            }
                            $WordMask = 0
                        }
                    }
                }
                $InWord = $False; $Index = 0; $Start,$Left = $Null
                for ($i = 0; $i -le $Mask.Count; $i++) {
                    $Masked = $i -lt $Mask.Count -and $Mask[$i]
                    if ($Masked -and !$InWord) { $InWord = $True; $Start = $i; $WordMask = 0 }
                    elseif ($InWord) {
                        if ($i -lt $Mask.Count) {$WordMask = $WordMask -bor $Mask[$i]}
                        if (!$Masked) {
                            $InWord = $False; $End = $i - 1
                            if ($i -lt $Mask.Count) {$WordMask = $WordMask -bor $Mask[$i]}
                            $Type,$Name = if (@($Header).Count -le 1) { TypeName "$(Slice -String $HeaderLine -Start $Start -End $End)".Trim() }
                            elseif ($Index -lt @($Header).Count) { TypeName $Header[$Index] }
                            if ($Name) {
                                if ($Columns.Where{ $_.Name -eq $Name }) { Write-Warning "Duplicate column name: $Name." }
                                else {
                                    if ($Type) {
                                        $Type = try { [type]$Type } catch {
                                            Write-Error -ErrorRecord (ErrorRecord -Line $HeaderLine -Start $Start -End $End -Message (
                                                    "Unknown type {0} in header at column '{1}'" -f $Type,$Name
                                                ))
                                        }
                                    }
                                    $Column = @{
                                        Index = $Index++
                                        Name = $Name
                                        Type = $Type
                                        Start = $Start
                                        End = $End
                                        Alignment = $Null
                                        Left = $Left
                                        Right = $Null
                                        Mask = $WordMask
                                    }
                                    $Columns.Add($Column)
                                    if ($Left) { $Left.Right = $Column }
                                    $Left = $Column
                                    $Property.Add($Name,$Null)
                                }
                            }
                        }
                    }
                }
            }
            $RulerPattern = if ($Ruler) { '^' + ($Ruler -replace "[^$HRx]","[$VRx$JNx$ANx\s]" -replace "[$HRx]","[$HRx]") } else { '\A(?!x)x' }
        }
    }
    if ($Columns) {
        if ($VRx) {
            foreach ($Line in ($Lines | Where-Object { $_ -like $Mask })) {
                if ($OuterLeftColumn) {
                    $Start = [math]::Max($Line.Length - $Line.TrimStart().Length - $Padding,0)
                    if ($Start -lt $OuterLeftColumn.Start) {
                        $OuterLeftColumn.Start = $Start
                        $OuterLeftColumn.Alignment = $Column.Alignment -band -bnot [Alignment]::Left
                    }
                } elseif ($OuterRightColumn) {
                    $End = $Line.TrimEnd().Length + $Padding
                    if ($End -gt $OuterRightColumn.End) {
                        $OuterRightColumn.End = $End
                        $OuterRightColumn.Alignment = $Column.Alignment -band -bnot [Alignment]::Right
                    }
                }
            }
        } else {
            $HeadMask = if ($Ruler) { [Mask]::Header -bor [Mask]::Ruler } else { [Mask]::Header }
            $Lines | Select-Object -Skip (0 + $DataIndex) | Where-Object { $_.Trim() } | ForEach-Object { Mask $_ }

            if (!$RowIndex) {
                for ($c = $Columns.Count - 1; $c -ge 0; $c --) {
                    $Column = $Columns[$c]
                    $MaskStart = $Mask[$Column.Start]; $MaskEnd = $Mask[$Column.End]
                    $HeadStart = $MaskStart -band $HeadMask; $HeadEnd = $MaskEnd -band $HeadMask
                    $AllStart = $MaskStart -band [Mask]::All; $AllEnd = $MaskEnd -band [Mask]::All
                    $IsLeftAligned = ($HeadStart -eq $HeadMask -and $HeadEnd -ne $HeadMask) -or ($AllStart -and !$AllEnd)
                    $IsRightAligned = ($HeadStart -ne $HeadMask -and $HeadEnd -eq $HeadMask) -or (!$AllStart -and $AllEnd)
                    if ($IsLeftAligned) { $Column.Alignment = $Column.Alignment -bor [Alignment]::Left }
                    if ($IsRightAligned) { $Column.Alignment = $Column.Alignment -bor [Alignment]::Right }
                }
                if ($DebugPreference -ne 'SilentlyContinue' -and !$RowIndex) { Write-Debug ($HeaderLine -replace '\s',' '); Debug-Column }
            }

            foreach ($Column in $Columns) {                         # Include any consecutive characters at te right
                $MaxEnd = if ($Column.Right) { $Column.Right.Start - 2 } else { $Mask.Count - 1 }
                for ($i = $Column.End + 1; $i -le $MaxEnd; $i++) {
                    if ($Mask[$i]) {
                        $Column.End = $i
                        $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Right
                    } else { break }
                }
            }

            foreach ($Column in $Columns) {                         # Include any consecutive characters at te left
                $MinStart = if ($Column.Left) { $Column.Left.End + 2 } else { 0 }
                for ($i = $Column.Start - 1; $i -ge $MinStart; $i --) {
                    if ($Mask[$i]) {
                        $Column.Start = $i
                        $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Left
                    } else { break }
                }
            }

            foreach ($Column in $Columns) {                         # Include any floating characters at the right
                if ($Column.Alignment -ne [Alignment]::Right) {     # unless the column is right aligned
                    $MaxEnd = if ($Column.Right) { $Column.Right.Start - 2 } else { $Mask.Count - 1 }
                    for ($i = $Column.End + 1; $i -le $MaxEnd; $i++) {
                        if ($Mask[$i]) {
                            $Column.End = $i
                            $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Right
                        }
                    }
                }
            }

            foreach ($Column in $Columns) {                         # Include any floating characters at the left
                if ($Column.Alignment -ne [Alignment]::Left) {      # unless the column is left aligned
                    $MinStart = if ($Column.Left) { $Column.Left.End + 2 } else { 0 }
                    for ($i = $Column.Start - 1; $i -ge $MinStart; $i --) {
                        if ($Mask[$i]) {
                            $Column.Start = $i
                            $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Left
                        }
                    }
                }
            }

            foreach ($Column in $Columns) {                         # Include any leftover floating characters at the right
                if ($Column.Alignment -ne [Alignment]::Right) {     # where the column is right aligned
                    $MaxEnd = if ($Column.Right) { $Column.Right.Start - 2 } else { $Mask.Count - 1 }
                    for ($i = $Column.End + 1; $i -le $MaxEnd; $i++) {
                        if ($Mask[$i]) {
                            $Column.End = $i
                            $Column.Alignment = $Column.Alignment -band -bnot [Alignment]::Right
                        }
                    }
                }
            }
        }
        if ($DebugPreference -ne 'SilentlyContinue' -and !$RowIndex) { Write-Debug ($HeaderLine -replace '\s',' '); Debug-Column }
        foreach ($Line in ($Lines | Select-Object -Skip ([int]$DataIndex))) {
            if ($Line.Trim() -and ($Line -notmatch $RulerPattern)) {
                $RowIndex++
                if ($DebugPreference -ne 'SilentlyContinue') { Write-Debug ($Line -replace '\s',' ') }
                $Fields = if ($VRx -and $Line -notlike $Mask) { $Line -split $VRx }
                foreach ($Column in $Columns) {
                    $Property[$Column.Name] = if ($Fields) {
                        $Fields[$Column.Index].Trim()
                    } else {
                        $Field = Slice -String $Line -Start $Column.Start -End $Column.End
                        if ($Field -is [string]) {
                            $Tail = $Field.TrimStart()
                            $Value = $Tail.TrimEnd()
                            if (!$Literal -and $Value -gt '') {
                                $IsLeftAligned = $Field.Length - $Tail.Length -eq $Padding
                                $IsRightAligned = $Tail.Length - $Value.Length -eq $Padding
                                $Alignment = if ($IsLeftAligned -ne $IsRightAligned) {
                                    if ($IsLeftAligned) { [Alignment]::Left } else { [Alignment]::Right }
                                } else { $Column.Alignment }
                                if ($Alignment -eq [Alignment]::Right) {
                                    try { & ([scriptblock]::Create($Value)) }
                                    catch { $Value
                                        Write-Error -ErrorRecord (ErrorRecord -Line $Line -Start $Column.Start -End $Column.End -Message (
                                                "The expression '{0}' in row {1} at column '{2}' can't be evaluated. Check the syntax or use the -Literal switch." -f $Value,$RowIndex,$Column.Name
                                            ))
                                    }
                                } elseif ($Column.Type) {
                                    try { & ([scriptblock]::Create("[$($Column.Type)]`$Value")) }
                                    catch { $Value
                                        Write-Error -ErrorRecord (ErrorRecord -Line $Line -Start $Column.Start -End $Column.End -Message (
                                                "The value '{0}' in row {1} at column '{2}' can't be converted to type {1}." -f $Valuee,$RowIndex,$Column.Name,$Column.Type
                                            ))
                                    }
                                } else { $Value }
                            } else { $Value }
                        } else { '' }
                    }
                }
                New-Object PSObject -Property $Property
            }
        }
        if ($DebugPreference -ne 'SilentlyContinue' -and $RowIndex) { Debug-Column }
    }
}

