Namespace std.Json

#Import "../serial/jsonSerial"

Function DeserializeGameObjects( json:JsonObject )
	Local priorities := New StringStack
	If Not json.Empty
		
		Local include:= New StringStack
		Local exclude:= New StringStack
		
		include.Push( "Name" )
		For Local key := EachIn json.ToObject().Keys
			LoadFromJsonObject( json[ key ].ToObject(), include, exclude )
		Next
		
		Prompt( "~n------------------- loading Components ----------------------------~n" )

		include.Clear()
		exclude.Clear()
		include.Push( "Components" )
		For Local key := EachIn json.ToObject().Keys
			Local gameobj := GameObject.Find( key )
			Prompt( key )
			GetPropertiesFromJsonObject( Variant(gameobj), json.GetObject( key ), include, exclude )
			Prompt( "" )
		Next
		
		Prompt( "~n------------------- loading other fields and properties ----------------------------~n" )

		For Local key := EachIn json.ToObject().Keys
			Local gameobj := GameObject.Find( key )
			Prompt( key )
			include.Clear()
			exclude.Clear()
			exclude.Push( "Components" )
			exclude.Push( "Name" )
			GetPropertiesFromJsonObject( Variant(gameobj), json.GetObject( key ), include, exclude  )
			Prompt( "" )
		Next
	End

End
