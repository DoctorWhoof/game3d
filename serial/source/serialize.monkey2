Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

Using std..
Using mojo..

'Extracts JsonValue value from a variant, recursive for arrays and objects
Function JsonValueFromVariant:JsonValue( v:Variant )
	Local newValue:JsonValue
	Local info:= v.Type
	
	If info.Kind = "Unknown"
		Prompt( "Warning: Property cannot be reflected and can't be serialized." )
	Elseif info.Kind = "Array"
		Select info.Name
		Case "Float[]"
			newValue = New JsonArray( GetJsonStack<JsonNumber,Float>( v ) )
		Case "Double[]"
			newValue = New JsonArray( GetJsonStack<JsonNumber,Double>( v ) )
		Case "String[]"
			newValue = New JsonArray( GetJsonStack<JsonString,String>( v ) )
		Case "Bool[]"
			newValue = New JsonArray( GetJsonStack<JsonBool,Bool>( v ) )
		Case "game3d.Component[]"
			newValue = New JsonArray( GetJsonStack<JsonObject,game3d.Component>( v ) )
		Default
			Print( "Serialize warning: Unrecognized array type" )
		End
	Else
		Select info.Name
		Case "Float"
			newValue = New JsonNumber( Cast<Float>( v ) )
		Case "Double"
			newValue = New JsonNumber( Cast<Double>( v ) )
		Case "Int"
			newValue = New JsonNumber( Cast<Int>( v ) )
		Case "UInt"
			newValue = New JsonNumber( Cast<UInt>( v ) )
		Case "String"
			newValue = New JsonString( Cast<String>( v ) )
		Case "Bool"
			newValue = New JsonBool( Cast<Bool>( v ) )
		Default
			Local obj := New JsonObject
			If info.Kind="Class" or info.Kind="Interface"
				obj.Merge( SerializeDecls( v.Type, v ) )				'shouldn't be necessary?
				obj.Merge( SerializeDecls( v.Type.SuperType, v ) )		'shouldn't be necessary?
				obj.Merge( SerializeDecls( v.DynamicType, v ) )
			Else
				obj.Merge( SerializeDecls( v.Type, v ) )
			End
			newValue = obj
		End
	End

	Prompt( newValue.ToJson() )
	Return newValue
End


'Iterates and serializes each of an object's Properties and fields
Function SerializeDecls:JsonObject( type:TypeInfo, instance:Variant )
	Local newObj:= New JsonObject
	newObj.SetString( "Class", type.Name )

	For Local decl:DeclInfo = Eachin type.GetDecls()
		If ( decl.Kind = "Property" And decl.Settable ) Or ( decl.Kind = "Field" And Not decl.Name.StartsWith("_") )
			If decl.Type.Name.Slice( 0, 7 ) = "Unknown"
				Prompt( "Warning: Property " + decl.Name + " cannot be reflected and can't be serialized." )
			Else
				newObj.Serialize( decl.Name, decl.Get( instance ) )
				Prompt( decl.Name + "=" + VariantToString( decl.Get( instance ) ) )
			End
		End
	Next
	Return newObj
End


'Array helper
Function GetJsonStack<T,V>:Stack<JsonValue>( v:Variant )
	Assert( ( v.Type.Kind = "Array" ), "GetJsonStack: Variant " + v.Type.Name + " is not an array" )
	Local stack := New Stack<JsonValue>
	Local arr := Cast<V[]>( v )
	For Local element := Eachin arr
		stack.Push( JsonValueFromVariant( element ) )
	Next
	Return stack
End

