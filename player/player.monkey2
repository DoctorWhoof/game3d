
Namespace player

#Import "HumanPlayer"
#Import "AIPlayer"

#Import "subroutine"
Using subroutine..

Const hit := 1
Const hold := 2
Const hitAndSustain := 4

Class Player

	Global list 			:= New List<Player>		'list to keep track of all available players

	Field name				:= "PlayerName"

	Field continuousMove	:= False				'false for Pac-Man or Snake style control (reads KeyHit, instead of KeyDown)
	Field preventFlip		:= False				'prevents direction from changing 180 degrees (like in a Snake game)
	Field directionStacking	:= True					'Allows direction commands to stay until they're manually cleared by a component (i.e. MotionGrid )
	Field stackingLimit		:= 2

	Protected
	Field controls 			:= New Map< Key, Control >
	Field suspended			:= False
	Field commands			:= New StringStack		'commands list, here's where the magic happens
	Field directions		:= New StringStack		'some movements require a stack of directions ("Snake" style), so I'll keep track of directions separately

	'****************************** Public Properties ******************************

	Public
	Property IsEmpty:Bool()
		If commands.Empty And directions.Empty Then Return True Else Return False
	End

	Property Commands:Bool()
		Return commands
	End

	Property Directions:Bool()
		Return directions
	End

	'****************************** Public Methods ******************************

	Method New( name:String )
		name = "name"
		list.AddLast( Self )
	End

	'WARNING: New style! commads are erased every update, to allow multiple entities using the same player
	'Downside: LateUpdates that use player an be unpredictable (use a command that was issued by a different entity )
	Method Update()
		If Not continuousMove
			directions.Clear()
		End
		commands.Clear()
		If Not suspended
			OnUpdate()			'Receive input And issue commands
		end
	End


	Method Suspend( length:Double )
		suspended = True
		Delay( length, Lambda()
			suspended = False
		End )
	End


	Method Resume()
		suspended = False
	End


	Method IssueCommand( code:String, clear:Bool= False )
		Select code
		Case "Up", "Down", "Left", "Right"
			If clear Then directions.Clear()
			directions.Push( code )
		Default
			If clear Then commands.Clear()
			commands.Push( code )
		End
	End


	Method HasOrdered:Bool(key:String)
		Select key
		Case "Up", "Down", "Left", "Right"
			If directions.Contains( key ) Return True
		Default
			If commands.Contains( key ) Return True
		End
		Return False
	End


	Method SetControl( key:Key, command:String, style:Int )
		If controls.Contains( key ) Then controls.Remove( key )
		controls.Add( key, New Control( Self, key, command, style ) )
	End


	Method List()
		For local d := EachIn directions
			Echo( d )
		Next
		For local c := EachIn commands
			Echo( c )
		Next
	End


	' Method GetTopDirection:Int()
	' 	If Not directions.IsEmpty()
	' 		Return directions.Top()
	' 	Else
	' 		Return ""
	' 	End
	' End


	' Method RemoveTopDirection:Int()
	' 	If Not directions.IsEmpty()
	' 		Return directions.Pop()
	' 	End
	' End


	' Method WaitLag:Int(MyLag:Int)				'Returns True If the specified lag has elapsed
	' 	If TimeRef = 0
	' 		TimeRef = Millisecs()				'Starts counting
	' 		Return True
	' 	Else
	' 		If TimeRef < Millisecs() - MyLag	'Compares it with MyLag
	' 			TimeRef = 0
	' 			Return False
	' 		End
	' 	End
	' End

	'****************************** Virtual Methods ******************************

	'Replace this method to issue commands when creating your own player class (i.e. AI opponents)
	Method OnUpdate() Virtual
	End

End


'***************************************************************************************************

Class Control
	Field key:Key
	Field command:String
	Field style:Int

	Private
	Field player:Player

	Public
	Method New( player:Player, key:Key, command:String, style:Int )
		Self.player = player
		Self.command = command
		Self.key = key
		Self.style = style
	End

	Method Update()
		Select style
			Case hold
				If Keyboard.KeyDown( key ) Then player.IssueCommand( command )
			Case hit
				If Keyboard.KeyPressed( key, False ) Then player.IssueCommand( command )
			Case hitAndSustain
				If Keyboard.KeyPressed( key, False ) Then player.IssueCommand( command )
				If Keyboard.KeyDown( key ) Then player.IssueCommand( "Sustain" + command )
		End
	End
End
