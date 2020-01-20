#Requires -Modules @{ModuleName="Pester"; ModuleVersion="4.4.0"}

Set-StrictMode -Version 2

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Function Differentiate {
	Param (
		[Parameter(Position=0)][Object[]]$Expected, [Parameter(ValueFromPipeLine = $True)][Object[]]$Actual
	)
	$Property = ($Actual | Select-Object -First 1).PSObject.Properties | Select-Object -Expand Name
	$DifferenceCount = @(Compare-Object $Expected $Actual -Property $Property).Count
	If ($DifferenceCount) {
		Write-Host 'Expected:' ($Expected | Out-String)
		Write-Host 'Actual:' ($Actual | Out-String)
	}
	Write-Output $DifferenceCount
}

$SimpleObject = @(
	[PSCustomObject]@{'Country' = 'Belgium'; 'Department' = 'Sales'; 'Name' = 'Aerts'},
	[PSCustomObject]@{'Country' = 'Germany'; 'Department' = 'Engineering'; 'Name' = 'Bauer'},
	[PSCustomObject]@{'Country' = 'England'; 'Department' = 'Sales'; 'Name' = 'Cook'},
	[PSCustomObject]@{'Country' = 'France'; 'Department' = 'Engineering'; 'Name' = 'Duval'},
	[PSCustomObject]@{'Country' = 'England'; 'Department' = 'Marketing'; 'Name' = 'Evans'},
	[PSCustomObject]@{'Country' = 'Germany'; 'Department' = 'Engineering'; 'Name' = 'Fischer'}
)

$ColorObject = @(
	[PSCustomObject]@{'Name' = 'Black';   'RGB' = @(0,0,0);       'Value' = 0},
	[PSCustomObject]@{'Name' = 'White';   'RGB' = @(255,255,255); 'Value' = 16777215},
	[PSCustomObject]@{'Name' = 'Red';     'RGB' = @(255,0,0);     'Value' = 16711680},
	[PSCustomObject]@{'Name' = 'Lime';    'RGB' = @(0,255,0);     'Value' = 65280},
	[PSCustomObject]@{'Name' = 'Blue';    'RGB' = @(0,0,255);     'Value' = 255},
	[PSCustomObject]@{'Name' = 'Yellow';  'RGB' = @(255,255,0);   'Value' = 16776960},
	[PSCustomObject]@{'Name' = 'Cyan';    'RGB' = @(0,255,255);   'Value' = 65535},
	[PSCustomObject]@{'Name' = 'Magenta'; 'RGB' = @(255,0,255);   'Value' = 16711935},
	[PSCustomObject]@{'Name' = 'Silver';  'RGB' = @(192,192,192); 'Value' = 12632256},
	[PSCustomObject]@{'Name' = 'Gray';    'RGB' = @(128,128,128); 'Value' = 8421504},
	[PSCustomObject]@{'Name' = 'Maroon';  'RGB' = @(128,0,0);     'Value' = 8388608},
	[PSCustomObject]@{'Name' = 'Olive';   'RGB' = @(128,128,0);   'Value' = 8421376},
	[PSCustomObject]@{'Name' = 'Green';   'RGB' = @(0,128,0);     'Value' = 32768},
	[PSCustomObject]@{'Name' = 'Purple';  'RGB' = @(128,0,128);   'Value' = 8388736},
	[PSCustomObject]@{'Name' = 'Teal';    'RGB' = @(0,128,128);   'Value' = 32896},
	[PSCustomObject]@{'Name' = 'Navy';    'RGB' = @(0,0,128);     'Value' = 128}
)

$VersionObject = @(
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'First design'
			'Date' = [datetime]'2018-05-03'
			'Version' = [version]'0.0.10'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'Pester ready version'
			'Date' = [datetime]'2018-05-09'
			'Version' = [version]'0.0.20'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'removed support for String[] types'
			'Date' = [datetime]'2018-05-09'
			'Version' = [version]'0.0.21'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'Better "right aligned" definition'
			'Date' = [datetime]'2018-05-24'
			'Version' = [version]'0.0.22'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'Resolved single column bug'
			'Date' = [datetime]'2018-05-25'
			'Version' = [version]'0.0.23'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'Treating markdown table input as an option'
			'Date' = [datetime]'2018-05-26'
			'Version' = [version]'0.0.24'
	},
	[PSCustomObject]@{
			'Author' = 'Ronald Bode'
			'Comments' = 'Resolved error due to blank top lines'
			'Date' = [datetime]'2018-05-27'
			'Version' = [version]'0.0.25'
	}
)

$TypeObject = @(
	[PSCustomObject]@{
		'Type' = 'String'
		'Value' = 'Hello World'
		'PowerShell' = 'Hello World'
		'Output' = 'Hello World'
	},
	[PSCustomObject]@{
		'Type' = 'Number'
		'Value' = 123
		'PowerShell' = 123
		'Output' = 123
	},
	[PSCustomObject]@{
		'Type' = 'Null'
		'Value' = $Null
		'PowerShell' = $Null
		'Output' = ''
	},
	[PSCustomObject]@{
		'Type' = 'Boolean'
		'Value' = $True
		'PowerShell' = $True
		'Output' = 'True'
	},
	[PSCustomObject]@{
		'Type' = 'Boolean'
		'Value' = $False
		'PowerShell' = $False
		'Output' = 'False'
	},
	[PSCustomObject]@{
		'Type' = 'DateTime'
		'Value' = [DateTime]'1963-10-07T21:47:00.0000000'
		'PowerShell' = [DateTime]'1963-10-07T21:47:00.0000000'
		'Output' = '1963-10-07 9:47:00 PM'
	},
	[PSCustomObject]@{
		'Type' = 'Array'
		'Value' = @(1, 'Two')
		'PowerShell' = @(1, 'Two')
		'Output' = '{1, two}'
	},
	[PSCustomObject]@{
		'Type' = 'HashTable'
		'Value' = @{'One' = 1; 'Two' = 2}
		'PowerShell' = @{'One' = 1; 'Two' = 2}
		'Output' = '{One, Two}'
	},
	[PSCustomObject]@{
		'Type' = 'Object'
		'Value' = [PSCustomObject]@{'One' = 1; 'Two' = 2}
		'PowerShell' = [PSCustomObject]@{'One' = 1; 'Two' = 2}
		'Output' = '@{One=1; Two=2}'
	}
)

