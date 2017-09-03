#Import "../game3d"
#Import "<mojo>"
#Import "<mojox>"

Using std..
Using mojo..
Using mojox..
Using game3d..

Function Main()
	New AppInstance
	New Test
	App.Run()
End

Class Test Extends Window
	Public
	Method New()					
		Super.New( "Test", 1680, 1050, WindowFlags.Resizable )
		Local rgtDock := New GameDock
		ContentView = rgtDock
	End
End

Class GameDock Extends DockingView
	
	Method New()
		Local gameView := New GameView( 320, 180 )
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


Class GameView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		render3DScene = False
	End
	
	
	Method OnUpdate() Override
		If Keyboard.KeyDown( Key.Left )
			camera2D.X -= 1
		Elseif Keyboard.KeyDown( Key.Right )
			camera2D.X += 1
		End
		If Keyboard.KeyDown( Key.Up )
			camera2D.Y -= 1
		Elseif Keyboard.KeyDown( Key.Down )
			camera2D.Y += 1
		End
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		'Grid
'		canvas.Clear( _bgColor )
		canvas.Color = New Color( 0.37, 0.37, 0.37 )
		Local spacing := 16
		Local x0 := Quantize( camera2D.Left, spacing )
		Local y0 := Quantize( camera2D.Top, spacing )
		Local x1 := Quantize( camera2D.Right, spacing )
		Local y1 := Quantize( camera2D.Bottom, spacing )
		For Local x :Int = x0 To x1 Step spacing
			For Local y :Int = y0 To y1 Step spacing
				canvas.DrawLine( x, y0, x, y1 )
				canvas.DrawLine( x0, y, x1, y )
			Next
		Next
		'Origin
		canvas.Color = New Color( 0.3, 0.3, 0.3 )
		canvas.DrawLine( -300, 0, 300, 0 )
		canvas.DrawLine( 0, -300, 0, 300 )
	End
	
End