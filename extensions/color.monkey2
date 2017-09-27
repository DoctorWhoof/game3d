Namespace std.graphics

Struct Color Extension
	
	Method ToArray:Float[]()
		Return New Float[]( R, G, B, A )
	End
	
	Function FromArray:Color( arr:Float[] )
		Return New Color( arr[0], arr[1], arr[2], arr[3] )
	End
	
End