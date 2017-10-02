Namespace std.graphics

Struct Color Extension
	
	Method ToArray:Double[]()
		Return New Double[]( R, G, B, A )
	End
	
	Function FromArray:Color( arr:Double[] )
		Return New Color( arr[0], arr[1], arr[2], arr[3] )
	End
	
End