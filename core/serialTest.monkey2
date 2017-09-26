#Import "<std>"
#Import "<reflection>"

Using std..

'************************ json extension '************************

Class JsonObject Extension 
	Method Serialize( key:String, v:Variant )
		Select v.Type.Name
		Case "Double"
			SetNumber( key, Cast<Double>( v ) )
		Case "Float"
			SetNumber( key, Cast<Float>( v ) )
		Case "String"
			SetString( key, Cast<String>( v ) )
		Case "Bool"
			SetBool( key, Cast<Bool>( v ) )
		Default
			Local newObj:= New JsonObject
			Local type:=DynamicType( v )
			
			newObj.SetString( "Class", type.Name )
			For Local decl:DeclInfo = Eachin type.GetDecls()
				If ( decl.Kind = "Property" And decl.Settable )' Or ( decl.Kind = "Field" )
					If decl.Type.Name.Slice( 0, 7 ) = "Unknown"
						Print( "Warning: Property " + decl.Name + " cannot be reflected and can't be serialized." )
					Else
						newObj.Serialize( decl.Name, decl.Get( v ) )
					End
				End
			Next
			SetObject( key, newObj.ToObject() )
		End		
	End
End


Function DynamicType:TypeInfo( v:Variant )
   If v.Type.Kind="Class" or v.Type.Kind="Interface"
      Local inst:=Cast<Object>( v )
      If inst Return inst.InstanceType
   Endif
   Return v.Type
End


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

