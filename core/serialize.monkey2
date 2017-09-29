Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

Using std..
Using mojo..

Class JsonValue Extension
	
	Method ToFloat:Float()
		Return Float( ToNumber() )
	End
		
End


Class JsonObject Extension 
	
	Method Merge( key:String, json:JsonObject )
		If Contains( key )
			Local map := ToObject()[ key ].ToObject()
			Local otherMap := json.ToObject()
			
			For Local k := Eachin otherMap.Keys
				map[ k ] = otherMap[ k ]
			Next
			SetObject( key, map )
		Else
			SetObject( key, json.ToObject() )
		End
	End
	

	Method Serialize( key:String, v:Variant )
		
		Local typeName := v.Type.Name
		
		If v.Type.Kind = "Array"
			Local arrayType := typeName.Slice(0, typeName.Length - 2)
			Select arrayType
			Case "Float"
				SetArray( key, GetJsonStack<JsonNumber,Float>( v ) )
			Case "Double"
				SetArray( key, GetJsonStack<JsonNumber,Double>( v ) )
			Case "String"
				SetArray( key, GetJsonStack<JsonString,String>( v ) )
			Case "Bool"
				SetArray( key, GetJsonStack<JsonBool,Bool>( v ) )
			Case "game3d.Component"
				Local arr := Cast<game3d.Component[]>( v )
				For Local c := Eachin arr
					Merge( c.Name, SerializeDecls( c.InstanceType.SuperType, c ) )
					Merge( c.Name, SerializeDecls( c.InstanceType, c ) )
				Next
			Default
				Print( "Serialize warning: Unrecognized array type" )
			End
		Else
			Select typeName
			Case "Double"
				SetNumber( key, Cast<Double>( v ) )
			Case "Float"
				SetNumber( key, Cast<Float>( v ) )
			Case "String"
				SetString( key, Cast<String>( v ) )
			Case "Bool"
				SetBool( key, Cast<Bool>( v ) )
			Case "Int"
				SetNumber( key, Cast<Int>( v ) )
			Case "UInt"
				SetNumber( key, Cast<UInt>( v ) )
			Default
				If v.Type.Kind="Class" or v.Type.Kind="Interface"
					Merge( key, SerializeDecls( v.Type.SuperType, v ) )
					Merge( key, SerializeDecls( v.DynamicType, v ) )
				Else
					Merge( key, SerializeDecls( v.Type, v ) )
				End
			
			End
		End	
	End
End


Function SerializeDecls:JsonObject( type:TypeInfo, instance:Variant )
	Local newObj:= New JsonObject
	newObj.SetString( "Class", type.Name )
	For Local decl:DeclInfo = Eachin type.GetDecls()
		If ( decl.Kind = "Property" And decl.Settable ) Or ( decl.Kind = "Field" And Not decl.Name.StartsWith("_") )
			If decl.Type.Name.Slice( 0, 7 ) = "Unknown"
				Print( "Warning: Property " + decl.Name + " cannot be reflected and can't be serialized." )
			Else
				newObj.Serialize( decl.Name, decl.Get( instance ) )
			End
		End
	Next
	Return newObj
End


Function VariantToString:String( v:Variant )
	Local typeName := v.Type.Name
	If v.Type.Kind = "Array"
		Select typeName
		Case "Float[]"
			Return VariantArrayToString<Float>( v )
		Case "Double[]"
			Return VariantArrayToString<Double>( v )
		Case "Int[]"
			Return VariantArrayToString<Int>( v )
		Case "String[]"
			Return VariantArrayToString<String>( v )
		End
	Else
		Select typeName
		Case "Double"
			Return String( Cast<Double>( v ) )
		Case "Float"
			Return String( Cast<Float>( v ) )
		Case "String"
			Return String( Cast<String>( v ) )
		Case "Bool"
			Local b := Cast<Bool>( v ) 
			If b
				Return "True"
			Else
				Return "False"
			End
		Case "Int"
			Return String( Cast<Int>( v ) )
		Case "UInt"
			Return String( Cast<UInt>( v ) )
		End
	End
	Return typeName
End


Function Deserialize( json:JsonObject )
	If json
		For Local entry := EachIn json.ToObject().Keys
			LoadFromJsonObject( entry, json[ entry ].ToObject() )
		Next
	End
	json = Null
