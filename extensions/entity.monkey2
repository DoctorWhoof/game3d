Namespace mojo3d.graphics


Class Entity Extension

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
	
End


