
Namespace game3d

Using mojo..
Using std..

Class Scene

	Public

	Field name := "Scene"
	Field index := 0

	Field gameObjs := New Stack<GameObj>
	Field color:= Color.White

	Global allScenes := New Stack<Scene>
	Global current :Scene

	Public
	
	Method New()
		allScenes.Add( Self )
		If Not current Then current = Self
	End

	Method Update()
		For obj = Eachin gameObjs
			obj.Update()
		Next
	End

	Method LateUpdate()
		For obj = Eachin gameObjs
			obj.LateUpdate()
		Next
	End

	Method Start()
		For obj = Eachin gameObjs
			obj.Start()
		Next
	End

	Method Draw( canvas:Canvas )
		For obj = Eachin gameObjs
			obj.Draw( canvas )
		Next
	End

	Method LateDraw( canvas:Canvas)
		For obj = Eachin gameObjs
			obj.LateDraw( canvas )
		Next
	End
	
	Method GuiDraw( canvas:Canvas)
		For obj = Eachin gameObjs
			obj.GuiDraw( canvas )
		Next
	End

	Method Reset()
		Print( "Resetting scene " + name )
		For obj = Eachin gameObjs
			obj.Reset()
		Next
	End


'	Method UpdateCollisions()
'		For lyr = Eachin layers
'			lyr.UpdateCollisions()
'		Next
'	End
'
'	Method PauseUpdate:Void()
'		For lyr = Eachin layers
'			lyr.PauseUpdate()
'		Next
'	End
'	   
'	Method PauseEnter:Void()
'		For lyr = Eachin layers
'			lyr.PauseEnter()
'		Next
'	End
'	   
'	Method PauseExit:Void()
'		For lyr = Eachin layers
'			lyr.PauseExit()
'		Next
'	End
'		
'	Method StoreInitialState()
'		Print( "Storing state for scene " + name )
'		For lyr = Eachin layers
'			lyr.StoreInitialState()
'		Next			
'	End

End