End


Private
Function LoadFromJsonObject:Variant( objName:String, obj:StringMap<JsonValue> )
	Local v:Variant
	
	If obj["Class"]
	 	Local objClass:= obj["Class"].ToString()
		Local info := TypeInfo.GetType( objClass )
		
		If info
			Local constructor := info.GetDecl( "New" )
			
			'This is the variant we'll assign the field values to.
			v = constructor.Invoke( Null, Null )
			
			'hack!
			Local priorities := New StringStack( New String[]( "Name", "Owner" ) )
			If info.SuperType.Name = "game3d.Component"
				For Local key := EachIn priorities
					Local onCreate := info.GetDecl( key )
					Print( "Loading " + key )
					LoadFromJsonValue( obj[key], v, onCreate, key )
				Next
			End
			
			'Set remaining properties
			For Local key := EachIn obj.Keys
				If key = "Class" Continue
				If priorities.Contains( key ) Continue
				Local d:= info.GetDecl( key )
				Print( "Loading " + key )
				LoadFromJsonValue( obj[key], v, d, key )
			Next
	
		Else
			Print( "Error: Class " + objClass + " not found" )
		End
	End
	
	If v = Null Then Print( "Deserialize Error: Nothing to return" )
	Return v
End


Function LoadFromJsonValue:Variant( value:JsonValue , v:Variant, d:DeclInfo, key:String )
	'If the field is an object, recursively call LoadFromMap.
	Local rVar :Variant
	
	If value.IsObject
		Local obj := LoadFromJsonObject( key, value.ToObject() )
		If obj
			If d And v Then d.Set( v, obj )
			rVar = Variant( obj )
		End
		Print "Setting value " + ( key? ( key + "= " ) Else "" ) + value.ToJson()
	ElseIf value.IsString
		If d And v Then d.Set( v, Variant(value.ToString()) )
		rVar = Variant( value.ToString() )
		Print "Setting value " + ( key? ( key + "= " ) Else "" ) + value.ToJson()
	Elseif value.IsNumber
		'Need to figure out how to pass the decl/array type down here... for now, only use Double! ;-)
'		Select ??????
'		Case "Int"
'			If d And v Then d.Set( v, Variant( Int(value.ToNumber() ) ) )
'			rVar = Variant( Int(value.ToNumber() ) )
'		Case "UInt"
'			If d And v Then d.Set( v, Variant( UInt(value.ToNumber() ) ) )
'			rVar = Variant( UInt(value.ToNumber() ) )
'		Case "Float"
'			If d And v Then d.Set( v, Variant( value.ToFloat() ) )
'			rVar = Variant( value.ToFloat() )
'		Default
			If d And v Then d.Set( v, Variant( value.ToNumber() ) )
			rVar = Variant( value.ToNumber() )
'		End
		Print "Setting value " + ( key? ( key + "= " ) Else "" ) + value.ToJson()
	ElseIf value.IsBool
		If d And v Then d.Set( v, Variant(value.ToBool()) )
		rVar = Variant( value.ToBool() )
		Print "Setting value " + ( key? ( key + "= " ) Else "" ) + value.ToJson()
	ElseIf value.IsArray
		Local arr := value.ToArray()
		If Not arr.Empty
			Local first := arr[0]
			Local varArray:Variant
			
			If first.IsNumber Then varArray = JsonArrayToVariantArray<Double>( arr ) 
			If first.IsString Then varArray = JsonArrayToVariantArray<String>( arr )
			If first.IsBool Then varArray = JsonArrayToVariantArray<Bool>( arr )

			d.Set( v, varArray )
			rVar = varArray
		End
	End	

'	Print "Returning value: " + ( key? ( key + "= " ) Else "" ) + value.ToJson() + ":" + rVar.Type
	Return rVar
End

Function JsonArrayToVariantArray<T>:Variant( jsonArr:Stack<JsonValue> )
	Local arr := New T[ jsonArr.Length ]
	Local v := Variant( arr )
	For Local n := 0 Until jsonArr.Length
		arr[n] = Cast<T>( LoadFromJsonValue( jsonArr[n], Null, Null, Null ) ) 
	Next
	Return v
End


