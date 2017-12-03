Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

Using std..
Using mojo..

'Simply creates the object, doesn't load any values into it
Function BasicDeserialize:Variant( obj:StringMap<JsonValue>, constructorArgTypes:TypeInfo = Null, arguments:Variant[] = Null )
	
	Local v:Variant
	
	If obj["Class"]
	 	Local objClass:= obj["Class"].ToString()
		Local info := TypeInfo.GetType( objClass )
		If info
			Local constructor := info.GetDecl( "New" )
			If constructor
				v = constructor.Invoke( Null, Null )
			Else
				If( Not arguments = Null ) And ( Not constructorArgTypes = Null )
					constructor = info.GetDecl( "New", constructorArgTypes )
					v = constructor.Invoke( Null, arguments )
				Else
					Print( "Deserialize: Error, Invalid constructor arguments type or arguments." )
				End
			End
		Else
			Print( "Deserialize: Class " + objClass + " not found." )
		End
	End
	
	If v = Null Then Print( "Deserialize: Nothing to return." )
	Return v
End


'Creates a new object, then loads its properties with optional filtering.
Function LoadFromJsonObject:Variant( obj:StringMap<JsonValue>, include:StringStack = Null, exclude:StringStack = Null )
	
	Local v := BasicDeserialize( obj )
	Local info := v.DynamicType
	
	Assert( info.Kind <> "Void", "~nDeserialize Error: Invalid Class? (Hint: Is the required class source file properly imported?~n" )
				
	For Local key := EachIn obj.Keys
		If key = "Class" Continue
		If include
			If Not include.Empty
				If Not include.Contains( key ) Continue	
			End
		End
		If exclude
			If Not exclude.Empty
				If exclude.Contains( key ) Continue
			End
		End
		
		Local d:= info.GetDecl( key )
		Local value := LoadFromJsonValue( v, obj[key], d )
		Prompt( key + " = " + VariantToString( value ) )
	Next
	
	Return v

End


'Use this if the target object has already been created, and all you want is to load its properties
Function GetPropertiesFromJsonObject( target:Variant, json:JsonObject, include:StringStack = Null, exclude:StringStack = Null )

	json.GetValue( "Name" ).ToString()
	For Local d := Eachin target.DynamicType.GetDecls()
		
		If include
			If Not include.Empty
				If Not include.Contains( d.Name ) Continue	
			End
		End
		If exclude
			If Not exclude.Empty
				If exclude.Contains( d.Name ) Continue
			End
		End
		If ( d.Kind = "Property" And d.Settable ) Or ( d.Kind = "Field" And Not d.Name.StartsWith("_") )
			Local value := LoadFromJsonValue( target, json.GetValue( d.Name ), d )
			Prompt( d.Name + " = " + VariantToString( value ) )
		End
		
	Next
End


'loads a single value into an existing object.
Function LoadFromJsonValue:Variant( v:Variant, valueName:String, jsonValue:JsonValue )
	Local info := v.DynamicType
	Local d:= info.GetDecl( valueName )
	Local value := LoadFromJsonValue( v, jsonValue, d )
	Return v
End


'Our main workhorse, recursively loads a properly cast JasonValue into an object's Declaration.
Function LoadFromJsonValue:Variant( v:Variant, value:JsonValue, d:DeclInfo )	
	Local newVar:Variant
	If Not value Return Null
	If value.IsNumber	
		newVar = Variant( value.ToNumber() )
		If d And v
			Local properV :Variant
			Select d.Type.Name
			Case "Float"
				properV = Variant( Float( value.ToNumber() ) )
			Case "Double"
				properV = Variant( Double( value.ToNumber() ) )
			Case "Int"
				properV = Variant( Int( value.ToNumber() ) )
			Case "UInt"
				properV = Variant( UInt( value.ToNumber() ) )
			End
			d.Set( v, properV )
		End
	ElseIf value.IsString
		newVar = Variant( value.ToString() )
		If d And v Then d.Set( v, newVar )
	ElseIf value.IsBool
		newVar = Variant( value.ToBool() )
		If d And v Then d.Set( v, newVar )
	ElseIf value.IsObject
		newVar = LoadFromJsonObject( value.ToObject() )
		If d And v Then d.Set( v, newVar )
	ElseIf value.IsArray
		Local jsonArr := value.ToArray()
		If Not jsonArr.Empty
			Local first := jsonArr[0]
			
			If first.IsNumber
				newVar = JsonArrayToVariantArray<Double>( jsonArr )
			Elseif first.IsString
				newVar = JsonArrayToVariantArray<String>( jsonArr )
			Elseif first.IsBool
				newVar = JsonArrayToVariantArray<Bool>( jsonArr )
			Elseif first.IsObject
				newVar = JsonArrayToVariantArray<game3d.Component>( jsonArr )
'				newVar = JsonArrayToVariantArray<Object>( jsonArr )
			End
			
			d.Set( v, newVar )
		End
	End
	
	Return newVar
End


'Array helper
Function JsonArrayToVariantArray<T>:Variant( jsonArr:Stack<JsonValue> )
	Local arr := New T[ jsonArr.Length ]
	For Local n := 0 Until jsonArr.Length
		Local value:= LoadFromJsonValue( Null, jsonArr[n], Null )
		arr[ n ] = Cast<T>( value )
	Next
	Return Variant( arr )
End
