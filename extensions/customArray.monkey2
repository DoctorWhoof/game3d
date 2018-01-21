
Namespace std.Json


Class Game3DArrays Extends CustomArraySerializer
	
	Method Serialize:JsonArray( v:Variant ) Override
		Return New JsonArray( GetJsonStack<JsonObject,game3d.Component>( v ) )	
	End
	
	Method Deserialize:Variant( jsonArr:Stack<JsonValue> ) Override
		Return DeserializeArray<game3d.Component>( jsonArr )
	End
	
End
