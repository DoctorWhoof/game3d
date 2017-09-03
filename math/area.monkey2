
Namespace math

#Import "matrix_ext"

Class Area<T>

	Private
	
	Field _pos:Vec2<T>
	Field _width:T
	Field _height:T	
	Field _handle := New Vec2<T>( 0.5, 0.5 )	'Values are from 0,0 (Left, Top ) to 1,1 (Right, Bottom )

	Field _x0:T, _y0:T, _x1:T, _y1:T		'corners
	Field _pivotX:T							'width * handle.X
	Field _pivotY:T							'height * handle.Y
	
	'four corners with transformation!
	Field _topLeft:Vec2<T>
	Field _topRight:Vec2<T>
	Field _bottomLeft:Vec2<T>
	Field _bottomRight:Vec2<T>

	Public

	'*************************  Properties  ****************************
	
	Property X:T()
		Return _pos.X
	Setter( x:T )
		_pos.X = x
		Self._x0 = x - _pivotX
		Self._x1 = _x0 + _width
	End
	
	Property Y:T()
		Return _pos.Y
	Setter( y:T )
		_pos.Y = y
		Self._y0 = y - _pivotY
		Self._y1 = _y0 + _height
	End

	Property Width:T()
		Return _width
	Setter( w:T )
		Self._width = w
		_pivotX = ( _width * _handle.x )
		Self._x0 = _pos.X - _pivotX
		Self._x1 = _x0 + _width
	End
	
	Property Height:T()
		Return _height
	Setter( h:T )
		Self._height = h
		_pivotY = ( _height * _handle.y )
		Self._y0 = _pos.Y - _pivotY
		Self._y1 = _y0 + _height
	End

	Property Left:T()
		Return _x0
	Setter( newLeft:T )
		Width = _x1 - newLeft
		X = newLeft + _pivotX
	End
	
	Property Right:T()
		Return _x1
	Setter( newRight:T )
		Local oldX0 := _x0
		Width= newRight - _x0
		X = oldX0 + _pivotX
	End
	
	Property Top:T()
		Return _y0
	Setter( newTop:T )
		Height = _y1 - newTop
		Y = newTop + _pivotY
	End
	
	Property Bottom:T()
		Return _y1
	Setter( newBottom:T )
		Local oldY0 := _y0
		Height = newBottom - _y0
		Y = oldY0 + _pivotY
	End
	
	Property Handle:Vec2<T>()
		Return _handle
	Setter( vec:Vec2f )
		_handle.X = vec.X
		_handle.Y = vec.Y
		_pivotX = vec.X * _width
		_pivotY = vec.Y * _height
		Self._x0 = _pos.X - _pivotX
		Self._y0 = _pos.Y - _pivotY
		Self._x1 = _x0 + _width
		Self._y1 = _y0 + _height
	End
	
	Property HalfSize:Vec2<T>()
		Return New Vec2<T>( _width/2.0, _height/2.0 )
	End

	
	Property Center:Vec2<T>()
		Return New Vec2<T>( _x0 + (_width/2.0), _y0 + (_height/2.0) )	
	End
	
	Property Rect:Rect<T>()
		Return New Rect<T>( _x0, _y0, _x1, _y1 )
	End
	
	Property Size:Vec2<T>()
		Return New Vec2<T>( _width, _height )
	Setter( v:Vec2<T> )
		Width = v.X
		Height = v.Y
	End
	
	'transformed corners. Make sure you call Transform( mat ) first
	
	Property TopLeft:Vec2<T>()
		Return _topLeft
	End
	
	Property TopRight:Vec2<T>()
		Return _topRight
	End
	
	Property BottomLeft:Vec2<T>()
		Return _bottomLeft
	End
	
	Property BottomRight:Vec2<T>()
		Return _bottomRight
	End

	'**************************  Public Methods  ****************************

	Method New( x:T, y:T, _width:T, _height:T, handleX:T = 0.5, handleY:T = 0.5 )
		X = x
		Y = y
		_handle.X = handleX
		_handle.Y = handleY
		SetSize( _width, _height )
	End
	
	Method SetPosition( x:T, y:T )
		X = x
		Y = y
	End

	Method SetSize(_width:T, _height:T )
		Self._width = _width
		Self._height = _height
		_pivotX = ( _width * _handle.x )
		_pivotY = ( _height * _handle.y )
		Self._x0 = _pos.X - _pivotX
		Self._y0 = _pos.Y - _pivotY
		Self._x1 = _x0 + _width
		Self._y1 = _y0 + _height
	End
	
	Method SetOffset( dX:T, dY:T )
		_pivotX = (_width/2.0 ) - dX
		_pivotY = (_height/2.0 ) - dY
		_handle.X = _pivotX / _width
		_handle.Y = _pivotY / _height
		Self._x0 = _pos.X - _pivotX
		Self._y0 = _pos.Y - _pivotY
		Self._x1 = _x0 + _width
		Self._y1 = _y0 + _height
	End
	 
	Method SetPositionByCorner( _x0:T, _y0:T )
		X = _x0 + _pivotX
		Y = _y0 + _pivotY
	End

	Method Move( deltaX:T, deltaY:T )
		X += deltaX
		Y += deltaY
	End
'   
	Method Contains:Bool(_x:T, _y:T, hMargin:T = 0, vMargin:T = 0 )
		If hMargin Or vMargin
			If _x > _x0 + hMargin
				If _x < _x1 - hMargin
					If _y > _y0 + vMargin
						If _y < _y1 - vMargin
							Return True
						End
					End
				End
			End
		Else
			If _x > _x0
				If _x < _x1
					If _y > _y0
						If _y < _y1
							Return True
						End
					End
				End
			End
		End
		Return False
	End

	Method Overlaps:Bool( rect:Area, hMargin:T = 0, vMargin:T = 0 )
		If hMargin Or vMargin
			If rect._x1 > _x0 + hMargin
				If rect._x0 < _x1 - hMargin
					If rect._y1 > _y0 + vMargin
						If rect._y0 < _y1 - vMargin
							Return True
						End
					End
				End
			End		
		Else
			If rect._x1 > _x0
				If rect._x0 < _x1
					If rect._y1 > _y0
						If rect._y0 < _y1
							Return True
						End
					End
				End
			End
		End
		Return False
	End


	Method Copy( other:Area<T> )
		Handle = other.Handle
		SetPosition( other.X, other.Y )
		SetSize( other.Width, other.Height )
	End


	Method Transform( mat:AffineMat3<T> )
		_pos = mat.Transform( _pos.X, _pos.Y )
		'Four corner vectors are fully transformed
		_topLeft = mat.Transform( _x0, _y0 )
		_topRight = mat.Transform( _x1, _y0 )
		_bottomLeft = mat.Transform( _x0, _y1 )
		_bottomRight = mat.Transform( _x1, _y1 )
		'edges ignore rotation, but are updated to latest coords and scale
		Local scale := mat.GetScale()
		SetSize( _width * scale.X, _height * scale.Y )
	End
	
	
	Method ToString:String()
		Return "("+_pos.X+","+_pos.Y+"; "+ Cast<Int>( _width ) + "x"+ Cast<Int>( _height )+")"
	End
	

End
