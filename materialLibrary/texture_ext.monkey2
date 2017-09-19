Namespace mojo.graphics

Class Texture Extension
	
	Property Name:String()
		Return MaterialLibrary.GetName( Self )
	Setter( name:String )
		MaterialLibrary.AddTexture( name, Self )	
	End
	
	
	Property Path:String()
		Return MaterialLibrary.GetTexturePath( Name )
	Setter( path:String )
		MaterialLibrary.AddTexturePath( Name, path )	
	End
	
	
	Function Get:Texture( name:String )
		Return MaterialLibrary.GetTexture( name )
	End
	
	
	Function Load:Texture( path:String, name:String, flags:TextureFlags )
		Local tex := Texture.Load( path, flags )
		tex.Name = name
		tex.Path = path
		Return tex
	End
	
	
	Method ToJson:JsonObject()
		Local json := New JsonObject
		json.SetString( "Path", Path )
		json.SetNumber( "Flags", Int(Flags) )
		Return json
	End
	
End