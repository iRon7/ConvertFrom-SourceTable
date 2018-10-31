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

Describe 'ConvertFrom-Table' {
	
	Context 'Examples' {
	
		It 'Simple Format-Table output' {
		
			$Actual = ConvertFrom-SourceTable '
				Department  Name    Country
				----------  ----    -------
				Sales       Aerts   Belgium
				Engineering Bauer   Germany
				Sales       Cook    England
				Engineering Duval   France
				Marketing   Evans   England
				Engineering Fischer Germany
			'
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{'Country' = 'Belgium'; 'Department' = 'Sales'; 'Name' = 'Aerts'},
				[PSCustomObject]@{'Country' = 'Germany'; 'Department' = 'Engineering'; 'Name' = 'Bauer'},
				[PSCustomObject]@{'Country' = 'England'; 'Department' = 'Sales'; 'Name' = 'Cook'},
				[PSCustomObject]@{'Country' = 'France'; 'Department' = 'Engineering'; 'Name' = 'Duval'},
				[PSCustomObject]@{'Country' = 'England'; 'Department' = 'Marketing'; 'Name' = 'Evans'},
				[PSCustomObject]@{'Country' = 'Germany'; 'Department' = 'Engineering'; 'Name' = 'Fischer'}
			)
		}

		$ColorObject = @(
			[PSCustomObject]@{'Name' = 'Black'; 'RGB' = @(0,0,0); 'Value' = 0},
			[PSCustomObject]@{'Name' = 'White'; 'RGB' = @(255,255,255); 'Value' = 16777215},
			[PSCustomObject]@{'Name' = 'Red'; 'RGB' = @(255,0,0); 'Value' = 16711680},
			[PSCustomObject]@{'Name' = 'Lime'; 'RGB' = @(0,255,0); 'Value' = 65280},
			[PSCustomObject]@{'Name' = 'Blue'; 'RGB' = @(0,0,255); 'Value' = 255},
			[PSCustomObject]@{'Name' = 'Yellow'; 'RGB' = @(255,255,0); 'Value' = 16776960},
			[PSCustomObject]@{'Name' = 'Cyan'; 'RGB' = @(0,255,255); 'Value' = 65535},
			[PSCustomObject]@{'Name' = 'Magenta'; 'RGB' = @(255,0,255); 'Value' = 16711935},
			[PSCustomObject]@{'Name' = 'Silver'; 'RGB' = @(192,192,192); 'Value' = 12632256},
			[PSCustomObject]@{'Name' = 'Gray'; 'RGB' = @(128,128,128); 'Value' = 8421504},
			[PSCustomObject]@{'Name' = 'Maroon'; 'RGB' = @(128,0,0); 'Value' = 8388608},
			[PSCustomObject]@{'Name' = 'Olive'; 'RGB' = @(128,128,0); 'Value' = 8421376},
			[PSCustomObject]@{'Name' = 'Green'; 'RGB' = @(0,128,0); 'Value' = 32768},
			[PSCustomObject]@{'Name' = 'Purple'; 'RGB' = @(128,0,128); 'Value' = 8388736},
			[PSCustomObject]@{'Name' = 'Teal'; 'RGB' = @(0,128,128); 'Value' = 32896},
			[PSCustomObject]@{'Name' = 'Navy'; 'RGB' = @(0,0,128); 'Value' = 128}
		)

		It 'Multi type color source table' {
		
			$Actual = ConvertFrom-SourceTable '
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
			,$Actual | Should-BeObject $ColorObject
		}
		
		It 'Multi type color markup table' {
		
			$Actual = ConvertFrom-SourceTable '
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
			,$Actual | Should-BeObject $ColorObject
		}

		It 'Directory' {
		
			$Actual = ConvertFrom-SourceTable '
				Mode    [DateTime]LastWriteTime         Length Name
				----    -----------------------         ------ ----
				-a---l  2018-04-16   7:15 PM              4071 ConvertFrom-Table.Tests.ps1
				-a---l  2018-04-22   9:19 PM              3104 ConvertFrom-Table.ps1
			'
			
			,$Actual | Should-BeObject @(
				[PSCustomObject]@{
					'LastWriteTime' = [DateTime]'2018-04-16T19:15:00.0000000'
					'Length' = 4071
					'Mode' = '-a---l'
					'Name' = 'ConvertFrom-Table.Tests.ps1'
				},
				[PSCustomObject]@{
					'LastWriteTime' = [DateTime]'2018-04-22T21:19:00.0000000'
					'Length' = 3104
					'Mode' = '-a---l'
					'Name' = 'ConvertFrom-Table.ps1'
				}
			)

		}
	}
	
	Context 'Type conversion' {

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

		It 'Source table from String' {
		
			$Actual = ConvertFrom-SourceTable '
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
			,$Actual | Should-BeObject $TypeObject
		}

		It 'Source table from pipeline' {
		
			$Actual = Get-Content .\SourceTable.txt | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $TypeObject
		}

		It 'Markdown table from string' {
		
			$Actual = ConvertFrom-SourceTable '
				|-----------|--------------------|---------------------------------|-----------------------|
				| Type      |              Value |                      PowerShell | Output                |
				|-----------|--------------------|---------------------------------|-----------------------|
				| String    | Hello World        |                   "Hello World" | Hello World           |
				| Number    |                123 |                             123 |                   123 |
				| Null      |               Null |                           $Null |                       |
				| Boolean   |               True |                           $True | True                  |
				| Boolean   |              False |                          $False | False                 |
				| DateTime  | D 1963-10-07T21:47 |    [DateTime]"1963-10-07 21:47" | 1963-10-07 9:47:00 PM |
				| Array     |           1, "Two" |                     @(1, "Two") | {1, two}              |
				| HashTable |    @{One=1; Two=2} |                 @{One=1; Two=2} | {One, Two}            |
				| Object    |  O @{One=1; Two=2} | [PSCustomObject]@{One=1; Two=2} | @{One=1; Two=2}       |
				|-----------|--------------------|---------------------------------|-----------------------|
			'
			,$Actual | Should-BeObject $TypeObject
		}

		It 'Markdown table from pipeline' {
		
			$Actual = Get-Content .\MarkdownTable.txt | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $TypeObject
		}

		It 'Markdown table from pipeline' {
		
			$Actual = Get-Content .\MarkdownTable.txt | ConvertFrom-SourceTable
			,$Actual | Should-BeObject $TypeObject
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
			
			$Actual.C1 | Should -Be 1
			$Actual.C2 | Should -Be '2'
			
		}

		It 'Indefinable alignment' {
			
			$Actual = ConvertFrom-SourceTable '
				C1       C2
				--       --
				11 ,2 1, 22
			'
			
			$Actual.C1 | Should -Be 11
			$Actual.C2 | Should -Be '22'
			
		}

		It 'Real life alignment example' {
		
			$Actual = ConvertFrom-SourceTable '
				Mod Ports Module-Type                        Model          Status
				--- ----- -----------                        -----          ------
				  1    48 2/4/8/10/16 Gbps Advance FC Module DS-X9448-768K9 ok
				  2    48 2/4/8/10/16 Gbps Advance FC Module DS-X9448-768K9 ok
				  3     0 Supervisor Module-3                DS-X97-SF1-K9  ha-standby
				  4     0 Supervisor Module-3                DS-X97-SF1-K9  ha-standby
			'
			,$Actual | Should-BeObject @(
					[PSCustomObject]@{
							'Mod' = 1
							'Ports' = 48
							'Module-Type' = '2/4/8/10/16 Gbps Advance FC Module'
							'Model' = 'DS-X9448-768K9'
							'Status' = 'ok'
					},
					[PSCustomObject]@{
							'Mod' = 2
							'Ports' = 48
							'Module-Type' = '2/4/8/10/16 Gbps Advance FC Module'
							'Model' = 'DS-X9448-768K9'
							'Status' = 'ok'
					},
					[PSCustomObject]@{
							'Mod' = 3
							'Ports' = 0
							'Module-Type' = 'Supervisor Module-3'
							'Model' = 'DS-X97-SF1-K9'
							'Status' = 'ha-standby'
					},
					[PSCustomObject]@{
							'Mod' = 4
							'Ports' = 0
							'Module-Type' = 'Supervisor Module-3'
							'Model' = 'DS-X97-SF1-K9'
							'Status' = 'ha-standby'
					}
			)
		}
	}
		
	Context 'Source table without header ruler' {
	
		It 'Name- value' {
		
			$Actual = ConvertFrom-SourceTable '
				Name Value
				A        1
				B        2
			'
			$Actual[0].Name | Should -Be "A"; $Actual[0].Value | Should -Be 1
			$Actual[1].Name | Should -Be "B"; $Actual[1].Value | Should -Be 2
		}
	}

	Context 'Source table with space in header name' {
	
		It 'Name- value' {
		
			$Actual = ConvertFrom-SourceTable '
				Name Value
				----------
				A        1
				B        2
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
}

