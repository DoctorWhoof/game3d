
Namespace std.geom

Struct Rect<T> Extension
    
	Public
	Method Contains:Bool( a:Vec2<T>, b:Vec2<T> )
		If Contains( a ) Return True
		If Contains( b ) Return True
		If LineIntersects( TopLeft, TopRight, a, b ) Return True
		If LineIntersects( TopRight, BottomRight, a, b ) Return True
		If LineIntersects( BottomRight, BottomLeft, a, b ) Return True
		If LineIntersects( BottomLeft, TopLeft, a, b ) Return True
		Return False
	End
	
    Private
	Function CCW:Bool( a:Vec2<T>, b:Vec2<T>, c:Vec2<T> )
		Return ((c.y-a.y)*(b.x-a.x)) > ((b.y-a.y)*(c.x-a.x))
	End
	
	Method LineIntersects:Bool( a:Vec2<T>, b:Vec2<T>, c:Vec2<T> , d:Vec2<T>  )
		Return ( CCW(a,c,d) = Not CCW(b,c,d) ) And ( CCW(a,b,c) = Not CCW(a,b,d) )  
	End
	
End