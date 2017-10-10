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
		
		json.Serialize( Variant( Self ) )
		
'		For Local d := Eachin InstanceType.GetDecls()
'			If d.Kind = "Property" Or d.Kind = "Field"
'				Select d.Type.Kind
'				Case "Primitive"
'					json.Serialize( d.Name, d.Get( Self ))
'				Case "Class"
'					If d.Type.Name = "mojo.graphics.Texture"
'						Local t := Cast<Texture>( d.Get( Self ) )
'						json.SetString( d.Name, t.Name )
'					Else
'						json.Serialize( d.Name, d.Get( Self ))
'					End
'				End
'			End
'		End
		
		Return json
	End
'	
'	
'	Function FromJson:Texture( json:JsonObject )
'		Local flags:TextureFlags = IntFlags( UInt( json[ "Flags"].ToNumber() ) )
'		Local name:= json[ "Name"].ToString()
'		Local path := json[ "Path"].ToString()
'		Return Load( name, path, flags )
'	End
	
End
