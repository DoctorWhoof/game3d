Namespace game3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
Using std..
Using mojo..
Using mojo3d..


Function Navigate2D( viewer:SceneView, event:MouseEvent, panSpeed:Double = 100.0, zoomSpeed:Double = 100.0 )
	Select event.Type
	Case EventType.MouseWheel
		If event.Modifiers = Modifier.LeftAlt
			'Zoom with alt + wheel
			Local aspect := viewer.AspectRatio
			viewer.Camera2D.Height += ( ( Exp( event.Wheel.Y/100.0)-1.0 ) * zoomSpeed )
			viewer.Camera2D.Width = viewer.Camera2D.Height * aspect
		Else
			'Pan with wheel (two fingers on touchpad)
			viewer.Camera2D.X += ( ( Exp( event.Wheel.X/100.0)-1.0 ) * panSpeed )
			viewer.Camera2D.Y -= ( ( Exp( event.Wheel.Y/100.0)-1.0 ) * panSpeed )
		End
		App.RequestRender()
	End
End


Function Navigate3D( viewer:SceneView, event:MouseEvent, target:Entity, panSpeed:Double = 20.0, zoomSpeed:Double = 20.0, orbitSpeed:Double = 0.5 )
	'To do: instead of pivot entity, rotate around target using Translation based on sin/cos, then PointAt( target )
	Global click := New Vec2i
	
	Local  camera := viewer.Camera
	Local parent := viewer.Camera.Parent
	Assert( parent <> Null, "Navigate3D: Camera needs a parent entity (orbit pivot)" )
	
	If Mouse.ButtonPressed( MouseButton.Left ) Or Mouse.ButtonPressed( MouseButton.Middle ) Or Mouse.ButtonPressed( MouseButton.Right )
		click.X = viewer.ViewMouse.X
		click.Y = viewer.ViewMouse.Y
	End
	
	If Keyboard.KeyDown( Key.LeftAlt )
		If Mouse.ButtonDown( MouseButton.Left )
			Local diff := New Vec2i( viewer.ViewMouse.X - click.X, viewer.ViewMouse.Y - click.Y )
			parent.Rotate( diff.Y*orbitSpeed, -diff.X*orbitSpeed, 0, True )
			parent.Rz = 0
			click.X = viewer.ViewMouse.X
			click.Y = viewer.ViewMouse.Y
			App.RequestRender()
		Else If Mouse.ButtonDown( MouseButton.Middle )
			Local diff := New Vec2i( viewer.ViewMouse.X - click.X, viewer.ViewMouse.Y - click.Y )
			camera.LocalX -= ( diff.X * (0.5/panSpeed) )
			camera.LocalY += ( diff.Y * (0.5/panSpeed) )
			click.X = viewer.ViewMouse.X
			click.Y = viewer.ViewMouse.Y
			App.RequestRender()
		Else If Mouse.ButtonDown( MouseButton.Right )
			Local diff := New Vec2i( viewer.ViewMouse.X - click.X, viewer.ViewMouse.Y - click.Y )
'			camera.LocalX -= ( diff.X * (0.5/panSpeed) )	'shold be optional
			camera.LocalZ += ( diff.Y * (0.5/panSpeed) )
			click.X = viewer.ViewMouse.X
			click.Y = viewer.ViewMouse.Y
			App.RequestRender()
		End
	End
	
	Select event.Type
	Case EventType.MouseWheel
		If event.Modifiers = Modifier.LeftAlt
			'Zoom with alt + wheel
			viewer.Camera.LocalZ += ( ( Exp( event.Wheel.Y/100.0 ) - 1.0 ) * panSpeed )
			viewer.Camera.LocalX += ( ( Exp( event.Wheel.X/100.0 ) - 1.0 ) * panSpeed )
		Else
			'Pan with wheel (two fingers on touchpad)
			viewer.Camera.LocalX += ( ( Exp( event.Wheel.X/100.0 ) - 1.0 ) * panSpeed )
			viewer.Camera.LocalY += ( ( Exp( event.Wheel.Y/100.0 ) - 1.0 ) * panSpeed )
		End
		App.RequestRender()
	End
End

Public
Function WasdInit( window:View, showMouse:Bool = False )
'	Mouse.Location = New Vec2i( window.Width / 2, window.Height / 2 )
	Mouse.PointerVisible = showMouse
	'If the mouse is off window, camera freaks out
	'A way to force the mouse into the window would solve it. Setting Mouse.Location only works when the mouse is over the window.
End

'Works better in full screen! In windowed mode the mouse cursor seems to be "lost" sometimes
'Call WASDInit a single time on start, then WASDCameraControl on every frame.
'The default values work well with delta = 1.0. Adjust if your delta is counted in seconds instead.
Function WasdCameraControl( cam:Entity, view:View, delta:Double = 1.0, touchStyle:Bool = False ,walkSpeed:Float = 0.1, mouseLookSpeed:Float = 0.2 )
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
		
		If Keyboard.KeyDown( Key.W )
			cam.MoveZ( finalWalkSpeed )
		ElseIf Keyboard.KeyDown( Key.S )
			cam.MoveZ( -finalWalkSpeed )
		End
		
		If Keyboard.KeyDown( Key.A )
			cam.MoveX( -finalWalkSpeed )
		ElseIf Keyboard.KeyDown( Key.D )
			cam.MoveX( finalWalkSpeed )
		End
		
		If Not Keyboard.KeyDown( Key.LeftGui )
			If Keyboard.KeyDown( Key.R )
				cam.MoveY( finalWalkSpeed )
			ElseIf Keyboard.KeyDown( Key.F )
				cam.MoveY( -finalWalkSpeed )
			End
		End
		
		If touchStyle
			If Mouse.ButtonHit( MouseButton.Left )
				prevMouse = New Vec2f( Float( Mouse.X ), Float( Mouse.Y ) )
			End
			If Mouse.ButtonDown( MouseButton.Left )
				prevMouse = MouseLook( cam, view, prevMouse, mouseLookSpeed/2.0 )
			End
		Else
			prevMouse = MouseLook( cam, view, prevMouse, -mouseLookSpeed )
			
			'limits mouse to center of screen to prevent losing it out of the window
			Local threshold := view.Frame.Height / 10
			Local center := New Vec2i( view.Frame.Width/2, view.Frame.Height/2 )
			Local limit := New Recti( center.X - threshold, center.Y - threshold, center.X + threshold, center.Y + threshold )
			If Mouse.X < limit.Left Or Mouse.X > limit.Right Or Mouse.Y < limit.Top Or Mouse.Y > limit.Bottom
				Mouse.Location = New Vec2i( center.X, center.Y )
				prevMouse = Mouse.Location
			End
		End
	End
End


Private
Function MouseLook:Vec2f( ent:Entity, window:View, prevMouse:Vec2f, speed:Float )
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

