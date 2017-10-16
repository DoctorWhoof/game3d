Namespace mojo3d.graphics

Class Material Extension

	Property Name:String()
		Return MaterialLibrary.GetName( Self )
	Setter( name:String )
		MaterialLibrary.Remove( Self )
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
	'To do: Clean this up if serialization ever supports Class extensions
	'To do: Serialization function that supports "customizing" specific properties
	
	Method ToJson:JsonObject()
		Local json := New JsonObject
		Local v := Variant( Self )
		json.Serialize( v )
		
		For Local d := Eachin InstanceType.GetDecls()
			If d.Kind = "Property" And d.Settable
				
				Select d.Type.Name
				Case "mojo.graphics.Texture"
					Local t := Cast<Texture>( d.Get( Self ) )
					json.SetString( d.Name, t.Name )
				Case "std.graphics.Color"
					Local c := Cast<Color>( d.Get( Self ) )
					json.SetArray( d.Name, c.ToJsonArray() )
				End
				
			End
		End
		
		json.SetString( "Name", Name )
		Return json
	End


	Function FromJson( json:JsonObject )
		Local v := BasicDeserialize( json.ToObject(), Typeof<Void(Bool)>, New Variant[](False) )	'desired constructor is New( Bool )
		Local info := v.DynamicType
		
		For Local d := Eachin info.GetDecls()
			If d.Kind = "Property" And d.Settable

				Select d.Type.Name
				Case "mojo.graphics.Texture"
					Local tex := Texture.Get( json[d.Name].ToString() )
					If tex Then d.Set( v, Variant( tex ) )	
				Case "std.graphics.Color"
					Local arr := Cast<JsonArray>(json[d.Name])
					Local color := Color.FromJsonArray( arr )
					If color Then d.Set( v, Variant( color ) )
				Default
					LoadFromJsonValue( v, d.Name, json[d.Name] )
				End
				
			End
		Next

		Cast<Material>(v).Name = json["Name"].ToString()
	End
	
	'****************************** I/O ******************************

	Function Save:JsonObject( path:String )
		Local json := New JsonObject
		
		For Local name := Eachin MaterialLibrary.AllMaterials().Keys
			json.SetObject( name, Get(name).ToJson().ToObject() )
		End
		
		SaveString( json.ToJson(), path )
		Return json
	End
	
	
	Function Load( path:String )
		Local json := JsonObject.Load( path )
		Assert( json, "Material: Json load fail")
		
		For Local obj := Eachin json.ToObject().Values
			If obj.IsObject
				Material.FromJson( Cast<JsonObject>( obj ) )	
			End
		Next
	End
	
End
