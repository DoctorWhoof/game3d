Namespace util

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
Using std..
Using mojo..
Using mojo3d..

'Works better in full screen! In windowed mode the mouse cursor seems to be "lost" sometimes
'Call WASDInit a single time on start, then WASDCameraControl on every frame.
'The default values work well with delta = 1.0. Adjust if your delta is counted in seconds instead.


Function WasdInit( window:Window, showMouse:Bool = False )
	Mouse.Location = New Vec2i( window.Width / 2, window.Height / 2 )
	Mouse.PointerVisible = showMouse
End


Function WasdCameraControl( cam:Entity, window:Window, delta:Double = 1.0, touchStyle:Bool = False ,walkSpeed:Float = 0.1, mouseLookSpeed:Float = 0.2 )
	Global prevMouse:= New Vec2f( Float( Mouse.X ), Float( Mouse.Y ) )
	Global finalWalkSpeed:Float 
	
	If App.ActiveWindow	
		If Keyboard.KeyDown( Key.LeftShift ) Or Keyboard.KeyDown( Key.RightShift )
			finalWalkSpeed = ( 3.0 * walkSpeed ) * delta
		ElseIf Keyboard.KeyDown( Key.LeftControl ) Or Keyboard.KeyDown( Key.RightControl )
			finalWalkSpeed = ( walkSpeed / 3.0 ) * delta
		Else
			finalWalkSpeed = walkSpeed * delta
		End
		
		If Keyboard.KeyDown( Key.W )' Or Keyboard.KeyDown( Key.Up )
			cam.MoveZ( finalWalkSpeed )
		ElseIf Keyboard.KeyDown( Key.S )' Or Keyboard.KeyDown( Key.Down )
			cam.MoveZ( -finalWalkSpeed )
		End
		
		If Keyboard.KeyDown( Key.A )' Or Keyboard.KeyDown( Key.Left )
			cam.MoveX( -finalWalkSpeed )
		ElseIf Keyboard.KeyDown( Key.D )' Or Keyboard.KeyDown( Key.Right )
			cam.MoveX( finalWalkSpeed )
		End
		
		If Keyboard.KeyDown( Key.R )
			cam.MoveY( finalWalkSpeed )
		ElseIf Keyboard.KeyDown( Key.F )
			cam.MoveY( -finalWalkSpeed )
		End
		
		If touchStyle
			If Mouse.ButtonHit( MouseButton.Left )
				prevMouse = New Vec2f( Float( Mouse.X ), Float( Mouse.Y ) )
			End
			If Mouse.ButtonDown( MouseButton.Left )
				prevMouse = MouseLook( cam, window, prevMouse, mouseLookSpeed/2.0 )
			End
		Else
			prevMouse = MouseLook( cam, window, prevMouse, -mouseLookSpeed )
			
			'limits mouse to center of screen to prevent losing it out of the window
			Local threshold := window.Height / 10
			Local center := New Vec2i( window.Width/2, window.Height/2 )
			Local limit := New Recti( center.X - threshold, center.Y - threshold, center.X + threshold, center.Y + threshold )
			If Mouse.X < limit.Left Or Mouse.X > limit.Right Or Mouse.Y < limit.Top Or Mouse.Y > limit.Bottom
				Mouse.Location = New Vec2i( center.X, center.Y )
				prevMouse = Mouse.Location
			End
		End
	End
End


Private
Function MouseLook:Vec2f( ent:Entity, window:Window, prevMouse:Vec2f, speed:Float )
	Local diff:= New Vec2f( Mouse.X - prevMouse.X, prevMouse.Y - Mouse.Y )
	If Abs( diff.X ) > 0
		ent.RotateY( diff.X * speed, False )
		prevMouse.X = Mouse.X
	End	
	If Abs( diff.Y ) > 0
		ent.RotateX( diff.Y * speed, False )
		prevMouse.Y = Mouse.Y
	End	
	ent.LocalRotation = New Vec3f( ent.LocalRx, ent.LocalRy, 0 )
	
	Return prevMouse
End