$DirObject = @(
	[PSCustomObject]@{'LastWriteTime' = '11/16/2018   8:30 PM'; 'Length' = '';       'Mode' = 'd----l'; 'Name' = 'Archive'}
	[PSCustomObject]@{'LastWriteTime' = '5/22/2018  12:05 PM';  'Length' = '(726)';  'Mode' = '-a---l'; 'Name' = 'Build-Expression.ps1'}
	[PSCustomObject]@{'LastWriteTime' = '11/16/2018   7:38 PM'; 'Length' = '2143';   'Mode' = '-a---l'; 'Name' = 'CHANGELOG'}
	[PSCustomObject]@{'LastWriteTime' = '11/17/2018  10:42 AM'; 'Length' = '14728';  'Mode' = '-a---l'; 'Name' = 'ConvertFrom-SourceTable.ps1'}
	[PSCustomObject]@{'LastWriteTime' = '11/17/2018  11:04 AM'; 'Length' = '23909';  'Mode' = '-a---l'; 'Name' = 'ConvertFrom-SourceTable.Tests.ps1'}
	[PSCustomObject]@{'LastWriteTime' = '8/4/2018  11:04 AM';   'Length' = '(6237)'; 'Mode' = '-a---l'; 'Name' = 'Import-SourceTable.ps1'}
)

