Namespace mojo3d.graphics

Class Model Extension
	
	Method AssignMaterial( mat1:Material, mat2:Material=Null, mat3:Material=Null, mat4:Material=Null )
		If mat2
			If mat3
				If mat4
					Materials = New Material[]( mat1, mat2, mat3, mat4 )
				End
				Materials = New Material[]( mat1, mat2, mat3 )
			End
			Materials = New Material[]( mat1, mat2 )
		End
		Materials = New Material[]( mat1 )
	End
	
	Method AssignMaterial( mat1:String, mat2:String=Null, mat3:String=Null, mat4:String=Null )
		AssignMaterial(	MaterialLibrary.GetMaterial( mat1 ),
						MaterialLibrary.GetMaterial( mat2 ),
						MaterialLibrary.GetMaterial( mat3 ),
						MaterialLibrary.GetMaterial( mat4 ) )
	End
	
End