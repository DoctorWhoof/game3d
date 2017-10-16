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
		If name
			Local tex := MaterialLibrary.GetTexture( name )
			If Not tex
				Print( "Texture: Error, texture " + name + " not found")
			Else
				Return MaterialLibrary.GetTexture( name )
			End
		End
		Return Null
	End
	
	
	Function Create:Texture( name:String, path:String, flags:TextureFlags )
		Local tex := Texture.Load( path, flags )
		Assert( tex, "Texture: Load fail" )
		tex.Name = name
		tex.Path = path
		Return tex
	End
	
	'************************* serialization *************************
	
	Method ToJson:JsonObject()
		Local json := New JsonObject
		json.SetString( "Name", Name )
		json.SetString( "Path", Path )
		json.SetNumber( "Flags", UInt( Flags ) )
		Return json
	End
	
	
	Function FromJson:Texture( json:JsonObject )
		Local flags:TextureFlags = IntFlags( UInt( json[ "Flags"].ToNumber() ) )
		Local name:= json[ "Name"].ToString()
		Local path := json[ "Path"].ToString()
		Return Create( name, path, flags )
	End
	
	'****************************** I/O ******************************
	
	Function Save:JsonObject( path:String )
		Local json := New JsonObject

		For Local name := Eachin MaterialLibrary.AllTextures().Keys
			json.SetObject( name, Get(name).ToJson().ToObject() )
		End
	
		SaveString( json.ToJson(), path )
		Return json
	End
	
	
	Function Load( path:String )
		Local json := JsonObject.Load( path )
		Assert( json, "Texture: Json load fail" )
			
		For Local obj := Eachin json.ToObject().Values
			If obj.IsObject
				Texture.FromJson( Cast<JsonObject>( obj ) )	
			End
		Next
	End
	
End



Function IntFlags:TextureFlags( value:UInt )
	Local flags:= TextureFlags.None
	If value & $0001 Then flags |= TextureFlags.WrapS
	If value & $0002 Then flags |= TextureFlags.WrapT
	If value & $0004 Then flags |= TextureFlags.Filter
	If value & $0008 Then flags |= TextureFlags.Mipmap
	If value & $0100 Then flags |= TextureFlags.Dynamic
	If value & $0200 Then flags |= TextureFlags.Cubemap
	Return flags
End

