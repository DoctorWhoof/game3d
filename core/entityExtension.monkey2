#Import "component"

Class Entity Extension
	
	Method 	AddComponent( comp:Component )
		Local box:= EntityBox.GetFromEntity( Self )
		If Not box
			box = New EntityBox( Self )
			Print( "Entity '" + Name + "': Created new component box" )
		End
		box.AddComponent( comp )
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
	
	
	Method GetComponentBox:EntityBox()
		Return EntityBox.GetFromEntity( Self )
	End
	
End