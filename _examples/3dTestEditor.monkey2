#Import "../game3d"
#Import "view/game3dview"
#Import "../util/navigation"
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
	
	Method New()
		gameView = New Game3dView( 320, 180, True )
		gameView.Style.Font = smallFont
		gameView.displayInfo = True
'		gameView.editMode = True
		gameView.autoRender = False
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
		Navigate3D( gameView, event )
	End
	
End































