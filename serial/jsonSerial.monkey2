Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

#Import "source/serialize"
#Import "source/deserialize"
#Import "source/variant_ext"
#Import "source/util"

Using std..
Using mojo..

Global verbose := False

Class JsonValue Extension
	
	Method ToFloat:Float()
		Return Float( ToNumber() )
	End
	
	Method ToInt:Float()
		Return Int( ToNumber() )
	End
	
	Method ToUInt:Float()
		Return UInt( ToNumber() )
	End
		
End


Class JsonObject Extension
	
	Method Merge( json:JsonObject )
		Local otherMap := json.ToObject()
		
		For Local k := Eachin otherMap.Keys
			Local value := otherMap[ k ]
			If value.IsNumber
				SetNumber( k, value.ToNumber() )
			ElseIf value.IsString
				SetString( k, value.ToString() )
			ElseIf value.IsBool
				SetBool( k,  value.ToBool() )
			ElseIf value.IsObject
				SetObject( k, value.ToObject() )
			ElseIf value.IsArray
				SetArray( k, value.ToArray() )
			End
		Next
	End
	
	
	Method Serialize( key:String, v:Variant )
		
'		Print "~n" + key
'		Local type := v.Type
'		If v.Type.Kind = "Class" Or v.Type.Kind = "Interface"
'			For Local d := Eachin v.DynamicType.GetDecls()
'				If d.Kind = "Method"
'					Print d
'				End
'			Next
'			If v.Type.GetDecl( "ToJson" )
'				Print "ToJson method found!"	
'			End
'		End
			
		Local value := JsonValueFromVariant( v )

		If value.IsNumber
			SetNumber( key, value.ToNumber() )
		Elseif value.IsString
			SetString( key, value.ToString() )
		Elseif value.IsBool
			SetBool( key, value.ToBool() )
		Elseif value.IsObject
			SetObject( key, value.ToObject() )
		ElseIf value.IsArray
			SetArray( key, value.ToArray() )
		End
	End
	
	
	Method Serialize( v:Variant )
		
		Local json := New JsonObject
		For Local d := Eachin v.DynamicType.GetDecls()
			If d.Kind = "Property" Or d.Kind = "Field"
				If d.Settable
					If Not d.Name.StartsWith( "_" )
						Select d.Type.Kind
						Case "Primitive"
							json.Serialize( d.Name, d.Get( v ) )
						Case "Class","Interface"
							If d.Type.Name = "mojo.graphics.Texture"
								Local t := Cast<Texture>( d.Get( v ) )
								json.SetString( d.Name, t.Name )
							Else
								json.Serialize( d.Name, d.Get( v ))
							End
						End
					End
				End
			End
		End
		
		Merge( json )
	End
	
	
	Method Deserialize()
		If Not Empty
			For Local key := EachIn Self.ToObject().Keys
				Prompt( key )
				LoadFromJsonObject( Self[ key ].ToObject(), Null, Null )
			Next
		End
	End
	
End


Function Prompt( text:String )
	If verbose Print text
End