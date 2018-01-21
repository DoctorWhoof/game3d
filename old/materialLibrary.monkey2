Namespace game3d

Class MaterialLibrary
	
	Private
	Global _allMaterials := New Map< String,Material >
	Global _allMaterialNames := New Map< Material, String >
	
	Global _allTextures := New Map< String,Texture >
	Global _allTextureNames := New Map< Texture, String >
	Global _allTexturePaths := New Map< String, String >
	
	Public
	
	Function Clear()
		_allMaterials.Clear()
		_allMaterialNames.Clear()
		_allTextures.Clear()
		_allTextureNames.Clear()
		_allTexturePaths.Clear()
	End
	
	'******************************** materials '********************************
	
	Function AddMaterial( name:String, mat:Material )
		_allMaterials.Add( name, mat )
		_allMaterialNames.Add( mat, name )
	End
	
	Function GetMaterial:Material( name:String )
		If Not name Return Null
		Return _allMaterials[ name ]	
	End
	
	Function GetName:String( mat:Material )
		Return _allMaterialNames[ mat ]	
	End
	
	Function Remove( mat:Material )
		Local name := GetName( mat )
		If name Then _allMaterials.Remove( name )
		_allMaterialNames.Remove( mat )
	End
	
	Function AllMaterials:Map< String,Material >()
		Return _allMaterials
	End
	
	'******************************** textures '********************************
	
	Function AddTexture( name:String, tex:Texture )
		_allTextures.Add( name, tex )
		_allTextureNames.Add( tex, name )
	End
	
	Function AddTexturePath( name:String, path:String )
		_allTexturePaths.Add( name, path )
	End
	
	Function GetTexture:Texture( name:String )
		If Not name Return Null
		Return _allTextures[ name ]	
	End
	
	Function GetTexturePath:String( name:String )
		If Not name Return Null
		Return _allTexturePaths[ name ]	
	End
	
	Function GetName:String( tex:Texture )
		Return _allTextureNames[ tex ]	
	End
	
	Function AllTextures:Map< String,Texture >()
		Return _allTextures
	End
	
End

