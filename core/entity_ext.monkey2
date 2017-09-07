#Import "component"

Class Entity Extension
	
	Method 	AddComponent( comp:Component )
		Local box:= ComponentBox.GetFromEntity( Self )
		If Not box
			box = New ComponentBox( Self )
			Print( "Entity '" + Name + "': Created new component box" )
		End
		box.AddComponent( comp )
		'To do: Add listeners for destroyed, hidden and shown
	End
	
	Method GetComponent<T>:T( name:String )
		Local box:= ComponentBox.GetFromEntity( Self )
		Return box.GetComponent<T>( name )
	End
	
	
	Method GetComponentBySuperClass<T>:T( sup:String )
		Local box:= ComponentBox.GetFromEntity( Self )
		Return box.GetComponentBySuperClass<T>( name )
	End
	
	
	Method GetComponentBox:ComponentBox()
		Return ComponentBox.GetFromEntity( Self )
	End
	
End