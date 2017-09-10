#Import "component"

Class Entity Extension
	
	Method 	AddComponent<T>:T( comp:T ) Where T Extends Component
		Local box:= EntityBox.GetFromEntity( Self )
		If Not box
			box = New EntityBox( Self )
			Print( "Entity '" + Name + "': Created new component box" )
		End
		box.AddComponent( comp )
		Return comp
		'To do: Add listeners for destroyed, hidden and shown
	End
	
	Method GetComponent<T>:T( name:String )
		Local box:= EntityBox.GetFromEntity( Self )
		Return box.GetComponent<T>( name )
	End
	
	
	Method GetComponentBySuperClass<T>:T( sup:String )
		Local box:= EntityBox.GetFromEntity( Self )
		Return box.GetComponentBySuperClass<T>( name )
	End
	
'	'Marked for removal if not proven necessary
'	Method GetEntityBox:EntityBox()
'		Return EntityBox.GetFromEntity( Self )
'	End
'	
	'Preserves current world space transform when changing parent
	Method SwitchParent( newParent:Entity )
		Local oldPos := Position
		Local oldRot := Rotation
		Local oldScl := Scale
		Parent = newParent
		Position = oldPos
		Rotation = oldRot
		Scale = oldScl
	End
	
End