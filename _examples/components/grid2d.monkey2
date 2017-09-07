Namespace game3d

Class Grid2D Extends Component
	
	Field x:Double = 0.0
	Field y:Double = 0.0
	Field radius:Double = 32.0
	
	Method New()
		Super.New( "Grid2DRenderer" )
	End
	
	Method OnDraw( canvas:Canvas ) Override
		'Grid
		canvas.Color = New Color( 0.37, 0.37, 0.37 )
		Local spacing := 16
		Local x0 := Quantize( Viewer.Camera2D.Left, spacing )
		Local y0 := Quantize( Viewer.Camera2D.Top, spacing )
		Local x1 := Quantize( Viewer.Camera2D.Right, spacing )
		Local y1 := Quantize( Viewer.Camera2D.Bottom, spacing )
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
		canvas.Color = Color.White
	End
End