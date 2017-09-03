Class Spin Extends Component
	Method New()
		Super.New( "Spin" )	
	End

	Method OnUpdate() Override
		Entity.Rotate( 0, 1, 0, True )
	End
End