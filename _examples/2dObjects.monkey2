
#Import "../game3d"
#Import "components/donutRenderer"
#Import "components/spriteRenderer"
#Import "components/cardRenderer"
#Import "components/spin"

#Import "images/cats.png"
#Import "images/cat.png"
#Import "images/blob.png"
#Import "images/blob.json"

Using game3d..

Function Main()
	New AppInstance
	New Test
	App.Run()
End


Class Test Extends Game

	Method New()
		Super.New( "Test", 960, 540 )
		render3DScene = False
		ClearColor = New Color( 0.4, 0.4, 0.4 )
	End
	

	Method OnStart() Override
		currentScene.ClearColor = Color.DarkGrey
		camera2D.SetSize( 320, 180 )
		
		Local node := New GameObj( "Node" )
		node
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
