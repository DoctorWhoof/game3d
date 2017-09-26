
Namespace mojo3d.graphics

Class Scene Extension
	
	Method Start()
		For Local e:= Eachin GetRootEntities()
			e.Start()
		Next
	End
	
	Method Update()
		For Local e:= Eachin GetRootEntities()
			e.Update()
		Next
	End
	
	Method Draw( canvas:Canvas )
		For Local e:= Eachin GetRootEntities()
			e.Draw( canvas )
		Next
	End
	
	Method LateUpdate()
		For Local e:= Eachin GetRootEntities()
			e.LateUpdate()
		Next
	End
	
	Method Reset()
		For Local e:= Eachin GetRootEntities()
			e.Reset()
		Next
	End

End
