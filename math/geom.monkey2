Namespace math

'*********************** Geometry functions ***********************


Function CreateOval:Float[]( steps:Int, X:Double, Y:Double, Width:Double, Height:Double, initialAngle:Double = 0 )
	Local verts:= New FloatStack
	Local radiusX:Double = Width / 2.0
	Local radiusY:Double = Height / 2.0
	Local increment := 360/steps
	For Local n := 1 To steps
		verts.Push( Sin( DegToRad( initialAngle ) ) * radiusX + X )
		verts.Push( Cos( DegToRad( initialAngle ) ) * radiusY + Y )
		initialAngle += increment
	End
	Return verts.ToArray()
End