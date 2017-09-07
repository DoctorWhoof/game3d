Namespace game3d

Class CircleRenderer Extends Component
	
	Field x:Double = 0.0
	Field y:Double = 0.0
	Field radius:Double = 32.0
	
	Method New()
		Super.New( "CircleRenderer" )
	End
	
	Method OnDraw( canvas:Canvas ) Override
		canvas.DrawCircle( x, y, radius )
	End
End