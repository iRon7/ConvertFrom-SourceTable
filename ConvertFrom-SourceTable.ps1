#Requires -Modules @{ModuleName="Pester"; ModuleVersion="4.4.0"}

Set-StrictMode -Version 2

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Function Should-BeObject {
	Param (
		[Parameter(Position=0)][Object[]]$b, [Parameter(ValueFromPipeLine = $True)][Object[]]$a
	)
	$Property = ($a | Select-Object -First 1).PSObject.Properties | Select-Object -Expand Name
	$Difference = Compare-Object $b $a -Property $Property
	Try {"$($Difference | Select-Object -First 1)" | Should -BeNull} Catch {$PSCmdlet.WriteError($_)}
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
		'Output' = 'Hello World'
		'PowerShell' = 'Hello World'
		'Type' = 'String'
		'Value' = 'Hello World'
	},
	[PSCustomObject]@{
		'Output' = 123
		'PowerShell' = 123
		'Type' = 'Number'
		'Value' = 123
	},
	[PSCustomObject]@{
		'Output' = ''
		'PowerShell' = $Null
		'Type' = 'Null'
		'Value' = $Null
	},
	[PSCustomObject]@{
		'Output' = 'True'
		'PowerShell' = $True
		'Type' = 'Boolean'
		'Value' = $True
	},
	[PSCustomObject]@{
		'Output' = 'False'
		'PowerShell' = $False
		'Type' = 'Boolean'
		'Value' = $False
	},
	[PSCustomObject]@{
		'Output' = '1963-10-07 9:47:00 PM'
		'PowerShell' = [DateTime]'1963-10-07T21:47:00.0000000'
		'Type' = 'DateTime'
		'Value' = [DateTime]'1963-10-07T21:47:00.0000000'
	},
	[PSCustomObject]@{
		'Output' = '{1, two}'
		'PowerShell' = @(1, 'Two')
		'Type' = 'Array'
		'Value' = @(1, 'Two')
	},
	[PSCustomObject]@{
		'Output' = '{One, Two}'
		'PowerShell' = @{'One' = 1; 'Two' = 2}
		'Type' = 'HashTable'
		'Value' = @{'One' = 1; 'Two' = 2}
	},
	[PSCustomObject]@{
		'Output' = '@{One=1; Two=2}'
		'PowerShell' = [PSCustomObject]@{'One' = 1; 'Two' = 2}
		'Type' = 'Object'
		'Value' = [PSCustomObject]@{'One' = 1; 'Two' = 2}
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}
	}
	
	Context 'Simple markdown table' {
	
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}
	}
	
	Context '(Narrow) markfown version table with and default column types' {
		
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $Object
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
			,$Actual | Should-BeObject $Object
		}

		It 'Raw table from pipeline' {
			$Actual = $Table | ConvertFrom-SourceTable -Literal
			,$Actual | Should-BeObject $Object
		}

		It 'Streamed table lines from pipeline' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -Literal
			,$Actual | Should-BeObject $Object
		}
	}
	
	
	Context 'Floating table' {
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
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			)
		}

		It 'Raw table, floating: ON' {
			$Actual = ConvertFrom-SourceTable -Floating $Table
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			)
		}
	
		It 'Raw table, floating: OFF' {
			$Actual = ConvertFrom-SourceTable -Floating:$False $Table
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			)
		}
	
		It 'Streamed table lines, floating: AUTO' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			)
		}

		It 'Streamed table lines, floating: ON' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -Floating
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Name' = 'Black'; 'Value' = 0}
				[PSCustomObject]@{'Name' = 'White'; 'Value' = 255}
			)
		}
	
		It 'Streamed table lines, floating: OFF' {
			$Actual = ($Table -Split '[\r\n]+') | ConvertFrom-SourceTable -Floating:$False
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Information' = 'on the table'}
				[PSCustomObject]@{'Information' = 'Name  Value'}
				[PSCustomObject]@{'Information' = 'Black     0'}
				[PSCustomObject]@{'Information' = 'White   255'}
			)
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

		It 'Fixing headerless indefinable alignment with combined header(/ruler) parameter' {
			
			$Actual = ConvertFrom-SourceTable -Header '    C1--- ---C2' '
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
		[PSCustomObject]@{'Color' = 'Red'},
		[PSCustomObject]@{'Color' = 'Green'},
		[PSCustomObject]@{'Color' = 'Yellow'}
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
			,$Actual | Should-BeObject $RGB
		}

		It 'Right aligned' {
		
			$Actual = ConvertFrom-SourceTable '
				   Color
				   -----
				   "Red"
				 "Green"
				"Yellow"
			'
			,$Actual | Should-BeObject $RGB
		}

		It 'Blank lines at the top and bottom' {
		
			$Actual = ConvertFrom-SourceTable '
			
			
				Color
				-----
				Red
				Green
				Yellow
			
			
			'
			,$Actual | Should-BeObject $RGB
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
			,$Actual | Should-BeObject $RGB
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
			,$Actual | Should-BeObject $RGB
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
			,$Actual | Should-BeObject $RGB
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
			,$Actual | Should-BeObject $RGB
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

			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'A' = '1'; 'B' = 'val1'; 'XY' = 'foo1'; 'ZY' = 'bar1'},
				[PSCustomObject]@{'A' = '2'; 'B' = 'val2'; 'XY' = 'foo2'; 'ZY' = 'bar2'},
				[PSCustomObject]@{'A' = '3'; 'B' = 'val3'; 'XY' = 'foo3'; 'ZY' = 'bar3'},
				[PSCustomObject]@{'A' = '4'; 'B' = 'val4'; 'XY' = 'foo4'; 'ZY' = 'bar4'},
				[PSCustomObject]@{'A' = '5'; 'B' = 'val5'; 'XY' = 'foo5'; 'ZY' = 'bar5'},
				[PSCustomObject]@{'A' = '6'; 'B' = 'val6'; 'XY' = 'foo6'; 'ZY' = 'bar6'}
				)
			
		}

		It 'Fixed issue with here table without ruler with spaces in header' {

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

			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'ID' = '13'; 'IDLE TIME' = '2+00:17'; 'LOGON TIME' = '7/2/2019 1:50 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2270725-3'},
				[PSCustomObject]@{'ID' = '14'; 'IDLE TIME' = '4+09:54'; 'LOGON TIME' = '7/1/2019 2:10 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2232655-3'},
				[PSCustomObject]@{'ID' = '30'; 'IDLE TIME' = '2+04:50'; 'LOGON TIME' = '7/1/2019 4:52 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2129521-3'},
				[PSCustomObject]@{'ID' = '49'; 'IDLE TIME' = '22:51'; 'LOGON TIME' = '7/1/2019 5:44 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16991754-3'},
				[PSCustomObject]@{'ID' = '58'; 'IDLE TIME' = '4+20:19'; 'LOGON TIME' = '6/25/2019 11:20 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'p.vbr.1'},
				[PSCustomObject]@{'ID' = '59'; 'IDLE TIME' = '1:43'; 'LOGON TIME' = '6/27/2019 10:20 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16990384-3'},
				[PSCustomObject]@{'ID' = '68'; 'IDLE TIME' = '3+00:50'; 'LOGON TIME' = '7/2/2019 11:13 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2169135-3'},
				[PSCustomObject]@{'ID' = '79'; 'IDLE TIME' = '6:40'; 'LOGON TIME' = '7/2/2019 9:04 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2289685-3'},
				[PSCustomObject]@{'ID' = '85'; 'IDLE TIME' = '.'; 'LOGON TIME' = '7/1/2019 9:05 AM'; 'SESSIONNAME' = 'rdp-tcp#93'; 'STATE' = 'Active'; 'USERNAME' = '>a2310806-3'},
				[PSCustomObject]@{'ID' = '98'; 'IDLE TIME' = '3+00:31'; 'LOGON TIME' = '6/26/2019 6:35 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a16991667-3'},
				[PSCustomObject]@{'ID' = '107'; 'IDLE TIME' = '8:32'; 'LOGON TIME' = '7/3/2019 12:47 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2064837-3'},
				[PSCustomObject]@{'ID' = '108'; 'IDLE TIME' = '2+01:51'; 'LOGON TIME' = '7/3/2019 8:55 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2282463-3'},
				[PSCustomObject]@{'ID' = '116'; 'IDLE TIME' = '1+21:30'; 'LOGON TIME' = '7/3/2019 2:06 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2292833-3'},
				[PSCustomObject]@{'ID' = '126'; 'IDLE TIME' = '8+20:09'; 'LOGON TIME' = '6/26/2019 2:48 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a18005447-3'},
				[PSCustomObject]@{'ID' = '135'; 'IDLE TIME' = '9:19'; 'LOGON TIME' = '6/26/2019 9:14 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2185113-3'},
				[PSCustomObject]@{'ID' = '139'; 'IDLE TIME' = '1+03:58'; 'LOGON TIME' = '7/4/2019 8:08 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2067993-3'},
				[PSCustomObject]@{'ID' = '140'; 'IDLE TIME' = '5:10'; 'LOGON TIME' = '7/3/2019 10:00 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2101008-3'},
				[PSCustomObject]@{'ID' = '141'; 'IDLE TIME' = '1+03:32'; 'LOGON TIME' = '7/4/2019 8:32 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2256517-3'},
				[PSCustomObject]@{'ID' = '142'; 'IDLE TIME' = '12:35'; 'LOGON TIME' = '7/4/2019 9:53 PM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2340150-3'},
				[PSCustomObject]@{'ID' = '143'; 'IDLE TIME' = '3:37'; 'LOGON TIME' = '7/5/2019 3:37 AM'; 'SESSIONNAME' = ''; 'STATE' = 'Disc'; 'USERNAME' = 'a2076309-3'}
				)
		}
	}
}

