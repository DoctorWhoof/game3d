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
	
	Function FromJsonArray:Color( arr:JsonArray )
		Local c:= New Color
		If arr.Length > 2
			c.R = arr[0].ToNumber()
			c.G = arr[1].ToNumber()
			c.B = arr[2].ToNumber()
		End
		If arr.Length > 3 Then c.A = arr[3].ToNumber()
		Return c
	End
	
End
