'''''Unfinished! ''''''

'Euler Order enum.
Enum EulerOrder
	XYZ,
	YZX,
	ZXY,
	ZYX,
	YXZ,
	XZY
End


Function EulerAnglesToMatrix:Matrix( eulerAngle:Vec3f , order:EulerOrder )
    'Convert Euler Angles passed in a vector of Radians
    'into a rotation matrix.  The individual Euler Angles are
    'processed in the order requested.
    Local Mx:AffineMat4 

    Local Sx:= Sin(eulerAngle.X)
    Local Sy:= Sin(eulerAngle.Y)
    Local Sz:= Sin(eulerAngle.Z)
    Local Cx:= Cos(eulerAngle.X)
    Local Cy:= Cos(eulerAngle.Y)
    Local Cz:= Cos(eulerAngle.Z)

    Select(EulerOrder)
    case XYZ
        Mx.M[0][0]=Cy*Cz
        Mx.M[0][1]=-Cy*Sz
        Mx.M[0][2]=Sy
        Mx.M[1][0]=Cz*Sx*Sy+Cx*Sz
        Mx.M[1][1]=Cx*Cz-Sx*Sy*Sz
        Mx.M[1][2]=-Cy*Sx
        Mx.M[2][0]=-Cx*Cz*Sy+Sx*Sz
        Mx.M[2][1]=Cz*Sx+Cx*Sy*Sz
        Mx.M[2][2]=Cx*Cy

    case YZX
        Mx.M[0][0]=Cy*Cz
        Mx.M[0][1]=Sx*Sy-Cx*Cy*Sz
        Mx.M[0][2]=Cx*Sy+Cy*Sx*Sz
        Mx.M[1][0]=Sz
        Mx.M[1][1]=Cx*Cz
        Mx.M[1][2]=-Cz*Sx
        Mx.M[2][0]=-Cz*Sy
        Mx.M[2][1]=Cy*Sx+Cx*Sy*Sz
        Mx.M[2][2]=Cx*Cy-Sx*Sy*Sz

    case ZXY
        Mx.M[0][0]=Cy*Cz-Sx*Sy*Sz
        Mx.M[0][1]=-Cx*Sz
        Mx.M[0][2]=Cz*Sy+Cy*Sx*Sz
        Mx.M[1][0]=Cz*Sx*Sy+Cy*Sz
        Mx.M[1][1]=Cx*Cz
        Mx.M[1][2]=-Cy*Cz*Sx+Sy*Sz
        Mx.M[2][0]=-Cx*Sy
        Mx.M[2][1]=Sx
        Mx.M[2][2]=Cx*Cy
        
    case ZYX
        Mx.M[0][0]=Cy*Cz
        Mx.M[0][1]=Cz*Sx*Sy-Cx*Sz
        Mx.M[0][2]=Cx*Cz*Sy+Sx*Sz
        Mx.M[1][0]=Cy*Sz
        Mx.M[1][1]=Cx*Cz+Sx*Sy*Sz
        Mx.M[1][2]=-Cz*Sx+Cx*Sy*Sz
        Mx.M[2][0]=-Sy
        Mx.M[2][1]=Cy*Sx
        Mx.M[2][2]=Cx*Cy

    case YXZ
        Mx.M[0][0]=Cy*Cz+Sx*Sy*Sz
        Mx.M[0][1]=Cz*Sx*Sy-Cy*Sz
        Mx.M[0][2]=Cx*Sy
        Mx.M[1][0]=Cx*Sz
        Mx.M[1][1]=Cx*Cz
        Mx.M[1][2]=-Sx
        Mx.M[2][0]=-Cz*Sy+Cy*Sx*Sz
        Mx.M[2][1]=Cy*Cz*Sx+Sy*Sz
        Mx.M[2][2]=Cx*Cy

    case XZY
        Mx.M[0][0]=Cy*Cz
        Mx.M[0][1]=-Sz
        Mx.M[0][2]=Cz*Sy
        Mx.M[1][0]=Sx*Sy+Cx*Cy*Sz
        Mx.M[1][1]=Cx*Cz
        Mx.M[1][2]=-Cy*Sx+Cx*Sy*Sz
        Mx.M[2][0]=-Cx*Sy+Cy*Sx*Sz
        Mx.M[2][1]=Cz*Sx
        Mx.M[2][2]=Cx*Cy+Sx*Sy*Sz
        
    End
    
    Return(Mx)
End