
Class DonutRenderer Extends Component
	Field material := New PbrMaterial( New Color( Rnd(0.3, 1.0), Rnd(0.3, 1.0), Rnd(0.3, 1.0) ), 0.1, 0.5 )
	
	Method New()
		Super.New( "ModelRenderer" )
	End
	
	Method OnStart() Override
		Entity = Model.CreateTorus( 2, .5, 48, 24, material )
	End
End