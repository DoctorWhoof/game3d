Namespace std.geom

Struct Vec2<T> Extension
	
	Method ToArray:T[]()
		Return New T[]( X, Y )
	End
	
	Method FromArray( arr:T[] )
		X = arr[0]
		Y = arr[1]
	End
	
End


Struct Vec3<T> Extension
	
	Method ToArray:T[]()
		Return New T[]( X, Y, Z )
	End
	
	Method FromArray( arr:T[] )
		X = arr[0]
		Y = arr[1]
		Z = arr[2]
	End
	
End

Struct Vec4<T> Extension
	
	Method ToArray:T[]()
		Return New T[]( X, Y, Z, W )
	End
	
	Method FromArray( arr:T[] )
		X = arr[0]
		Y = arr[1]
		Z = arr[2]
		W = arr[3]
	End
	
End