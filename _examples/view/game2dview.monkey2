Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
	End
	
	
	Method OnUpdate() Override
		If Keyboard.KeyDown( Key.Left )
			Camera2D.X -= 1
		Elseif Keyboard.KeyDown( Key.Right )
			Camera2D.X += 1
		End
		If Keyboard.KeyDown( Key.Up )
			Camera2D.Y -= 1
		Elseif Keyboard.KeyDown( Key.Down )
			Camera2D.Y += 1
		End
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		'Grid
		canvas.Color = New Color( 0.37, 0.37, 0.37 )
		Local spacing := 16
		Local x0 := Quantize( Camera2D.Left, spacing )
		Local y0 := Quantize( Camera2D.Top, spacing )
		Local x1 := Quantize( Camera2D.Right, spacing )
		Local y1 := Quantize( Camera2D.Bottom, spacing )
		For Local x :Int = x0 To x1 Step spacing
			For Local y :Int = y0 To y1 Step spacing
				canvas.DrawLine( x, y0, x, y1 )
				canvas.DrawLine( x0, y, x1, y )
			Next
		Next
		'Origin
		canvas.Color = New Color( 0.3, 0.3, 0.3 )
		canvas.DrawLine( x0, 0, x1, 0 )
		canvas.DrawLine( 0, y0, 0, y1 )
	End
	
End