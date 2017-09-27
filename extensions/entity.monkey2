Namespace mojo3d.graphics

#Import "component"


Class Entity Extension
'	
'	Property Components:Component[]()
'		Local box:= EntityBox.GetFromEntity( Self )
'		If Not box
'			box = New EntityBox( Self )
'		End
'		Return box.Components	
'	End
'	
'	'************************************* Public Methods *************************************
'	
'	
'	Method 	AddComponent<T>:T( comp:T ) Where T Extends Component
'		Local box:= EntityBox.GetFromEntity( Self )
'		If Not box
'			box = New EntityBox( Self )
'		End
'		box.AddComponent( comp )
'		Return comp
'		'To do: Add listeners for destroyed, hidden and shown
'	End
'	
'	
'	Method GetComponent<T>:T( name:String ) Where T Extends Component
'		Return EntityBox.GetFromEntity( Self ).GetComponent<T>( name )
'	End
'
'	
'	
'	Method GetComponentBySuperClass<T>:T( sup:String ) Where T Extends Component
'		Return EntityBox.GetFromEntity( Self ).GetComponentBySuperClass<T>( name )
'	End
'	
''	'Marked for removal
''	Method GetEntityBox:EntityBox()
''		Return EntityBox.GetFromEntity( Self )
''	End
''	
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
'	
'	Method ToJson:JsonObject()
'		Local json:= New JsonObject
'		For Local c := Eachin Components
'			json.SetObject( c.Name, c.ToJsonValue().ToObject() )
'		Next
'		Return json
'	End

	Method Start()
		Local obj := GameObject.GetFromEntity( Self )
		obj.Start()
		For Local c := Eachin Children
			c.Start()
		Next
	End

	Method Update()
		GameObject.GetFromEntity( Self ).Update()
		For Local c := Eachin Children
			c.Update()
		Next
	End
	
	Method Draw( canvas:Canvas )
		GameObject.GetFromEntity( Self ).Draw( canvas )
		For Local c := Eachin Children
			c.Draw( canvas )
		Next
	End
	
	Method LateUpdate()
		GameObject.GetFromEntity( Self ).LateUpdate()
		For Local c := Eachin Children
			c.LateUpdate()
		Next
	End
	
	Method Reset()
		GameObject.GetFromEntity( Self ).Reset()
		For Local c := Eachin Children
			c.Reset()
		Next
	End
'	
'	'************************************* Public Functions *************************************
'	
'Function Find:Entity( name:String )
''		Return EntityBox
'	Return Null
'End
	
End


