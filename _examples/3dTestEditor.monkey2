#Import "../game3d"
#Import "view/game3dview"
#Import "view/scenetreeview"
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
		Super.New( "Test", 1280, 960, WindowFlags.Resizable )
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
		gameView.editMode = True
		gameView.autoRender = False
		gameView.Layout = "fill"
		
		gameView.Camera.Move( 0, 3, -8 )
		gameView.Camera.PointAt( New Vec3f )
		
		Local toolbar := New ToolBar( Axis.X )
		toolbar.Style.BackgroundColor = Color.Grey
		toolbar.MinSize = New Vec2i( 200,32 )
		AddView( toolbar, "top", "32", False  )
'		
'		Local graph := New ScrollView
'		graph.Style = Self.Style.Copy()
'		graph.Style.BackgroundColor = Color.DarkGrey
'		AddView( graph, "right", "200", True  )

		Local tree := New SceneTreeView
		tree.Style.Font = smallFont
		tree.ContentView.Style.Font = smallFont
		tree.Style.BackgroundColor = Color.DarkGrey
		AddView( tree, "right", "200", True  )
		
		Local treeToolbar := New ToolBar( Axis.X )
		treeToolbar.MinSize = New Vec2i( 200,20 )
		treeToolbar.Style.BackgroundColor = Color.DarkGrey
		tree.AddView( treeToolbar, "top", "30", False  )
		
		Local buttonTreeRefresh := New Button( "Refresh" )
		treeToolbar.AddView( buttonTreeRefresh )
		
		buttonTreeRefresh.Clicked = Lambda()
			tree.Refresh( Scene.GetCurrent() )
		End
		
		gameView.StartDone = Lambda()
			tree.Refresh( Scene.GetCurrent() )
		End
		
		ContentView = gameView
		Style.BackgroundColor = Color.Black
	End

End































