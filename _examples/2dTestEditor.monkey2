#Import "../game3d"
#Import "view/game2dview"
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
		Super.New( "Test", 1680, 1050, WindowFlags.Resizable )
		Local rgtDock := New GameDock
		ContentView = rgtDock
	End
End


Class GameDock Extends DockingView
	Method New()
		Local gameView := New Game2DView( 320, 180 )
		gameView.Style.Font = smallFont
		gameView.Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
		
		Local toolbar := New ToolBar( Axis.X )
		toolbar.Style.BackgroundColor = Color.Grey
		toolbar.MinSize = New Vec2i( 200,32 )
		AddView( toolbar, "top", "32", False  )
		
		Local graph := New ScrollView
		graph.Style.BackgroundColor = Color.Grey
		AddView( graph, "right", "400", True  )
		
		ContentView = gameView
	End
End
