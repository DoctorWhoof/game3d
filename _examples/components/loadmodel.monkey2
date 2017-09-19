Namespace game3d

Class LoadModel Extends Component
	
	Field path:= ""
	
	Public
	Method New( path:String )
		Super.New( "LoadModel" )
		Self.path = path
	End
	
	Method OnStart() Override
		Local model := Cast<Model>( Entity )
		Assert( model, "LoadModel: Entity needs to be of 'Model' class" )
		model.Mesh = Mesh.Load( path )
	End
End