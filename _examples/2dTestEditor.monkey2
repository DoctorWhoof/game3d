'Basic 'Skeleton' for a GUI based editor.

#Import "<mojox>"
#Import "../game3d"

#Import "../game3d"
#Import "components/circle"
#Import "components/sinePosition"
#Import "components/grid2d"
#Import "../components/geometry/pivot"
#Import "../components/geometry/spriteanim"

#Import "scenes/"
#Import "images/"

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
		Local dock := New GUIView
		ContentView = dock
	End
End

'*******************************************************************

Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
		Style.Font = smallFont
		Layout = "fill"
		devMode = True
		editMode = False
	End
	
	Method OnStart() Override
		GameObject.Load( "asset::test2D.json" )
	End
	
End

'*******************************************************************

Class GUIView Extends DockingView
	
	Field gameView:Game2dView
	
	Method New()
		gameView = New Game2dView( 320, 180 )

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
