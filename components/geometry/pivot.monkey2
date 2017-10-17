Namespace game3d

Class Pivot Extends Component

	Method New()
		Super.New( "Pivot" )
	End
	
	Method OnAttach() Override
		Local ent := New Entity
		GameObject.SetEntity( ent )
	End
	
End