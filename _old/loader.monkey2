Namespace game3d


Function LoadFromFile( path:String )
	Local json := JsonObject.Load( path )
	If json
		For Local entry := EachIn json.ToObject().Keys
			LoadFromMap( json[ entry ].ToObject(), entry )
		Next
	End
	json = Null
End


Function LoadFromMap:Variant( obj:StringMap<JsonValue>, objName:String )
	Local inst:Variant
 	Local objClass:= obj["class"].ToString()

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

	If inst = Null Then Print( "Error: Nothing to return" )
	Return inst
End