Describe 'ConvertFrom-Table' {
	
	Context 'Simple string table' {
	
		$Table = '
			Department  Name    Country
			----------  ----    -------
			Sales       Aerts   Belgium
			Engineering Bauer   Germany
			Sales       Cook    England
			Engineering Duval   France
			Marketing   Evans   England
			Engineering Fischer Germany
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}
	
	Context 'Markdown table' {
	
		$Table = '
			| Department  | Name    | Country |
			| ----------- | ------- | ------- |
			| Sales       | Aerts   | Belgium |
			| Engineering | Bauer   | Germany |
			| Sales       | Cook    | England |
			| Engineering | Duval   | France  |
			| Marketing   | Evans   | England |
			| Engineering | Fischer | Germany |
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}
	
	Context 'Color table with casted values' {

		$Table = '
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
		Write-Host $Table

		$Object = $ColorObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object
		}
	}
	
	Context 'Markdown color table with casted values' {
		
		$Table = '
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
		Write-Host $Table

		$Object = $ColorObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Color table with only vertical rulers and casted values' {
		
		$Table = '
			| Name    |    Value |           RGB |
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
		'
		Write-Host $Table

		$Object = $ColorObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Markdown color table with junction characters' {
		
		$Table = '
			+---------+----------+---------------+
			| Name    |    Value |           RGB |
			+---------+----------+---------------+
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
			+---------+----------+---------------+
		'
		Write-Host $Table

		$Object = $ColorObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Table without Ruler' {
	
		$Table = '
			Department  Name    Country
			Sales       Aerts   Belgium
			Engineering Bauer   Germany
			Sales       Cook    England
			Engineering Duval   France
			Marketing   Evans   England
			Engineering Fischer Germany
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		# It 'Streamed table lines from pipeline' {
			# $Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			# ,$Actual | Differentiate $Object | Should -Be 0
		# }
	}
	
	Context 'Markdown table without ruler' {
	
		$Table = '
			| Department  | Name    | Country |
			| Sales       | Aerts   | Belgium |
			| Engineering | Bauer   | Germany |
			| Sales       | Cook    | England |
			| Engineering | Duval   | France  |
			| Marketing   | Evans   | England |
			| Engineering | Fischer | Germany |
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Markdown table without ruler and side borders' {
	
		$Table = '
			Department  | Name    | Country
			Sales       | Aerts   | Belgium
			Engineering | Bauer   | Germany
			Sales       | Cook    | England
			Engineering | Duval   | France
			Marketing   | Evans   | England
			Engineering | Fischer | Germany
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'CSV file' {
	
		$Table = '
Department,Name,Country
Sales,Aerts,Belgium
Engineering,Bauer,Germany
Sales,Cook,England
Engineering,Duval,France
Marketing,Evans,England
Engineering,Fischer,Germany
		'
		Write-Host $Table

		$Object = $SimpleObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable -VDash ',' $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable -VDash ','
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -VDash ','
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}
	
	Context 'Version table with default column types' {

		$Table = '
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
		Write-Host $Table

		$Object = $VersionObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}
	
	Context '(Narrow) markdown version table with and default column types' {
		
		$Table = '
			[Version]|[DateTime]Date|Author     |Comments
			---------|--------------|-----------|------------------------------------------
			0.0.10   |2018-05-03    |Ronald Bode|First design
			0.0.20   |2018-05-09    |Ronald Bode|Pester ready version
			0.0.21   |2018-05-09    |Ronald Bode|removed support for String[] types
			0.0.22   |2018-05-24    |Ronald Bode|Better "right aligned" definition
			0.0.23   |2018-05-25    |Ronald Bode|Resolved single column bug
			0.0.24   |2018-05-26    |Ronald Bode|Treating markdown table input as an option
			0.0.25   |2018-05-27    |Ronald Bode|Resolved error due to blank top lines
		'
		Write-Host $Table

		$Object = $VersionObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object
		}
	}

	Context 'Type table with mixed value types' {

		$Table = '
			Type                                 Value                      PowerShell Output
			----       -------------------------------                     ----------- ---------------------
			String     Hello World                                       "Hello World" Hello World
			Number                                 123                             123                   123
			Null                                  Null                           $Null
			Boolean                               True                           $True True
			Boolean                              False                          $False False
			DateTime      [DateTime]"1963-10-07T21:47"    [DateTime]"1963-10-07 21:47" 1963-10-07 9:47:00 PM
			Array                             1, "Two"                     @(1, "Two") {1, two}
			HashTable                  @{One=1; Two=2}                 @{One=1; Two=2} {One, Two}
			Object     [PSCustomObject]@{One=1; Two=2} [PSCustomObject]@{One=1; Two=2} @{One=1; Two=2}
		'
		Write-Host $Table

		$Object = $TypeObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Markdown type table with mixed value types' {

		$Table = '
			|-----------|---------------------------------|---------------------------------|-----------------------|
			| Type      |                           Value |                      PowerShell | Output                |
			|-----------|---------------------------------|---------------------------------|-----------------------|
			| String    | Hello World                     |                   "Hello World" | Hello World           |
			| Number    |                             123 |                             123 |                   123 |
			| Null      |                            Null |                           $Null |                       |
			| Boolean   |                            True |                           $True | True                  |
			| Boolean   |                           False |                          $False | False                 |
			| DateTime  |    [DateTime]"1963-10-07 21:47" |    [DateTime]"1963-10-07 21:47" | 1963-10-07 9:47:00 PM |
			| Array     |                        1, "Two" |                     @(1, "Two") | {1, two}              |
			| HashTable |                 @{One=1; Two=2} |                 @{One=1; Two=2} | {One, Two}            |
			| Object    | [PSCustomObject]@{One=1; Two=2} | [PSCustomObject]@{One=1; Two=2} | @{One=1; Two=2}       |
			|-----------|---------------------------------|---------------------------------|-----------------------|
		'
		Write-Host $Table

		$Object = $TypeObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Literal directory list' {

		$Table = '
			Mode                LastWriteTime         Length Name
			----                -------------         ------ ----
			d----l       11/16/2018   8:30 PM                Archive
			-a---l        5/22/2018  12:05 PM          (726) Build-Expression.ps1
			-a---l       11/16/2018   7:38 PM           2143 CHANGELOG
			-a---l       11/17/2018  10:42 AM          14728 ConvertFrom-SourceTable.ps1
			-a---l       11/17/2018  11:04 AM          23909 ConvertFrom-SourceTable.Tests.ps1
			-a---l         8/4/2018  11:04 AM         (6237) Import-SourceTable.ps1
		'
		Write-Host $Table

		$Object = $DirObject

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable -Literal $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable -Literal
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -Literal
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}
	
	
	Context 'Floating table with horizontal ruler' {
		$Table = '

			Information
			on the table
			
			Name  Value
			----  -----
			Black     0
			White   255

		'
		Write-Host $Table
	
		It 'Raw table, floating: AUTO' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}

		It 'Raw table, floating: ON' {
			$Actual = ConvertFrom-SourceTable $Table -HorizontalDash '-'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Raw table, floating: OFF' {
			$Actual = ConvertFrom-SourceTable $Table -HorizontalDash $Null -VerticalDash $Null
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = '----  -----'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: AUTO' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = '----  -----'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			) | Should -Be 0
		}

		It 'Streamed table lines, floating: ON' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -HorizontalDash '-'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: OFF' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -HorizontalDash $Null -VerticalDash $Null 
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = '----  -----'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			) | Should -Be 0
		}
	}
	
	Context 'Floating table with vertical ruler' {
		$Table = '

			Information
			on the table
			
			Name  | Value
			Black |     0
			White |   255

		'
		Write-Host $Table
	
		It 'Raw table, floating: AUTO' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}

		It 'Raw table, floating: ON' {
			$Actual = ConvertFrom-SourceTable $Table -VerticalDash '|'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Raw table, floating: OFF' {
			$Actual = ConvertFrom-SourceTable $Table -HorizontalDash $Null -VerticalDash $Null
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  | Value'}
				[PSCustomObject]@{'Information' = 'Black |     0'}
				[PSCustomObject]@{'Information' = 'White |   255'}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: AUTO' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  | Value'}
				[PSCustomObject]@{'Information' = 'Black |     0'}
				[PSCustomObject]@{'Information' = 'White |   255'}
			) | Should -Be 0
		}

		It 'Streamed table lines, floating: ON' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -VerticalDash '|'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: OFF' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -HorizontalDash $Null -VerticalDash $Null 
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  | Value'}
				[PSCustomObject]@{'Information' = 'Black |     0'}
				[PSCustomObject]@{'Information' = 'White |   255'}
			) | Should -Be 0
		}
	}
	
	Context 'Floating markdown table' {
		$Table = '

			Information
			on the table
			
			|-------|-------|
			| Name  | Value |
			|-------|-------|
			| Black |     0 |
			| White |   255 |
			|-------|-------|

		'
		Write-Host $Table
	
		It 'Raw table, floating: AUTO' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}

		It 'Raw table, floating: forced ON with -HorizontalDash' {
			$Actual = ConvertFrom-SourceTable $Table -HorizontalDash '-'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Raw table, floating: forced ON with -VerticalDash' {
			$Actual = ConvertFrom-SourceTable $Table -VerticalDash '|'
			,$Actual | Differentiate @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Raw table, floating: OFF' {
			$Actual = ConvertFrom-SourceTable $Table -HorizontalDash $Null -VerticalDash $Null
			,$Actual | Differentiate @(
				[pscustomobject]@{'Information' = 'on the table'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Name  | Value |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Black |     0 |'}
				[pscustomobject]@{'Information' = '| White |   255 |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: AUTO' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate @(
				[pscustomobject]@{'Information' = 'on the table'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Name  | Value |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Black |     0 |'}
				[pscustomobject]@{'Information' = '| White |   255 |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
			) | Should -Be 0
		}

		It 'RStreamed table lines, floating: forced ON with -HorizontalDash' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -HorizontalDash '-'
			,$Actual | Differentiate @(
				[pscustomobject]@{'Name' = 'Black'; 'Value' = 0}
				[pscustomobject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'RStreamed table lines, floating: forced ON with -VerticalDash' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -VerticalDash '|'
			,$Actual | Differentiate @(
				[pscustomobject]@{'Name' = 'Black'; 'Value' = 0}
				[pscustomobject]@{'Name' = 'White'; 'Value' = 255}
			) | Should -Be 0
		}
	
		It 'Streamed table lines, floating: OFF' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -HorizontalDash $Null -VerticalDash $Null 
			,$Actual | Differentiate @(
				[pscustomobject]@{'Information' = 'on the table'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Name  | Value |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
				[pscustomobject]@{'Information' = '| Black |     0 |'}
				[pscustomobject]@{'Information' = '| White |   255 |'}
				[pscustomobject]@{'Information' = '|-------|-------|'}
			) | Should -Be 0
		}
	}
	
	Context 'Alignment challenges' {
	# If the column right of a left aligned column is also left aligned, the width will be justified to the right.
	# Left aligned columns are treated as text.

		It 'Left aligned by (otherwise) data indent' {
			
			$Actual = ConvertFrom-SourceTable '
				C1    C2
				--    --
				1  ,2 1  ,2
			'
			
			$Actual.C1 | Should -Be '1  ,2'
			$Actual.C2 | Should -Be '1  ,2'
		}
		
		It 'Left aligned by extended ruler' {
			
			$Actual = ConvertFrom-SourceTable '
				C1     C2
				---    ---
				11  ,2 11  ,2
			'
			
			$Actual.C1 | Should -Be '11  ,2'
			$Actual.C2 | Should -Be '11  ,2'
		}
		
		It 'Left aligned by indented ruler' {
			
			$Actual = ConvertFrom-SourceTable '
				C1    C2
				-     -
				11 ,2 11 ,2
			'
			
			$Actual.C1 | Should -Be '11 ,2'
			$Actual.C2 | Should -Be '11 ,2'
		}
		
		It 'Left aligned by extended data' {
			
			$Actual = ConvertFrom-SourceTable '
				C1     C2
				--     --
				111 ,2 111 ,2
			'
			
			$Actual.C1 | Should -Be '111 ,2'
			$Actual.C2 | Should -Be '111 ,2'
		}

		It 'Left aligned (to be implemented)' {
			
			$Actual = ConvertFrom-SourceTable '
				C1    C2
				--    --
				11 ,2 11 ,2
			'
			$Actual.C1 | Should -Be '11 ,2'
			$Actual.C2 | Should -Be '11 ,2'
			
		}

		It 'Right aligned by (otherwise) data indent' {
			
			$Actual = ConvertFrom-SourceTable '
				   C1    C2
				   --    --
				1,  2 1,  2
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 2
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 2
		}
		
		It 'Right aligned by extended ruler' {
			
			$Actual = ConvertFrom-SourceTable '
				    C1     C2
				   ---    ---
				1,  22 1,  22
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 22
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 22
		}
		
		It 'Right aligned by indented ruler' {
			
			$Actual = ConvertFrom-SourceTable '
				   C1    C2
				    -     -
				1, 22 1, 22
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 22
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 22
		}
		
		It 'Right aligned by extended data' {
			
			$Actual = ConvertFrom-SourceTable '
				    C1     C2
				    --     --
				1, 222 1, 222
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 222
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 222
		}

		It 'Right aligned (to be implemented)' {
			
			$Actual = ConvertFrom-SourceTable '
				   C1    C2
				   --    --
				1, 22 1, 22
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 22
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 22
			
		}

		It 'Mixed alignment (determind by spaces)' {
			
			$Actual = ConvertFrom-SourceTable '
				   C1 C2
				   -- --
				1,  2 1  ,2
			'
			
			$Actual.C1[0] | Should -Be 1; $Actual.C1[1] | Should -Be 2
			$Actual.C2 | Should -Be '1  ,2'
		}

		It 'Conflicting alignment' {
			
			$Actual = ConvertFrom-SourceTable '
				C1       C2
				--       --
				1  ,2 1,  2
			'
			
			$Actual.C1 | Should -Be '1'
			$Actual.C2 | Should -Be 2
		}

		It 'Indefinable alignment' {
			
			$Actual = ConvertFrom-SourceTable '
				C1       C2
				--       --
				11 ,2 1, 22
			'
			
			$Actual.C1 | Should -Be '11'
			$Actual.C2 | Should -Be 22
		}

		It 'Fixing indefinable alignment with ruler parameter' {
			
			$Actual = ConvertFrom-SourceTable -Ruler '    ----- -----' '
				C1       C2
				--       --
				11 ,2 1, 22
			'
			
			$Actual.C1 | Should -Be '11 ,2'
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 22
		}
		
		It 'Fixing headerless indefinable alignment with header and ruler parameter' {
			
			$Actual = ConvertFrom-SourceTable -Header '    C1       C2' -Ruler '    ----- -----' '
				11 ,2 1, 22
			'
			
			$Actual.C1 | Should -Be '11 ,2'
			$Actual.C2[0] | Should -Be 1; $Actual.C2[1] | Should -Be 22
		}
	}

	Context 'Header and ruler challenges' {
	
		It 'Source table without ruler' {
		
			$Actual = ConvertFrom-SourceTable '
				Name Value
				A        1
				B        2
			'
			$Actual[0].Name | Should -Be "A"; $Actual[0].Value | Should -Be 1
			$Actual[1].Name | Should -Be "B"; $Actual[1].Value | Should -Be 2
		}
	
		It 'Source table with space in header name' {
		
			$Actual = ConvertFrom-SourceTable '
				Name Value
				----------
				A        1
				B        2
			'
			$Actual[0].'Name Value' | Should -Be 'A        1'
			$Actual[1].'Name Value' | Should -Be 'B        2'
		}
	
		It 'Source table with assigned ruler' {
		
			$Actual = ConvertFrom-SourceTable -Ruler '    ----------' '
				Name Value
				A        1
				B        2
			'
			$Actual[0].'Name Value' | Should -Be 'A        1'
			$Actual[1].'Name Value' | Should -Be 'B        2'
		}
	
		It 'Source table with assigned header' {
		
			$Actual = ConvertFrom-SourceTable -Header '    Name Value' '
				A        1
				B        2
			'
			$Actual[0].Name | Should -Be "A"; $Actual[0].Value | Should -Be 1
			$Actual[1].Name | Should -Be "B"; $Actual[1].Value | Should -Be 2
		}
		
		It 'Markdown table without ruler' {
	
			$Actual = ConvertFrom-SourceTable '
				|------------|
				| Name Value |
				|------------|
				| A        1 |
				| B        2 |
				|------------|
			'
			$Actual[0].'Name Value' | Should -Be 'A        1'
			$Actual[1].'Name Value' | Should -Be 'B        2'
		}
	}

	$RGB = @(
		[pscustomobject]@{'Color' = 'Red'},
		[pscustomobject]@{'Color' = 'Green'},
		[pscustomobject]@{'Color' = 'Yellow'}
	)

	Context 'Single column source table' {
	
		It 'Left aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				Color
				-----
				Red
				Green
				Yellow
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}

		It 'Right aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				   Color
				   -----
				   "Red"
				 "Green"
				"Yellow"
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}

		It 'Blank lines at the top and bottom' {
		
			$Actual = ConvertFrom-SourceTable '
			
			
				Color
				-----
				Red
				Green
				Yellow
			
			
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}
	}
	Context 'Normal single column mark down table' {
	
		It 'Left aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				|--------|
				| Color  |
				|--------|
				| Red    |
				| Green  |
				| Yellow |
				|--------|
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}

		It 'Right aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				|----------|
				|    Color |
				|----------|
				|    "Red" |
				|  "Green" |
				| "Yellow" |
				|----------|
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}
	}
	Context 'Narrow single column mark down table' {
	
		It 'Left aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				|------|
				|Color |
				|------|
				|Red   |
				|Green |
				|Yellow|
				|------|
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}

		It 'Right aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				|--------|
				|   Color|
				|--------|
				|   "Red"|
				| "Green"|
				|"Yellow"|
				|--------|
			'
			,$Actual | Differentiate $RGB | Should -Be 0
		}
	}

