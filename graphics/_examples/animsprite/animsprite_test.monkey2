#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
#Import "../../animsprite"

#Import "explosion.png"
#Import "explosion.json"

Using std..
Using mojo..
Using mojo3d..

Function Main()
	New AppInstance
	New Test
	App.Run()
End

Class Test Extends Window
	Field scene:Scene
	Field mainCam:Camera
	Field keyLight:Light
	Field explosions:= New Stack<AnimSprite>
	Field area := New Rectf( -30, -30, 25, 25 )

	Method New()
		Super.New( "Test", 800, 450, WindowFlags.Resizable )
		
		'Scene
		scene = Scene.GetCurrent()
		scene.ClearColor = Color.Black
		scene.AmbientLight = Color.White
		
		'Camera
		mainCam = New Camera
		mainCam.Move( 0, -30, -12 )
		mainCam.Rotate( -45, 0, 0 )
		mainCam.Fov = 60
		
		'Explosions!
		For Local n := 1 To 100
			Local boom := New AnimSprite( "asset::explosion.png", 32, 32, 0, 0, Null )
			boom.LoadAnimations( "asset::explosion.json" )
			
			Local scl := Rnd( 3, 6 )
			boom.Scale = New Vec3f( scl, scl, scl )
			
			boom.Animation = "mediumSpeed"
			boom.FrameOffset = Rnd( -4, 4 )
			boom.FrameRate = Rnd( 10, 20 )
			
			boom.onFirstFrame += Lambda()
				Print( "Start" + Millisecs() )
			End
			
			boom.onFirstFrame += Lambda()
				boom.Position = New Vec3f( Rnd( area.Left, area.Right), Rnd( area.Top, area.Bottom ), -1 )
				Print( "End" + Millisecs() )
			End
			
			explosions.Push( boom )
		Next

	End

	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		
		Local time:= Microsecs() / 1000000.0 
		For Local boom := Eachin explosions
			boom.Update( time )
		Next		
		
		scene.Render( canvas, mainCam )		
		mainCam.Y += 0.05
		If mainCam.Y > 20 Then  mainCam.Y = -40
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS + ", Time="+Int(time) ,0,0 )
	End
End