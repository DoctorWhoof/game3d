
Namespace game3d


Class AssignMaterial Extends Component
	
	Field material:String
	
	Method New()
		Super.New( "AssignMaterial" )
	End
	
	Method OnStart() Override
		Local model:= Cast<Model>( Entity )
		Local morpher := Cast<Morpher>( Entity )
		Assert( model Or morpher, "LoadModel: Entity needs to be of 'Model' class" )
		
		Local materialFromName := mojo3d.Material.Get( material )
		If materialFromName
			If model
				model.Materials = New Material[]( materialFromName )
				Print Name + ": " + material + " assigned to model " + GameObject.Name
			Else If morpher
				morpher.material = materialFromName
				Print Name + ": " + material + " assigned to morpher " + GameObject.Name
			End
			
		Else
			Print "AssignMaterial: Warning, material " + material + " not found."
			model.Materials = New Material[]( New PbrMaterial( Color.Grey ) )
		End
	End
	
End
