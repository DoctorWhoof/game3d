Namespace game3d


Class ChangeColor Extends Component
	
	Public
	Method New()
		Super.New( "ChangeColor" )
	End

	Method OnUpdate() Override
		
		If Time > 1.0
			Cast<Model>(Entity).Materials = New Material[]( New PbrMaterial( New Color( Rnd(), Rnd(), Rnd() ), 0.1, 0.5 ) )
			GameObject.ResetTime()
		End
	End
End