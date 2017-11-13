Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

#Import "source/serialize"
#Import "source/deserialize"
#Import "source/variant_ext"
'#Import "source/util"

Using std..
Using mojo..

Global verbose := False

Class JsonValue Extension
	
	Method ToFloat:Float()
		Return Float( ToNumber() )
	End
	
	Method ToInt:Int()
		Return Int( ToNumber() )
	End
	
	Method ToUInt:UInt()
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
	
	
	Method Serialize( v:Variant )
		Local value := Cast<JsonObject>( JsonValueFromVariant( v ) )
		Merge( value )
	End
	
	
	Method Serialize( key:String, v:Variant )
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