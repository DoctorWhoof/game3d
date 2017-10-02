Namespace game3d


Class Spin Extends Component
	
	Field x:Double, y:Double, z:Double

	Method New()
		Super.New( "Spin")
	End
	
'	Method New( x:Double, y:Double, z:Double )
'		Super.New( "Spin" )
'		Self.x = x
'		Self.y = y
'		Self.z = z
'	End
'
	Method OnUpdate() Override
		Entity.Rotate( x, y, z, True )
	End
End