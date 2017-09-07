Namespace game3d

Class SinePosition Extends Component
	
	Field x:Double = 10.0
	Field y:Double = 10.0
	Field z:Double = 0.0
	Field period:Double = 1.0
	
	Method New( period:Double, x:Double, y:Double, z:Double )
		Super.New( "SinePosition" )
		Self.period = period
		Self.x = x
		Self.y = y
		Self.z = z
	End
	
	Method OnUpdate() Override
		Local time := Clock.Now() * TwoPi * period
		Entity.Position = New Vec3f( Sin(time)*x, Cos(time)*y, Cos(time)*z )
	End
End