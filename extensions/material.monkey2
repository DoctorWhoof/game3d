Namespace mojo3d.graphics

Class Material Extension

	Property Name:String()
		Return MaterialLibrary.GetName( Self )
	Setter( name:String )
		MaterialLibrary.AddMaterial( name, Self )
	End

	Function Get:Material( name:String )
		Local mat := MaterialLibrary.GetMaterial( name )
		If mat
			Return mat
		End
		Return Null
	End
	
	'************************* serialization *************************
	
	Method ToJson:JsonObject()
		Local json := New JsonObject
		json.Serialize( Name, Variant( Self ) )
		
		For Local d := Eachin InstanceType.GetDecls()
			If d.Kind = "Property" And d.Settable
				
				If d.Type.Name = "mojo.graphics.Texture"
					Local t := Cast<Texture>( d.Get( Self ) )
					Cast<JsonObject>( json[Name] ).SetString( d.Name, t.Name )
				End
				
				If d.Type.Name = "std.graphics.Color"
					Local c := Cast<Color>( d.Get( Self ) )
					Cast<JsonObject>( json[Name] ).SetArray( d.Name, c.ToJsonArray() )
				End
				
			End
		End
		
		Return json
	End


	Function FromJson( json:JsonObject )
		Local v := BasicDeserialize( json.ToObject() )
		Local info := v.DynamicType
		
		If v.Type.Name = "Material"
			Print "Material!!!"	
		End
	End
	
End