$EmbeddedSeperators = @(
	[pscustomobject]@{'Department' = 'Sales'; 'Name' = 'Aerts'; 'Country' = 'Belgium'}
	[pscustomobject]@{'Department' = '-'; 'Name' = '|'; 'Country' = 'Germany'}
	[pscustomobject]@{'Department' = 'Sales'; 'Name' = '-'; 'Country' = '|'}
	[pscustomobject]@{'Department' = '||'; 'Name' = 'Duval'; 'Country' = '-'}
	[pscustomobject]@{'Department' = '-'; 'Name' = '-'; 'Country' = '-'}
	[pscustomobject]@{'Department' = '|'; 'Name' = '|'; 'Country' = '|'}
)

	Context 'Simple table with embedded seperators' {
	
		$Table = '
			Department  Name    Country
			----------  ----    -------
			Sales       Aerts   Belgium
			-           |       Germany
			Sales       -       |
			||          Duval   -
			-           -       -
			|           |       |
		'
		$Object = $EmbeddedSeperators

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Markdown table with embedded seperators' {
	
		$Table = '
			|------------|-------|---------|
			| Department | Name  | Country |
			|------------|-------|---------|
			| Sales      | Aerts | Belgium |
			| -          | |     | Germany |
			| Sales      | -     | |       |
			| ||         | Duval | -       |
			| -          | -     | -       |
			| |          | |     | |       |
			|------------|-------|---------|
		'
		$Object = $EmbeddedSeperators

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'SAP Table' {
	
		$Table = '
			---------------------------------------
			|Geldig v. |Geldig tot|     Inv.waarde|
			---------------------------------------
			|01.02.2015|31.12.2015|16.303,0000000 |
			|01.02.2014|31.01.2015|76.345,0000000 |
			|01.02.2013|31.01.2014|91.982,0000000 |
			|01.02.2012|31.01.2013|82.809,0000000 |
			|01.02.2011|31.01.2012|72.603,0000000 |
			|01.02.2010|31.01.2011|97.865,0000000 |
			|01.01.2009|31.01.2010|75.061,0000000 |
			---------------------------------------
		'
		$Object = @(
			[pscustomobject]@{'Geldig v.' = '01.02.2015'; 'Geldig tot' = '31.12.2015'; 'Inv.waarde' = '16.303,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.02.2014'; 'Geldig tot' = '31.01.2015'; 'Inv.waarde' = '76.345,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.02.2013'; 'Geldig tot' = '31.01.2014'; 'Inv.waarde' = '91.982,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.02.2012'; 'Geldig tot' = '31.01.2013'; 'Inv.waarde' = '82.809,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.02.2011'; 'Geldig tot' = '31.01.2012'; 'Inv.waarde' = '72.603,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.02.2010'; 'Geldig tot' = '31.01.2011'; 'Inv.waarde' = '97.865,0000000'}
			[pscustomobject]@{'Geldig v.' = '01.01.2009'; 'Geldig tot' = '31.01.2010'; 'Inv.waarde' = '75.061,0000000'}
		)

		It 'Raw table as argument' {
			$Actual = ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0
		}
	}

	Context 'Stackoverflow questions' {
	
		It 'Split string on arbitrary-length substrings (Powershell)' {			# https://stackoverflow.com/a/55752375/1701026
		
			$Table = @'
@SUB-SECTOR: sec_C   SECTOR: reft
#
# Trade routes within the subsector
#
#--------1---------2---------3---------4---------5---------6---
#PlanetName   Loc. UPP Code   B   Notes         Z  PBG Al LRX X
#----------   ---- ---------  - --------------- -  --- -- --- -
Lemente       1907 B897563-B    Ag Ni              824 Na
Zamoran       2108 B674675-A  Q Ag Ni              904 Dr
'@  -Split '[\r\n]+' | ForEach-Object {$_ -Replace '^#', ' '}

			$Actual = $Table | ConvertFrom-SourceTable -HDash '-'
			
			,$Actual | Differentiate @(
				[pscustomobject]@{'PlanetName' = 'Lemente'; 'Loc.' = '1907'; 'UPP Code' = 'B897563-B'; 'B' = ''; 'Notes' = 'Ag Ni'; 'Z' = ''; 'PBG' = '824'; 'Al' = 'Na'; 'LRX' = ''; 'X' = ''},
				[pscustomobject]@{'PlanetName' = 'Zamoran'; 'Loc.' = '2108'; 'UPP Code' = 'B674675-A'; 'B' = 'Q'; 'Notes' = 'Ag Ni'; 'Z' = ''; 'PBG' = '904'; 'Al' = 'Dr'; 'LRX' = ''; 'X' = ''}
			) | Should -Be 0
		}

		It 'Getting an average of each column from CSV' {					# https://stackoverflow.com/q/57087760/1701026

			$Table = '
				timestamp   streams TRP A   B   C   D 
				6/4/2019    6775    305 56  229 132 764
				6/4/2019    6910    316 28  356 118 134
				6/4/2019    6749    316 54  218 206 144
				6/5/2019    5186    267 84  280 452 258
				6/5/2019    5187    240 33  436 455 245
				6/5/2019    5224    291 21  245 192 654
				6/6/2019    5254    343 42  636 403 789
				6/6/2019    5180    252 23  169 328 888
				6/6/2019    5181    290 32  788 129 745
				6/6/2019    5244    328 44  540 403 989
			'
			
			$Object = @(
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = '6775'; 'TRP' = '305'; 'A' = '56'; 'B' = '229'; 'C' = '132'; 'D' = '764'},
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = '6910'; 'TRP' = '316'; 'A' = '28'; 'B' = '356'; 'C' = '118'; 'D' = '134'},
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = '6749'; 'TRP' = '316'; 'A' = '54'; 'B' = '218'; 'C' = '206'; 'D' = '144'},
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = '5186'; 'TRP' = '267'; 'A' = '84'; 'B' = '280'; 'C' = '452'; 'D' = '258'},
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = '5187'; 'TRP' = '240'; 'A' = '33'; 'B' = '436'; 'C' = '455'; 'D' = '245'},
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = '5224'; 'TRP' = '291'; 'A' = '21'; 'B' = '245'; 'C' = '192'; 'D' = '654'},
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = '5254'; 'TRP' = '343'; 'A' = '42'; 'B' = '636'; 'C' = '403'; 'D' = '789'},
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = '5180'; 'TRP' = '252'; 'A' = '23'; 'B' = '169'; 'C' = '328'; 'D' = '888'},
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = '5181'; 'TRP' = '290'; 'A' = '32'; 'B' = '788'; 'C' = '129'; 'D' = '745'},
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = '5244'; 'TRP' = '328'; 'A' = '44'; 'B' = '540'; 'C' = '403'; 'D' = '989'}
			)
			
			$Actual =  ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
			
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0

			$Table = '
				| date      |  abc |    A |  B |    C |    D |    E |  F |  G |
				| 6/4/2019  | 6775 | 3059 |  4 | 2292 | 1328 |  764 |  0 |  0 |
				| 6/4/2019  | 6910 | 3167 | 28 | 3568 | 1180 | 1348 |  0 |  0 |
				| 6/4/2019  | 6749 | 3161 |  0 | 2180 | 2060 | 1440 |  0 | 28 |
				| 6/5/2019  | 6738 | 3118 |  4 | 2736 | 1396 |  984 |  0 |  0 |
				| 6/5/2019  | 6718 | 3130 | 12 | 3076 | 1008 |  452 |  0 |  4 |
				| 6/5/2019  | 6894 | 3046 |  4 | 2284 | 1556 |  624 |  0 |  0 |
				| 1/1/2021  | 1111 | 2222 |  3 | 4444 | 5555 |  666 |  7 |  8 |
			'
			
			$Object = @(
				[pscustomobject]@{'date' = '6/4/2019'; 'abc' = 6775; 'A' = 3059; 'B' = 4; 'C' = 2292; 'D' = 1328; 'E' = 764; 'F' = 0; 'G' = 0}
				[pscustomobject]@{'date' = '6/4/2019'; 'abc' = 6910; 'A' = 3167; 'B' = 28; 'C' = 3568; 'D' = 1180; 'E' = 1348; 'F' = 0; 'G' = 0}
				[pscustomobject]@{'date' = '6/4/2019'; 'abc' = 6749; 'A' = 3161; 'B' = 0; 'C' = 2180; 'D' = 2060; 'E' = 1440; 'F' = 0; 'G' = 28}
				[pscustomobject]@{'date' = '6/5/2019'; 'abc' = 6738; 'A' = 3118; 'B' = 4; 'C' = 2736; 'D' = 1396; 'E' = 984; 'F' = 0; 'G' = 0}
				[pscustomobject]@{'date' = '6/5/2019'; 'abc' = 6718; 'A' = 3130; 'B' = 12; 'C' = 3076; 'D' = 1008; 'E' = 452; 'F' = 0; 'G' = 4}
				[pscustomobject]@{'date' = '6/5/2019'; 'abc' = 6894; 'A' = 3046; 'B' = 4; 'C' = 2284; 'D' = 1556; 'E' = 624; 'F' = 0; 'G' = 0}
				[pscustomobject]@{'date' = '1/1/2021'; 'abc' = 1111; 'A' = 2222; 'B' = 3; 'C' = 4444; 'D' = 5555; 'E' = 666; 'F' = 7; 'G' = 8}
			)
			
			$Actual =  ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
			
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0

			$Table = '
				timestamp|abc | A     |  B  |  C   |   D  |  E   |  F  |  G    |
				6/4/2019 |6775 |  3059 |  4  | 2292 | 1328 | 764  |  0 |  0  |
				6/4/2019 |6910 |  3167 |  28 | 3568 | 1180 | 1348 |  0 |  0  |
				6/4/2019 |6749 |  3161 |  0  | 2180 | 2060 | 1440 |  0 |  28 |
				6/5/2019 |6738 |  3118 |  4  | 2736 | 1396 | 984  |  0 |  0  |
				6/5/2019 |6718 |  3130 |  12 | 3076 | 1008 | 452  |  0 |  4  |
				6/5/2019 |6894 |  3046 |  4  | 2284 | 1556 | 624  |  0 |  0  |
				1/1/2021 |1111 |  2222 |  3  | 4444 | 5555 | 666  |  7 |  8  |
				'
			
			$Object = @(
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'abc' = '6775'; 'A' = '3059'; 'B' = '4'; 'C' = '2292'; 'D' = '1328'; 'E' = '764'; 'F' = '0'; 'G' = '0'}
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'abc' = '6910'; 'A' = '3167'; 'B' = '28'; 'C' = '3568'; 'D' = '1180'; 'E' = '1348'; 'F' = '0'; 'G' = '0'}
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'abc' = '6749'; 'A' = '3161'; 'B' = '0'; 'C' = '2180'; 'D' = '2060'; 'E' = '1440'; 'F' = '0'; 'G' = '28'}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'abc' = '6738'; 'A' = '3118'; 'B' = '4'; 'C' = '2736'; 'D' = '1396'; 'E' = '984'; 'F' = '0'; 'G' = '0'}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'abc' = '6718'; 'A' = '3130'; 'B' = '12'; 'C' = '3076'; 'D' = '1008'; 'E' = '452'; 'F' = '0'; 'G' = '4'}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'abc' = '6894'; 'A' = '3046'; 'B' = '4'; 'C' = '2284'; 'D' = '1556'; 'E' = '624'; 'F' = '0'; 'G' = '0'}
				[pscustomobject]@{'timestamp' = '1/1/2021'; 'abc' = '1111'; 'A' = '2222'; 'B' = '3'; 'C' = '4444'; 'D' = '5555'; 'E' = '666'; 'F' = '7'; 'G' = '8'}
			)
			
			$Actual =  ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
			
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0

			$Table = '
				timestamp   streams TRP  A    B   C   D 
				6/4/2019       6775 305 56  229 132 764
				6/4/2019       6910 316 28  356 118 134
				6/4/2019       6749 316 54  218 206 144
				6/5/2019       5186 267 84  280 452 258
				6/5/2019       5187 240 33  436 455 245
				6/5/2019       5224 291 21  245 192 654
				6/6/2019       5254 343 42  636 403 789
				6/6/2019       5180 252 23  169 328 888
				6/6/2019       5181 290 32  788 129 745
				6/6/2019       5244 328 44  540 403 989
			'
			
			$Object = @(
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = 6775; 'TRP' = '305'; 'A' = 56; 'B' = 229; 'C' = 132; 'D' = 764}
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = 6910; 'TRP' = '316'; 'A' = 28; 'B' = 356; 'C' = 118; 'D' = 134}
				[pscustomobject]@{'timestamp' = '6/4/2019'; 'streams' = 6749; 'TRP' = '316'; 'A' = 54; 'B' = 218; 'C' = 206; 'D' = 144}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = 5186; 'TRP' = '267'; 'A' = 84; 'B' = 280; 'C' = 452; 'D' = 258}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = 5187; 'TRP' = '240'; 'A' = 33; 'B' = 436; 'C' = 455; 'D' = 245}
				[pscustomobject]@{'timestamp' = '6/5/2019'; 'streams' = 5224; 'TRP' = '291'; 'A' = 21; 'B' = 245; 'C' = 192; 'D' = 654}
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = 5254; 'TRP' = '343'; 'A' = 42; 'B' = 636; 'C' = 403; 'D' = 789}
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = 5180; 'TRP' = '252'; 'A' = 23; 'B' = 169; 'C' = 328; 'D' = 888}
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = 5181; 'TRP' = '290'; 'A' = 32; 'B' = 788; 'C' = 129; 'D' = 745}
				[pscustomobject]@{'timestamp' = '6/6/2019'; 'streams' = 5244; 'TRP' = '328'; 'A' = 44; 'B' = 540; 'C' = 403; 'D' = 989}
			)
			
			$Actual =  ConvertFrom-SourceTable $Table
			,$Actual | Differentiate $Object | Should -Be 0
			
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Differentiate $Object | Should -Be 0

		}
		It 'Powershell extract data from text file and convert to csv' {		# https://stackoverflow.com/q/59328405/1701026

			$Actual = ConvertFrom-SourceTable -Header Count,Address,Mode,Port '
				1        010D.0C93.A02C        Dynamic     Gi1/0/5
				1        011B.782D.6719        Dynamic     Gi1/0/22
				1        0003.4790.B479        Dynamic     Gi1/0/1
				1        0054.B671.1EB8        Dynamic     Gi1/0/2'

			,$Actual | Differentiate @(
				[pscustomobject]@{'Count' = '1'; 'Address' = '010D.0C93.A02C'; 'Mode' = 'Dynamic'; 'Port' = 'Gi1/0/5'},
				[pscustomobject]@{'Count' = '1'; 'Address' = '011B.782D.6719'; 'Mode' = 'Dynamic'; 'Port' = 'Gi1/0/22'},
				[pscustomobject]@{'Count' = '1'; 'Address' = '0003.4790.B479'; 'Mode' = 'Dynamic'; 'Port' = 'Gi1/0/1'},
				[pscustomobject]@{'Count' = '1'; 'Address' = '0054.B671.1EB8'; 'Mode' = 'Dynamic'; 'Port' = 'Gi1/0/2'}
			) | Should -Be 0

		}
	}
	
	Context 'Resolved bugs' {
	
		It 'Single width column at position 0' {

			$Actual = ConvertFrom-SourceTable '
A B    XY   ZY  
- -    --   --  
1 val1 foo1 bar1
2 val2 foo2 bar2
3 val3 foo3 bar3
4 val4 foo4 bar4
5 val5 foo5 bar5
6 val6 foo6 bar6'

			,$Actual | Differentiate @(
				[pscustomobject]@{'A' = '1'; 'B' = 'val1'; 'XY' = 'foo1'; 'ZY' = 'bar1'},
				[pscustomobject]@{'A' = '2'; 'B' = 'val2'; 'XY' = 'foo2'; 'ZY' = 'bar2'},
				[pscustomobject]@{'A' = '3'; 'B' = 'val3'; 'XY' = 'foo3'; 'ZY' = 'bar3'},
				[pscustomobject]@{'A' = '4'; 'B' = 'val4'; 'XY' = 'foo4'; 'ZY' = 'bar4'},
				[pscustomobject]@{'A' = '5'; 'B' = 'val5'; 'XY' = 'foo5'; 'ZY' = 'bar5'},
				[pscustomobject]@{'A' = '6'; 'B' = 'val6'; 'XY' = 'foo6'; 'ZY' = 'bar6'}
			) | Should -Be 0
			
		}

		It 'Here table without ruler with spaces in header' {

			$Actual = ConvertFrom-SourceTable -Literal '
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
 a2270725-3                               13  Disc      2+00:17  7/2/2019 1:50 PM
 a2232655-3                               14  Disc      4+09:54  7/1/2019 2:10 AM
 a2129521-3                               30  Disc      2+04:50  7/1/2019 4:52 AM
 a16991754-3                              49  Disc        22:51  7/1/2019 5:44 AM
 p.vbr.1                                  58  Disc      4+20:19  6/25/2019 11:20 AM
 a16990384-3                              59  Disc         1:43  6/27/2019 10:20 AM
 a2169135-3                               68  Disc      3+00:50  7/2/2019 11:13 AM
 a2289685-3                               79  Disc         6:40  7/2/2019 9:04 PM
>a2310806-3            rdp-tcp#93         85  Active          .  7/1/2019 9:05 AM
 a16991667-3                              98  Disc      3+00:31  6/26/2019 6:35 AM
 a2064837-3                              107  Disc         8:32  7/3/2019 12:47 AM
 a2282463-3                              108  Disc      2+01:51  7/3/2019 8:55 AM
 a2292833-3                              116  Disc      1+21:30  7/3/2019 2:06 PM
 a18005447-3                             126  Disc      8+20:09  6/26/2019 2:48 PM
 a2185113-3                              135  Disc         9:19  6/26/2019 9:14 PM
 a2067993-3                              139  Disc      1+03:58  7/4/2019 8:08 AM
 a2101008-3                              140  Disc         5:10  7/3/2019 10:00 PM
 a2256517-3                              141  Disc      1+03:32  7/4/2019 8:32 AM
 a2340150-3                              142  Disc        12:35  7/4/2019 9:53 PM
 a2076309-3                              143  Disc         3:37  7/5/2019 3:37 AM'

		,$Actual | Differentiate @(
				[pscustomobject]@{'ID' = '13'; 'IDLE TIME' = '2+00:17'; 'LOGON TIME' = '7/2/2019 1:50 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2270725-3'},
				[pscustomobject]@{'ID' = '14'; 'IDLE TIME' = '4+09:54'; 'LOGON TIME' = '7/1/2019 2:10 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2232655-3'},
				[pscustomobject]@{'ID' = '30'; 'IDLE TIME' = '2+04:50'; 'LOGON TIME' = '7/1/2019 4:52 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2129521-3'},
				[pscustomobject]@{'ID' = '49'; 'IDLE TIME' = '22:51'; 'LOGON TIME' = '7/1/2019 5:44 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16991754-3'},
				[pscustomobject]@{'ID' = '58'; 'IDLE TIME' = '4+20:19'; 'LOGON TIME' = '6/25/2019 11:20 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'p.vbr.1'},
				[pscustomobject]@{'ID' = '59'; 'IDLE TIME' = '1:43'; 'LOGON TIME' = '6/27/2019 10:20 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16990384-3'},
				[pscustomobject]@{'ID' = '68'; 'IDLE TIME' = '3+00:50'; 'LOGON TIME' = '7/2/2019 11:13 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2169135-3'},
				[pscustomobject]@{'ID' = '79'; 'IDLE TIME' = '6:40'; 'LOGON TIME' = '7/2/2019 9:04 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2289685-3'},
				[pscustomobject]@{'ID' = '85'; 'IDLE TIME' = '.'; 'LOGON TIME' = '7/1/2019 9:05 AM'; 'SESSIONNAME' = 'rdp-tcp#93'; 'STATE' = 'Active'; 'USERNAME' = '>a2310806-3'},
				[pscustomobject]@{'ID' = '98'; 'IDLE TIME' = '3+00:31'; 'LOGON TIME' = '6/26/2019 6:35 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16991667-3'},
				[pscustomobject]@{'ID' = '107'; 'IDLE TIME' = '8:32'; 'LOGON TIME' = '7/3/2019 12:47 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2064837-3'},
				[pscustomobject]@{'ID' = '108'; 'IDLE TIME' = '2+01:51'; 'LOGON TIME' = '7/3/2019 8:55 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2282463-3'},
				[pscustomobject]@{'ID' = '116'; 'IDLE TIME' = '1+21:30'; 'LOGON TIME' = '7/3/2019 2:06 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2292833-3'},
				[pscustomobject]@{'ID' = '126'; 'IDLE TIME' = '8+20:09'; 'LOGON TIME' = '6/26/2019 2:48 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a18005447-3'},
				[pscustomobject]@{'ID' = '135'; 'IDLE TIME' = '9:19'; 'LOGON TIME' = '6/26/2019 9:14 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2185113-3'},
				[pscustomobject]@{'ID' = '139'; 'IDLE TIME' = '1+03:58'; 'LOGON TIME' = '7/4/2019 8:08 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2067993-3'},
				[pscustomobject]@{'ID' = '140'; 'IDLE TIME' = '5:10'; 'LOGON TIME' = '7/3/2019 10:00 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2101008-3'},
				[pscustomobject]@{'ID' = '141'; 'IDLE TIME' = '1+03:32'; 'LOGON TIME' = '7/4/2019 8:32 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2256517-3'},
				[pscustomobject]@{'ID' = '142'; 'IDLE TIME' = '12:35'; 'LOGON TIME' = '7/4/2019 9:53 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2340150-3'},
				[pscustomobject]@{'ID' = '143'; 'IDLE TIME' = '3:37'; 'LOGON TIME' = '7/5/2019 3:37 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2076309-3'}
			) | Should -Be 0
		}

		It 'Last line contains white spaces and data is floating' {

			$Actual = ConvertFrom-SourceTable '
				Department  Id     Name             Country            Age      ReportsTo
				----------  --     ----             -------            ---      ---------
				Engineering {2, 4} {Bauer, Duval}   {Germany, France}  {31, 21} {4, 5}
				Sales       {3, 1} {Cook, Aerts}    {England, Belgium} {69, 40} {1, 5}
				Engineering {6, 4} {Fischer, Duval} {Germany, France}  {29, 21} {4, 5}
				'

			,$Actual | Differentiate @(
				[pscustomobject]@{'Age' = '{31, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{2, 4}'; 'Name' = '{Bauer, Duval}'; 'ReportsTo' = '{4, 5}'},
				[pscustomobject]@{'Age' = '{69, 40}'; 'Country' = '{England, Belgium}'; 'Department' = 'Sales'; 'Id' = '{3, 1}'; 'Name' = '{Cook, Aerts}'; 'ReportsTo' = '{1, 5}'},
				[pscustomobject]@{'Age' = '{29, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{6, 4}'; 'Name' = '{Fischer, Duval}'; 'ReportsTo' = '{4, 5}'}
			) | Should -Be 0
			
			$Actual = ConvertFrom-SourceTable '
				Department  Id     Name             Country            Age      ReportsTo

				----------  --     ----             -------            ---      ---------

				Engineering {2, 4} {Bauer, Duval}   {Germany, France}  {31, 21} {4, 5}

				Sales       {3, 1} {Cook, Aerts}    {England, Belgium} {69, 40} {1, 5}

				Engineering {6, 4} {Fischer, Duval} {Germany, France}  {29, 21} {4, 5}
'

			,$Actual | Differentiate @(
				[pscustomobject]@{'Age' = '{31, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{2, 4}'; 'Name' = '{Bauer, Duval}'; 'ReportsTo' = '{4, 5}'},
				[pscustomobject]@{'Age' = '{69, 40}'; 'Country' = '{England, Belgium}'; 'Department' = 'Sales'; 'Id' = '{3, 1}'; 'Name' = '{Cook, Aerts}'; 'ReportsTo' = '{1, 5}'},
				[pscustomobject]@{'Age' = '{29, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{6, 4}'; 'Name' = '{Fischer, Duval}'; 'ReportsTo' = '{4, 5}'}
			) | Should -Be 0

			$Actual = ConvertFrom-SourceTable '
				Department  Id     Name             Country            Age      ReportsTo
				
				----------  --     ----             -------            ---      ---------
				
				Engineering {2, 4} {Bauer, Duval}   {Germany, France}  {31, 21} {4, 5}
				
				Sales       {3, 1} {Cook, Aerts}    {England, Belgium} {69, 40} {1, 5}
				
				Engineering {6, 4} {Fischer, Duval} {Germany, France}  {29, 21} {4, 5}
				'

			,$Actual | Differentiate @(
				[pscustomobject]@{'Age' = '{31, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{2, 4}'; 'Name' = '{Bauer, Duval}'; 'ReportsTo' = '{4, 5}'},
				[pscustomobject]@{'Age' = '{69, 40}'; 'Country' = '{England, Belgium}'; 'Department' = 'Sales'; 'Id' = '{3, 1}'; 'Name' = '{Cook, Aerts}'; 'ReportsTo' = '{1, 5}'},
				[pscustomobject]@{'Age' = '{29, 21}'; 'Country' = '{Germany, France}'; 'Department' = 'Engineering'; 'Id' = '{6, 4}'; 'Name' = '{Fischer, Duval}'; 'ReportsTo' = '{4, 5}'}
			) | Should -Be 0
		}
		
		It 'Connect (rulerless) single spaced headers where either column is empty' { # https://stackoverflow.com/q/59541667/1701026
		
			$Actual = ConvertFrom-SourceTable '
				NAME            READY   STATUS    RESTARTS   AGE     IP          NODE   NOMINATED NODE   READINESS GATES
				me-pod-name     2/2     Running   0          6s      10.0.0.10   node1  <none>           <none>
				me-pod-name-2   1/1     Running   0          6d18h   10.0.1.20   node2  <none>           <none>
				me-pod-name-3   1/1     Running   0          11d     10.0.0.30   node3  <none>           <none>'
				
			
		}
		
	}
}
