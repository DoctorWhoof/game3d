
Namespace mojo3d.graphics


Class OrthoCamera Extends Camera
	
	Field _rect:Rect<Double>
	
	Property ProjectionMatrix:Mat4f() Override
		If _dirty & Dirty.ProjMatrix
			_projMatrix=Mat4f.Ortho( _rect.Left, _rect.Right, _rect.Bottom, _rect.Top, Near, Far )
			_dirty&=~Dirty.ProjMatrix
		Endif
		
		Return _projMatrix
	End
	
End
