#Import "../jsonSerial"

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
