Namespace game3d


Class ChangeColor Extends Component
	
	Public
	Method New()
		Super.New( "ChangeColor" )
	End

	Method OnUpdate() Override
		If Keyboard.KeyHit( Key.Space )
			Cast<Model>(Entity).Materials = New Material[]( New PbrMaterial( New Color( Rnd(), Rnd(), Rnd() ), 0.1, 0.5 ) )
		End
	End
End