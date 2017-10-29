
Namespace game3d


Class AssignMaterial Extends Component
	
	Field material:String
	
	Method New()
		Super.New( "AssignMaterial" )
	End
	
'	Method New( mat:String )
'		Super.New( "AssignMaterial" )
'		material = mat
'	End
	
	Method OnStart() Override
		Local model := Cast<Model>( Entity )
		Assert( model, "LoadModel: Entity needs to be of 'Model' class" )
		
		Local materialFromName := mojo3d.Material.Get( material )
		If materialFromName
			model.Materials = New Material[]( materialFromName )
		Else
			Print "AssignMaterial: Warning, material " + material + " not found."
			model.Materials = New Material[]( New PbrMaterial( Color.Grey ) )
		End
	End
	
End
