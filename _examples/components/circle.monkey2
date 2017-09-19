Namespace game3d

Class Circle Extends Component
	
	Field radius:Double = 32.0
	
	Method New( radius:Double)
		Super.New( "CircleRenderer" )
		Self.radius = radius
	End
	
	Method OnDraw( canvas:Canvas ) Override
		canvas.DrawCircle( Entity.X, Entity.Y, radius )
	End
End