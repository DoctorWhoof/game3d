Namespace game3d


Class LoadModel Extends Component
	
	Field path:= ""
	
	Method New()
		Super.New( "LoadModel" )
	End
	
	Method OnAttach() Override
		Local model := Model.Load( path )
		GameObject.SetEntity( model )
		Print GameObject.Name + " materials:" + model.Mesh.NumMaterials
	End
	
End