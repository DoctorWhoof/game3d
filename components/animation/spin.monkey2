Namespace game3d


Class Spin Extends Component
	
	Field x:Double, y:Double, z:Double

	Method New()
		Super.New( "Spin")
	End
	
	Method OnUpdate() Override
		Entity.Rotate( x, y, z, True )
	End
End