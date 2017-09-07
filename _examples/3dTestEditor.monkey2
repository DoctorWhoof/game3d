#Import "../game3d"
#Import "view/game3dview"
#Import "<mojo>"
#Import "<mojox>"

Using std..
Using mojo..
Using mojox..
Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End


Class TestWindow Extends Window
	Public
	Method New()					
		Super.New( "Test", 1280, 600, WindowFlags.Resizable )
		Local dock := New GameDock
		ContentView = dock
	End
End


Class GameDock Extends DockingView
	
	Field gameView:Game3dView
	Field panSpeed := 10.0
	Field click := New Vec2i
	
	Method New()
		gameView = New Game3dView( 320, 180, True )
		gameView.Style.Font = smallFont
		gameView.displayInfo = True
'		gameView.editMode = True
'		gameView.autoRender = False
		gameView.Camera.Move( 0, 5, -10 )
		gameView.Camera.PointAt( New Vec3f )
		gameView.Layout = "fill"
		
		Local toolbar := New ToolBar( Axis.X )
		toolbar.Style = Self.Style.Copy()
		toolbar.Style.BackgroundColor = Color.Grey
		toolbar.MinSize = New Vec2i( 200,32 )
		AddView( toolbar, "top", "32", False  )
		
		Local graph := New ScrollView
		graph.Style = Self.Style.Copy()
		graph.Style.BackgroundColor = Color.Grey
		AddView( graph, "right", "400", True  )
		
		ContentView = gameView
		Style.BackgroundColor = Color.Black
	End
	
	Method OnMouseEvent( event:MouseEvent ) Override
		'To do: instead of pivot entity, rotate around target using Translation based on sin/cos, then PointAt( target )
		If Mouse.ButtonDown( MouseButton.Left )
			If Keyboard.KeyDown( Key.LeftAlt ) 
				Local diff := New Vec2i( gameView.ViewMouse.X - click.X, gameView.ViewMouse.Y - click.Y )
				gameView.Camera.Parent.Rotate( diff.Y/2.0, -diff.X/2.0, 0, True )
				gameView.Camera.Parent.Rz = 0
				click.X = gameView.ViewMouse.X
				click.Y = gameView.ViewMouse.Y
				App.RequestRender()
			End
		End
		Select event.Type
		Case EventType.MouseClick
			click.X = gameView.ViewMouse.X
			click.Y = gameView.ViewMouse.Y
		Case EventType.MouseWheel
			If event.Modifiers = Modifier.LeftAlt
				'Zoom with alt + wheel
				gameView.Camera.LocalZ += ( ( Exp( event.Wheel.Y/100.0 ) - 1.0 ) * panSpeed )
				gameView.Camera.LocalX += ( ( Exp( event.Wheel.X/100.0 ) - 1.0 ) * panSpeed )
			Else
				'Pan with wheel (two fingers on touchpad)
				gameView.Camera.LocalX += ( ( Exp( event.Wheel.X/100.0 ) - 1.0 ) * panSpeed )
				gameView.Camera.LocalY += ( ( Exp( event.Wheel.Y/100.0 ) - 1.0 ) * panSpeed )
			End
			App.RequestRender()
		End
	End
End































