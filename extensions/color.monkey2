Namespace std.graphics

Struct Color Extension
	
	Method ToArray:Double[]()
		Return New Double[]( R, G, B, A )
	End
	
	Function FromArray:Color( arr:Double[] )
		Return New Color( arr[0], arr[1], arr[2], arr[3] )
	End
	
	Method ToJsonArray:JsonValue[]()
		Local arr := New Stack<JsonValue>
		arr.Push( New JsonNumber(R) )
		arr.Push( New JsonNumber(G) )
		arr.Push( New JsonNumber(B) )
		arr.Push( New JsonNumber(A) )
		Return arr.ToArray()
	End
	
	Method FromJsonArray( arr:JsonArray )
		If arr.Length >= 3
			R = arr[0].ToNumber()
			G = arr[1].ToNumber()
			B = arr[2].ToNumber()
		End
		If arr.Length = 4 Then A = arr[3].ToNumber()
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
