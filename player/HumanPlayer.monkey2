Namespace player

Class HumanPlayer Extends Player
	'BUG: sharing the same player among many entity instances currently doesn't work - but it should!
	'Apparently, KeyPressed is cleared after being checked, instead of once per frame...

	Method New( name:String )
		Super.New( name )
		SetControl( Key.Up, "Up", hold )
		SetControl( Key.Down, "Down", hold )
		SetControl( Key.Left, "Left", hold )
		SetControl( Key.Right, "Right", hold )
		SetControl( Key.Z, "UseItem", hitAndSustain )
		SetControl( Key.X, "Jump", hitAndSustain )
	End

	Method OnUpdate() Override
		For Local c := Eachin controls.Values
			c.Update()
		Next
	End

End
