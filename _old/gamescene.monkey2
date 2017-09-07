
Namespace game3d

Using mojo..
Using std..

Class GameScene

	Public
	Field name := "Scene"
	Field root := New Stack<GameObj>
	Field scene3D :Scene					'mojo3d scene
	
	Private
	Global _allScenes := New Stack<GameScene>
	Global _current :GameScene

	'****************** Public functions ******************

	Public
	Function Current:GameScene()
		Return _current
	End
	
'	Function SetCurrent:GameScene( scn:GameScene )
'		_current = scn
'		Scene.SetCurrent( scn.scene3D )
'		Return _current
'	End
	
	'****************** Public methods ******************
	
	Method New( name:String, include3DScene:Bool = False )
		_allScenes.Add( Self )
		Self.name = name
		If include3DScene
			scene3D = New Scene	
		End
		_current = Self
	End

	Method Update()
		For Local obj := Eachin root
			obj.Update()
		Next
	End

	Method LateUpdate()
		For Local obj := Eachin root
			obj.LateUpdate()
		Next
	End

	Method Start()
		For Local obj := Eachin root
			obj.Start()
		Next
	End

	Method Draw( canvas:Canvas )
		For Local obj := Eachin root
			obj.Draw( canvas )
		Next
	End

'	Method LateDraw( canvas:Canvas)
'		For Local obj := Eachin root
'			obj.LateDraw( canvas )
'		Next
'	End
'	
'	Method GuiDraw( canvas:Canvas)
'		For Local obj := Eachin root
'			obj.GuiDraw( canvas )
'		Next
'	End

	Method Reset()
		Print( "Resetting scene " + name )
		For Local obj := Eachin root
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
