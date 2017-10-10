Namespace std.graphics

Struct Color Extension
	
	Method ToArray:Double[]()
		Return New Double[]( R, G, B, A )
	End
	
	Function FromArray:Color( arr:Double[] )
		Return New Color( arr[0], arr[1], arr[2], arr[3] )
	End
	
End


'Struct Color Extension
'
'	Property Type:String()
'		Return "Color"
'	End
'
'	Method ToJson:JsonValue()
''		Local json := New JsonObject
'		Local jValue := New JsonArray
'		jValue.SetNumber( 0, R )
'		jValue.SetNumber( 1, G )
'		jValue.SetNumber( 2, B )
'		jValue.SetNumber( 3, A )
''		json.SetArray( "Color", jValue.ToArray() )
'		Return jValue
'	End
'
'End
