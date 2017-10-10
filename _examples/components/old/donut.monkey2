Namespace game3d

Class Donut Extends Component
	
	Private
	Field radius:Double, sectionRadius:Double
	
	Public
	Method New( radius:Double, sectionRadius:Double )
		Super.New( "ModelRenderer" )
		Self.radius = radius
		Self.sectionRadius = sectionRadius
	End
	
	Method OnStart() Override
		Local model := Cast<Model>( Entity )
		model.Mesh = Mesh.CreateTorus( radius, sectionRadius, 48, 24 )
		model.Material = New PbrMaterial( New Color( Rnd(0.3, 1.0), Rnd(0.3, 1.0), Rnd(0.3, 1.0) ), 0.1, 0.5 )
	End
End