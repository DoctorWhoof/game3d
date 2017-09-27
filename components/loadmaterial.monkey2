
Namespace game3d


Class LoadMaterial Extends Component
	
	Property Material:String()
		Return _material
	Setter( m:String )
		_material = m
	End
	
	Private
	Field _material:String
	
	Public
	Method New()
		Super.New( "LoadMaterial" )
	End
	

	Method New( mat:String )
		Super.New( "LoadMaterial" )
		Material = mat
	End


	Method OnStart() Override
		Local model := Cast<Model>( Entity )
		Assert( model, "LoadModel: Entity needs to be of 'Model' class" )
		model.Materials = New Material[]( mojo3d.graphics.Material.Get( _material ) )
	End
	
End
