#Import "../game3d"
#Import "<mojo>"
#Import "<mojox>"

#Import "view/game2dview"
#Import "../util/navigation"

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
		Super.New( "Test", 1680, 1050, WindowFlags.Resizable )
		Local dock := New GameDock
		ContentView = dock
	End
End


Class GameDock Extends DockingView
	
	Field gameView:Game2dView
	
	Method New()
		gameView = New Game2dView( 320, 180 )
		gameView.Style.Font = smallFont
		gameView.displayInfo = True
		gameView.editMode = False
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
	End
	
	Method OnMouseEvent( event:MouseEvent ) Override
		Navigate2D( gameView, event,,400 )
	End
	
End
