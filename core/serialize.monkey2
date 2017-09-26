Namespace std.Json

#Import "<std>"
#Import "<mojo>"
#Import "<reflection>"

Using std..
Using mojo..

'Class JsonObject Extension 
'	Method Serialize( key:String, v:Variant )
'		Select v.Type.Name
'		Case "Double"
'			SetNumber( key, Cast<Double>( v ) )
'		Case "Float"
'			SetNumber( key, Cast<Float>( v ) )
'		Case "String"
'			SetString( key, Cast<String>( v ) )
'		Case "Bool"
'			SetBool( key, Cast<Bool>( v ) )
'		Case "Float[]"
'			SetArray( key, GetJsonStack<JsonNumber,Float>( v ) )
'		Case "Double[]"
'			SetArray( key, GetJsonStack<JsonNumber,Double>( v ) )
'		Case "String[]"
'			SetArray( key, GetJsonStack<JsonString,String>( v ) )
'		Case "Bool[]"
'			SetArray( key, GetJsonStack<JsonBool,Bool>( v ) )
'		Default
'			Local newObj:= New JsonObject
'			Local type:= v.DynamicType
'			
'			newObj.SetString( "Class", type.Name )
'			For Local decl:DeclInfo = Eachin type.GetDecls()
'				If ( decl.Kind = "Property" And decl.Settable ) Or ( decl.Kind = "Field" And Not decl.Kind.StartsWith("_") )
'					If decl.Type.Name.Slice( 0, 7 ) = "Unknown"
'						Print( "Warning: Property " + decl.Name + " cannot be reflected and can't be serialized." )
'					Else
'						newObj.Serialize( decl.Name, decl.Get( v ) )
'					End
'				End
'			Next
'			SetObject( key, newObj.ToObject() )
'		End		
'	End
'End

Function Serialize:JsonValue( v:Variant )
	Local value:JsonValue
	
	Select v.Type.Name
	Case "Double"
		value = New JsonNumber( Cast<Double>( v ) )
	Case "Float"
		value = New JsonNumber( Cast<Float>( v ) )
	Case "String"
		value = New JsonString( Cast<String>( v ) )
	Case "Bool"
		value = New JsonBool( Cast<Bool>( v ) )
	Case "Float[]"
		value = New JsonArray( GetJsonStack<JsonNumber,Float>( v ) )
	Case "Double[]"
		value = New JsonArray( GetJsonStack<JsonNumber,Double>( v ) )
	Case "String[]"
		value = New JsonArray( GetJsonStack<JsonString,String>( v ) )
	Case "Bool[]"
		value = New JsonArray( GetJsonStack<JsonBool,Bool>( v ) )
	Default
		Local map := New StringMap<JsonValue>
		Local type:= v.DynamicType
		
		map.Add( "Class", New JsonString( type.Name ) )
		
		For Local decl:DeclInfo = Eachin type.GetDecls()
			If ( decl.Kind = "Property" And decl.Settable ) Or ( decl.Kind = "Field" And Not decl.Name.StartsWith("_") )
				If decl.Type.Name.Slice( 0, 7 ) = "Unknown"
					Print( "Warning: Property " + decl.Name + " cannot be reflected and can't be serialized." )
				Else
					map.Add( decl.Name, Serialize( decl.Get( v ) ) )
				End
			End
		Next
		
		value = New JsonObject( map )
	End
	
	Return value
End


Function GetJsonStack<T,V>:Stack<JsonValue>( v:Variant )
	Assert( ( v.Type.Kind = "Array" ), "GetJsonStack: Variant " + v.Type.Name + " is not an array" )
	Local stack := New Stack<JsonValue>
	Local arr := Cast<V[]>( v )
	For Local f := Eachin arr
		stack.Push( New T( f ) )
	Next
	Return stack
End


Function Deserialize( json:JsonObject )
	If json
		For Local entry := EachIn json.ToObject().Keys
			LoadFromMap( json[ entry ].ToObject(), entry )
		Next
	End
	json = Null
End

Function LoadFromMap:Variant( obj:StringMap<JsonValue>, objName:String )
	Local inst:Variant
	If obj["Class"]
	 	Local objClass:= obj["Class"].ToString()
	
		Local newObj := TypeInfo.GetType( objClass )
		If newObj
	
			Local ctor := newObj.GetDecl( "New" )
			inst = ctor.Invoke( Null, Null )	'This is the instance we'll assign the field values to.
	
			For Local key := EachIn obj.Keys
				If key = "class" Then Continue
				Local d:= newObj.GetDecl( key )
	
				'If the field is an object, recursively call LoadFromMap.
				If obj[key].IsObject
					Local o := LoadFromMap( obj[key].ToObject(), key )
					If o Then d.Set( inst, o )
				End
				'Now let's try to set the other fields.
				If obj[key].IsString Then d.Set( inst, obj[key].ToString() )
				If obj[key].IsNumber Then d.Set( inst, obj[key].ToNumber() )
				If obj[key].IsBool   Then d.Set( inst, obj[key].ToBool() )
			Next
	
		Else
			Print( "Error: Class " + objClass + " not found" )
		End
	End
	
	If inst = Null Then Print( "Deserialize Error: Nothing to return" )
	Return inst
End

#Rem

Function Main()
	Local json := New JsonObject()
	json.Serialize( "text","Just a little text" )
	json.Serialize( "number", 100.0 )
	json.Serialize( "isItTrue?", False )
	json.Serialize( "Knight1", New KnightWhoSaysNi )
	json.Serialize( "Knight2", New KnightWhoSaysNi )
	json.Serialize( "KnightStruct", New NonsenseStruct )
	Print json.ToJson()
End

'***************** Test classes and structs *****************


Class KnightWhoSaysNi
	Private
	Field _name := "Ni!"
	Field _value:Float = 1000.0
	Field _schroob:= New Schruberry
	Field _nonsense:= New NonsenseStruct
	Field _color := New Color( 0, 0, 1, 1 )
	Field _position := New Vec3f( 5, 0, 1 )
	Field _style := FightStyle.Full
	
	Public
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
	
	Property Style:FightStyle()
		Return _style
	Setter( f:FightStyle )
		_style = f
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
