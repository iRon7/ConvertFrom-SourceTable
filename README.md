# ConvertFrom-SourceTable
Converts a source table (`Format-Table`) or markdown table to objects.

The `ConvertFrom-SourceTable` cmdlet creates objects from a fixed column
source table (`Format-Table`) or markdown table. The `ConvertFrom-SourceTable`
cmdlet supports most data types using the following formatting and alignment
rules

Data that is left aligned will be parsed to the generic column type
which is a string by default.

The generic column type can be set by prefixing the column name with
a standard (PowerShell) cast operator (a data type enclosed in
square brackets, e.g.: `[Int]ID`)

Data that is right aligned will be evaluated.

### Definitions
The width of a source table column is outlined by the header width,
the ruler width and the width of the data.

Data alignment is defined by the first and last character or space
in field of the outlined column.

Column alignment (which is used for a default field alignment) is
defined by the first and last character or space of the header and
the ruler of the outlined column.

## Examples

```powershell
PS C:\> $Colors = ConvertFrom-SourceTable '
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

PS C:\> $Colors | Where {$_.Name -eq "Red"}

RGB         Name    Value
---         ----    -----
{255, 0, 0} Red  16711680
```

```powershell
PS C:\> $Employees = ConvertFrom-SourceTable '
	| Department  | Name    | Country |
	| ----------- | ------- | ------- |
	| Sales       | Aerts   | Belgium |
	| Engineering | Bauer   | Germany |
	| Sales       | Cook    | England |
	| Engineering | Duval   | France  |
	| Marketing   | Evans   | England |
	| Engineering | Fischer | Germany |
'
```

```powershell
PS C:\> $ChangeLog = ConvertFrom-SourceTable '
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
```

```powershell
PS C:\> $Files = ConvertFrom-SourceTable -Literal '
	Mode                LastWriteTime         Length Name
	----                -------------         ------ ----
	d----l       11/16/2018   8:30 PM                Archive
	-a---l        5/22/2018  12:05 PM          (726) Build-Expression.ps1
	-a---l       11/16/2018   7:38 PM           2143 CHANGELOG
	-a---l       11/17/2018  10:42 AM          14728 ConvertFrom-SourceTable.ps1
	-a---l       11/17/2018  11:04 AM          23909 ConvertFrom-SourceTable.Tests.ps1
	-a---l         8/4/2018  11:04 AM         (6237) Import-SourceTable.ps1
'
```
## Parameters
-`InputObject <String[]>`
Specifies the source table strings to be converted to objects.
Enter a variable that contains the source table strings or type a
command or expression that gets the source table strings.
You can also pipe the source table strings to `ConvertFrom-SourceTable`.

*Note that piped table data strings are intermediately processed and
released for the next cmdlet. In this mode, there is a higher
possibility that floating data can't be determined to be part of
a specific column (as there is no overview of the table data that
follows). To resolve this use the `-Ruler` parameter.*

`-Header <String>`
A string that defines the header line of an headless table. The header
is used to define the (property) names, the size and alignment of the
column, therefore it is key that the columns names are properly aligned
with the rest of the column (including any table indents).
The `-Header` parameter might also include the ruler functionality by
omitting any ruler. In this case, all the horizontal ruler characters
will be replaced by spaces.

`-Ruler <String>`
A string that replaces any ruler in the input table which helps to
define character columns in occasions where the table column margins
are indefinable.

`-HorizontalRuler <Char>`
Defines the horizontal ruler character. The default is a hyphen (`-`).

`-VerticalRuler <Char>`
Defines the vertical ruler character. The default is a vertical line (`|`).

`-Literal`
The -Literal parameter will prevent any right aligned data to be evaluated.

`-Markdown`
Threats the input table as a markdown table (`-Markdown`) or a source
table (`-Markdown:$False`). By default, this parameter is automatically
defined based on the existence of a vertical ruler character in the
header.

## Links
Online Version: https://github.com/iRon7/ConvertFrom-SourceTable
