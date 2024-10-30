<!-- markdownlint-disable MD033 -->
# ConvertFrom-SourceTable

Converts a fixed column table to objects.

## Syntax

```PowerShell
ConvertFrom-SourceTable
    [-InputObject <String[]>]
    [-Header <String[]>]
    [-Ruler <String>]
    [-HorizontalDash <Char> = '-']
    [-VerticalDash <Char> = '|']
    [-Junction <Char> = '+']
    [-Anchor <Char> = ':']
    [-Omit <String>]
    [-ParseRightAligned]
    [-Literal]
    [<CommonParameters>]
```

## Description

The [`ConvertFrom-SourceTable`](https://github.com/iRon7/ConvertFrom-SourceTable) cmdlet creates objects from a fixed column
source table possibly surrounded by horizontal and/or vertical rulers.

**Definitions:**

* The width of a source table column is outlined by the header width,
the ruler width and the width of the data.

* Column and Data alignment (none, left, right or justified) is defined
by the existence of any (non-separator) character at the start or end
of a column.

* Column alignment (which is used for a default field alignment) is
defined by the first and last character or space of the header and
the ruler of the outlined column.

## Examples

### Example 1: Restore objects from a Format-Table output


The following loads the file properties from general PowerShell output table:

```PowerShell
$Files = ConvertFrom-SourceTable '
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----l       11/16/2018   8:30 PM                Archive
-a---l        5/22/2018  12:05 PM          (726) Build-Expression.ps1
-a---l       11/16/2018   7:38 PM           2143 CHANGELOG
-a---l       11/17/2018  10:42 AM          14728 ConvertFrom-SourceTable.ps1
-a---l       11/17/2018  11:04 AM          23909 ConvertFrom-SourceTable.Tests.ps1
-a---l         8/4/2018  11:04 AM         (6237) Import-SourceTable.ps1'
```

> Note that it is generally not a good practice to use console output cmdlets
> as e.g. [`Format-Table`](https://go.microsoft.com/fwlink/?LinkID=2096703) for anything else than displaying the results.

### Example 2: Convert from a markdown table


The following command loads a list of employee objects from a markdown table:

```PowerShell
$Employees = ConvertFrom-SourceTable '
| Department  | Name    | Country |
| ----------- | ------- | ------- |
| Sales       | Aerts   | Belgium |
| Engineering | Bauer   | Germany |
| Sales       | Cook    | England |
| Engineering | Duval   | France  |
| Marketing   | Evans   | England |
| Engineering | Fischer | Germany |'
```

### Example 3: Parse right aligned data


In the following example each item in the (hexadecimal) `Value` column will be parsed
to integer value and each item in the `RGB` column to an array with three values.

```PowerShell
$Colors = ConvertFrom-SourceTable -Parse '
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
Navy    0x000080     0,0,128'

$Colors | Where {$_.Name -eq "Red"}

Name    Value RGB
----    ----- ---
Red  16711680 {255, 0, 0}
```

### Example 4: Custom column types


In the following example each item in the first column is casted to a `version` object
and each item in the second column to a `DateTime` object.  
Notice that the type name is used as a property name in case column name is omitted.

```PowerShell
$ChangeLog = ConvertFrom-SourceTable -Parse '
[Version] [DateTime]Date Author      Comments
--------- -------------- ------      --------
0.0.10    2018-05-03     Ronald Bode First design
0.0.20    2018-05-09     Ronald Bode Pester ready version
0.0.21    2018-05-09     Ronald Bode removed support for String[] types
0.0.22    2018-05-24     Ronald Bode Better "right aligned" definition
0.0.23    2018-05-25     Ronald Bode Resolved single column bug
0.0.24    2018-05-26     Ronald Bode Treating markdown table input as an option
0.0.25    2018-05-27     Ronald Bode Resolved error due to blank top lines'
```

## Parameters

### <a id="-inputobject">**`-InputObject <String[]>`**</a>

Specifies the source table strings to be converted to objects.
Enter a variable that contains the source table strings or type a
command or expression that gets the source table strings.
You might also pipe the source table strings to [`ConvertFrom-SourceTable`](https://github.com/iRon7/ConvertFrom-SourceTable).

Note that streamed table rows are intermediately processed and
released for the next cmdlet. In this mode, there is a higher
possibility that floating tables or column data cannot be determined
to be part of a specific column (as there is no overview of the table
data that follows). To resolve this, provide all rows in once or use
one of the following [-Header](#-header) and/or [-Ruler](#-ruler) parameters.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String[]">String[]</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-header">**`-Header <String[]>`**</a>

A string that defines the header line of an headless table or a multiple
strings where each item represents the column name.
In case the header contains a single string, it is used to define the
(property) names, the size and alignment of the column, therefore it is
key that the columns names are properly aligned with the rest of the
column (including any table indents).
If the header contains multiple strings, each string will be used to
define the property names of each object. In this case, column alignment
is based on the rest of the data and possible ruler.

> [!TIP]
> To skip a column, set the header name of the concerned column index to
> an empty string (or `$Null`).

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String[]">String[]</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-ruler">**`-Ruler <String>`**</a>

A string that replaces any (horizontal) ruler in the input table which
helps to define character columns in occasions where the table column
margins are indefinable.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-horizontaldash">**`-HorizontalDash <Char>`**</a>

This parameter (Alias `-HDash`) defines the horizontal ruler character.
By default, each streamed table row (or a total raw table) will be
searched for a ruler existing out of horizontal dash characters (`-`),
spaces and possible vertical dashes. If the ruler is found, the prior
line is presumed to be the header. If the ruler is not found within
the first (two) streamed data lines, the first line is presumed the
header line.
If `-HorizontalDash` explicitly defined, all (streamed) lines will be
searched for a matching ruler.
If `-HorizontalDash` is set to `$Null`, the first data line is presumed
the header line (unless the [-VerticalDash](#-verticaldash) parameter is set).

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Char">Char</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td><code>'-'</code></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-verticaldash">**`-VerticalDash <Char>`**</a>

This parameter (Alias `-VDash`) defines the vertical ruler character.
By default, each streamed table row (or a total raw table) will be
searched for a header with vertical dash characters (`|`). If the
header is not found within the first streamed data line, the first
line is presumed the header line.
If `-VerticalDash` explicitly defined, all (streamed) lines will be
searched for a header with a vertical dash character.
If `-VerticalDash` is set to `$Null`, the first data line is presumed
the header line (unless the [-HorizontalDash](#-horizontaldash) parameter is set).

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Char">Char</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td><code>'|'</code></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-junction">**`-Junction <Char>`**</a>

The -Junction parameter (default: "+") defines the character used for
the junction between the horizontal ruler and vertical ruler.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Char">Char</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td><code>'+'</code></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-anchor">**`-Anchor <Char>`**</a>

The -Anchor parameter (default: `:`) defines the character used for
the alignment anchor. If used in the header row, it will be used to
define the default alignment, meaning that justified (full width)
values will be parsed.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Char">Char</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td><code>':'</code></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-omit">**`-Omit <String>`**</a>

A string of characters to omit from the header and data. Each omitted
character will be replaced with a space.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.String">String</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-parserightaligned">**`-ParseRightAligned`**</a>

This parameter will cause any right aligned data to be parsed according
to the following formatting and alignment rules:

* Data that is left aligned will be parsed to the generic column type
which is a string by default.

* Data that is right aligned will be parsed.

* Data that is justified (using the full column with) is following the
the header alignment and parsed if the header is right aligned.

* The default column type can be set by prefixing the column name with
a standard (PowerShell) cast operator (a data type enclosed in
square brackets, e.g.: `[Int]ID`)

#### Caution

Take reasonable precautions when using the `-ParseRightAligned` parameter
in scripts. When using the `-ParseRightAligned` parameter to convert data
from a table, verify that the data is safe to be parsed before running it.

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter">SwitchParameter</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

### <a id="-literal">**`-Literal`**</a>

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter">SwitchParameter</a></td></tr>
<tr><td>Mandatory:</td><td>False</td></tr>
<tr><td>Position:</td><td>Named</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

## Related Links

* https://github.com/iRon7/ConvertFrom-SourceTable

[comment]: <> (Created with Get-MarkdownHelp: Install-Script -Name Get-MarkdownHelp)
