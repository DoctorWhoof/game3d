Namespace std.Json

'#Import "../../serializer/serializer"
'
Class GameObject Extension

	Function Load:JsonObject( path:String )
		Local json := JsonObject.Load( path )
		Assert( json, "Deserialize Game Objects: Json file error")
		
		Local priorities := New StringStack
		Local include:= New StringStack
		Local exclude:= New StringStack
		
		include.Push( "Name" )
		For Local key := EachIn json.ToObject().Keys
			LoadFromJsonObject( json[ key ].ToObject(), include, exclude )
		Next
		
'		Prompt( "~n------------------- loading Components ----------------------------~n" )
	
		include.Clear()
		exclude.Clear()
		include.Push( "Components" )
		For Local key := EachIn json.ToObject().Keys
			Local gameobj := GameObject.Find( key )
'			Prompt( key )
			GetPropertiesFromJsonObject( Variant(gameobj), json.GetObject( key ), include, exclude )
'			Prompt( "" )
		Next
		
'		Prompt( "~n------------------- loading other fields and properties ----------------------------~n" )
	
		For Local key := EachIn json.ToObject().Keys
			Local gameobj := GameObject.Find( key )
'			Prompt( key )
			include.Clear()
			exclude.Clear()
			exclude.Push( "Components" )
			exclude.Push( "Name" )
			GetPropertiesFromJsonObject( Variant(gameobj), json.GetObject( key ), include, exclude  )
'			Prompt( "" )
		Next
		
		Return json
	End
	
	
	Function Save:JsonObject( scene:Scene, path:String )
		Local json := New JsonObject
		For Local g := Eachin GameObject.GetFromScene( scene )
			json.Serialize( g.Name, g )
		Next
		SaveString( json.ToJson(), path )
		Return json
	End

End