Function CastJsonArray<T>:T[]( jsonArr:Stack<JsonValue> )
	Local newArr := New T[ jsonArr.Length ]
	For Local n := 0 Until jsonArr.Length
		Local first := jsonArr[0]
		newArr[n] = jsonArr[n].ToFloat()
	Next
	Return newArr
End


Function GetJsonStack<T,V>:Stack<JsonValue>( v:Variant )
	Assert( ( v.Type.Kind = "Array" ), "GetJsonStack: Variant " + v.Type.Name + " is not an array" )
	Local stack := New Stack<JsonValue>
	Local arr := Cast<V[]>( v )
	For Local element := Eachin arr
		stack.Push( New T( element ) )
	Next
	Return stack
End


Function VariantArrayToString<T>:String( v:Variant )
	Assert( ( v.Type.Kind = "Array" ), "Variant " + v.Type.Name + " is not an array" )
	Local arr := Cast<T[]>( v )
	Local text := "[ "
	For Local n := 0 Until arr.Length
		text += arr[n]
		If n < arr.Length - 1
			text += ", "
		Else
			text += " ]"	
		End
	Next
	Return text
End





'Function SetFromJsonValue( value:JsonValue, key:String, d:DeclInfo, v:Variant )
'	'If the field is an object, recursively call LoadFromMap.
'	If value.IsObject
'		Local o := LoadFromMap( key, value.ToObject() )
'		If o Then d.Set( v, o )
'	End
'	'Now let's try to set the other fields.
'	If value.IsString Then d.Set( v, value.ToString() )
'	If value.IsNumber Then d.Set( v, value.ToNumber() )
'	If value.IsBool   Then d.Set( v, value.ToBool() )
'	If value.IsArray
'		Local arr := value.ToArray()
'		For Local n := 0 Until arr.Length
'			Local newArr := New Float[arr.Length]
''			newArr[n] = arr[n]
'
'		Next
'	End
'	
'End


#Rem

Public
Function Main()
	Local json := New JsonObject()
	json.Serialize( "text","Just a little text" )
	json.Serialize( "number", 100.0 )
	json.Serialize( "isItTrue?", False )
	json.Serialize( "Knight1", New KnightWhoSaysNi )
	json.Serialize( "Knight2", New AnotherKnight )
	json.Serialize( "KnightStruct", New NonsenseStruct )
	Print json.ToJson()
End

'***************** Test classes and structs *****************


Class KnightWhoSaysNi
	Protected
	Field _name := "Ni!"
	Field _value:Float = 1000.0
	Field _schroob:= New Schruberry
	Field _nonsense:= New NonsenseStruct
	Field _color := New Color( 0, 0, 1, 1 )
	Field _position := New Vec3f( 5, 0, 1 )
	Field _style := FightStyle.Full
	
	Public
	Method New()
	End
	
	Property Value:Float()
		Return _value
	Setter( v:Float )
		_value = v
	End
	
	Property Name:String()
		Return _name
	Setter( n:String )
		_name = n
	End
	
	Property Request:Schruberry()
		Return _schroob
	Setter( s:Schruberry )
		_schroob = s
	End
	
	Property BrandNewName:NonsenseStruct()
		Return _nonsense
	Setter( n:NonsenseStruct )
		_nonsense = n
	End
	
	Property Position:Float[]()
		Return New Float[]( _position.X, _position.Y, _position.Z )
	Setter( p:Float[] )
		_position = New Vec3f( p[0], p[1], p[2] )
	End
	
	Property Color:Color()
		Return _color
	Setter( c:Color )
		_color = c
	End
	
'	Property Style:FightStyle()
'		Return _style
'	Setter( f:FightStyle )
'		_style = f
'	End
		
End

Class AnotherKnight Extends KnightWhoSaysNi
	
	Method New()
		Super.New()
		_name = "AnotherNi!"
	End
	
	Property Ni:String()
		Return "ninininininini"
	Setter( p:String )
	End
	
End


Class Schruberry
	Property Random:Float()
		Return Rnd()
	Setter( bogus:Float )
		'One that looks nice. And not too expensive.
	End
End


Struct NonsenseStruct
	Private
	Field _words:= "Ekke Ekke Ekke Ekke Ptang Zoo Boing!"
	
	Public
	Property Words:String()
		Return _words
	Setter( w:String )
		_words = w
	End
End


Enum FightStyle
	Full,
	Armless,
	Legless
End
