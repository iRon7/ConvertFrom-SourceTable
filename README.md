# ConvertFrom-SourceTable
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
