#Import "<std>"
'#Import "../../game3d"
#Import "../jsonSerial"

Using std..

'************************ main function '************************

Function Main()
	
	Local test1 := New BaseClass( "test1" )
	Local test2 := New ExtendedClass( "test2", "Ni!" )
	
	Local json := New JsonObject()
	For Local t := Eachin BaseClass.All()
		json.Serialize( t.Name, t )
	Next
	
	json.Serialize( "test3", New ExtendedClass( "test3", "NiNiNi!" ) )
	
	Print json.ToJson()

End


'************************ test classes '************************


Class BaseClass
	
	Property Name:String()
		Return _name
	Setter( n:String )
		_name = n
	End
	
	Method New( name:String )
		_name = name
		_words= "Ekke Ekke Ekke Ekke Ptang Zoo Boing!"
		_all.Push( Self )
	End
	
	Function All:Stack<BaseClass>()
		Return _all	
	End
	
	Protected
	Field _name:String
	Field _words:String
	Global _all:= New Stack<BaseClass>
End


Class ExtendedClass Extends BaseClass

	Property Words:String()
		Return _words
	Setter( w:String )
		_words = w
	End
	
	Method New( name:String, words:String )
		Super.New( name )
		_words = words	
	End

End

