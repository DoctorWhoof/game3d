Namespace std.geom

Struct AffineMat3<T> Extension
 
	Method GetScale:Vec2f()
		Local sxsq:=Pow(Self.i.x,2)+Pow(Self.i.y,2)
		Local sysq:=Pow(Self.j.x,2)+Pow(Self.j.y,2)
		If sxsq=sysq 'to gain calculation time because I generaly use 1:1 scales
			Local sc:=Sqrt(sxsq)
			Return New Vec2f (sc,sc)
		Else
			Return New Vec2f (Sqrt(sxsq),Sqrt(sysq))
		Endif	
	End


	Method GetRotation:Double()
		Local f:Double=Self.j.y 'to prevent integer division giving integer
		If f<>0
			Return ATan(-Self.i.y/f)	
		Else
			Print "Matrix is not a valid transform, could not get Rotation" 'should throw instead of print ..?
			Return 0.0
		Endif
	End
	
	
	Method GetTranslation:Vec2<T>()
		Return Self.t ' a bit basic but it makes all three methods being a logical group
	End
 
End