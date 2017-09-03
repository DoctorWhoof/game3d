#Import "../clock"
#Import "<mojo>"

Using mojo..
Using clock

Function Main()
	New AppInstance
	New Test
	App.Run()
End

Class Test Extends Window

	Field firstFrame := True

	Method New()
		Super.New( "Test", 512, 512 )
		Clock.deltaStyle = Clock.perSecond
	End
	
	Method OnRender( canvas:Canvas ) Override
		'Prepare canvas
		canvas.Clear( Color.Grey )
		App.RequestRender()
		
		'Reset Clock if first frame
		If firstFrame
			Clock.Reset()
			firstFrame = False
		End
		
		'This must be called on every frame to ensure Clock is correct
		Clock.Update()
		
		'Hotkeys
		If Keyboard.KeyPressed( Key.P ) Then Clock.PauseToggle()		
		If Keyboard.KeyPressed( Key.Minus ) Then Clock.scale -= 0.2
		If Keyboard.KeyPressed( Key.Equals ) Then Clock.scale += 0.2
		
		'Draw visuals
		canvas.DrawText( "Now: " + Clock.Now(), 10, 10 )
		canvas.DrawText( "Delta: " + Clock.Delta(), 10, 30 )
		canvas.DrawText( "Time scale: " + Clock.scale, 10, 50 )
		canvas.DrawText( "FPS: " + Clock.FPS(), 10, 70 )
		canvas.DrawText( "Use 'P' for pause, 'plus' and 'minus' keys for time scaling", 10, 490 )
		canvas.Translate( 256, 256 )
		canvas.DrawCircle( 0, 0, 150 )
		canvas.Color = Color.Black
		canvas.Rotate( -Clock.Now() * TwoPi )
		canvas.DrawRect( -2, 0, 4, -150 )
	End

End