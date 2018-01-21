
Namespace subroutine

Class Subroutine

	Global routines := New Stack< Subroutine >
	
	'these fields alter the interval in a random fashion
	Field minRandom := 0.0
	Field maxRandom := 0.0
	Field owner := "none"
	
	Protected
	Field func :Void()		'The function to be executed
	Field length :Double	'interval, in seconds
	
	Field loop :Bool
	Field startTime	:Double
	Field randomTime :Double
	Field paused := False
	Field dead := False

		
	Public
	'Length of interval measured in seconds
	Method New( length:Double, loop:Bool, func:Void(), owner:String = Null )
		Self.length = length
		Self.func = func
		Self.loop = loop
		Self.startTime = Clock.Now()
		If owner <> Null Then Self.owner = owner
		routines.Push( Self )
	End
	
	Method Update( time:Double )
		If time >= ( startTime + length + randomTime )
			func()
			If loop
				If ( minRandom<>0.0 ) Or ( maxRandom<>0.0 )
					randomTime = Rnd( minRandom, maxRandom )
				End
				startTime = time
			Else
				dead = True
			End
		End
	End
	
	'***********************************************************************************************
	
	Function UpdateAll( time:Double )
		For Local r := Eachin routines
			If Not r.paused Then r.Update( time )
		Next
		'Delete dead routines
		Local it:= routines.All()
		While Not it.AtEnd
			Local item:=it.Current
			If item.dead it.Erase() Else it.Bump()
		Wend
	End
	
	Function KillByOwner( ownerName:String )
		Print( "Attempting to kill " + ownerName )
		If ownerName
			For Local s := Eachin routines
				If s.owner = ownerName
					s.dead = True
					Print( "Killed routine owned by " + s.owner )
				End
			Next
		End		
	End

End


Function Delay:Subroutine( length:Double, func:Void(), loop:Bool = False )
	Local newDelay := New Subroutine( length, loop, func )
	Return newDelay
End