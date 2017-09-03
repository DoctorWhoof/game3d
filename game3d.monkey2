
Namespace game3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "gameobj"
#Import "math/math"
#Import "math/area"
#Import "clock/clock"
#Import "util/wasd"
#Import "util/profile"

Using std..
Using mojo..
Using mojo3d..

Using math..
Using clock..
Using util..

Class Game Extends Window
	
	Global canvas :Canvas
	Global currentScene:Scene
	Global camera:Camera
	Global camera2D:Area<Double>
	Global keyLight:Light
	Global fog:FogEffect
	
	Global keyPause := Key.P
	Global debug:= True
	Global render3DScene := True
	
	Private
	Global _echoStack:= New Stack<String>		'Contains all the text messages to be displayed
	Global _echoColorStack:= New Stack<Color>	'Contains all the text messages colors
	
	Global _firstFrame := True
	Global _paused:= False
	
	Public
	'********************************* Public Properties *********************************
	
	Property Aspect:Double()
		Return Double(Width)/Double(Height)
	End
	
	Property CanvasScale:Double()
		Return Double(Height)/camera2D.Height
	End
	
	
	'********************************* Public Methods *********************************
	
	Method New( title:String="Simple mojo app",width:Int=1280, height:Int=720, flags:WindowFlags=WindowFlags.Resizable )
		Super.New( title,width,height,flags )
		currentScene = Scene.GetCurrent()
		currentScene.ClearColor = Color.Black'New Color( .1, .1, .1 )
		currentScene.AmbientLight = Color.Black
		
		'Camera
		camera = New Camera
		camera.Fov = 60
		camera.Near = 0.1
		camera.Far = 100
		camera.Move( 0, 5, -10 )
		camera.Rotate( 30, 0, 0 )
		
		'Camera2D, used for 2D rendering on top of the 3D scene. Sets the virtual resolution.
		camera2D = New Area<Double>( 0, 0, width, height )
		
		'Default Light
		keyLight = New Light
		keyLight.Rotate( 45, 45, 0 )
	End
	
	
	Method OnRender( canvas:Canvas ) Override
		Echo( "Width="+Width+", Height="+Height+", FPS="+App.FPS + ", Clock:" + Truncate( Clock.Now() ) )
		Echo( "Camera2D: " + camera2D.ToString() )
		Self.canvas = canvas
		App.RequestRender()
		
		If _firstFrame
			'********* Init *********
			Clock.Reset()
			OnStart()
			For Local obj := Eachin GameObj.all.Values
				obj.Init()
			Next
			_firstFrame = False
		Else
			'********* Update necessary modules *********
			Clock.Update()
			
			'********* Update *********
			Profile.Start( "upd" )
			camera2D.Width = Width / CanvasScale
			If Not _paused
				OnUpdate()
				For Local obj := Eachin GameObj.rootObjs.Values
					obj.Update()
				Next
			End
			Profile.Finish( "upd" )
			Echo( "Update: " + Profile.GetString( "upd" ) )
			
			'********* Draw *********
			Profile.Start( "drw" )
			'3D drawing
			If render3DScene Then currentScene.Render( canvas, camera )
			'2D drawing
			canvas.PushMatrix()
			canvas.Scale( CanvasScale, CanvasScale )
			canvas.Translate( -camera2D.X + (camera2D.Width/2.0), -camera2D.Y + (camera2D.Height/2.0) )
			OnDraw( canvas )
			canvas.PopMatrix()			
			canvas.Flush()
			Profile.Finish( "drw" )
			Echo( "Render: " + Profile.GetString( "drw" ) )
			Echo( "WorldMouse: " + WorldMouse() )
			DrawEcho()

			'********* Input *********
			If Keyboard.KeyHit( keyPause ) Then PauseToggle()		'Needs to happen after DrawEcho()
			
			'********* Clean up *********
			If Not _paused
				_echoStack.Clear()
				_echoColorStack.Clear()
			End

		End
	End
	
	
	Method PauseToggle()
		_paused = Not _paused
		Clock.PauseToggle()	
	End
	
	
	Method WorldMouse:Vec2i()
		Return New Vec2i( (Mouse.X/(Width/camera2D.Width)) + camera2D.Left, (Mouse.Y/CanvasScale) + camera2D.Top )
	End

	
	'********************************* Virtual Methods *********************************
	
	
	Method OnStart() Virtual
	End
	
	Method OnUpdate() Virtual
	End
	
	Method OnDraw( canvas:Canvas ) Virtual
	End
	
	
	'********************************* Private Methods *********************************
	
	Private
	
	Method DrawEcho( drawRect:Bool = True )
		Local lineY := 2
		For local n := 0 Until _echoStack.Length
			local text := _echoStack[ n ]
			canvas.BlendMode = BlendMode.Alpha
			canvas.Alpha = 1.0
			If drawRect
				canvas.Color = New Color( 0, 0, 0, 0.75 )
				canvas.DrawRect( 5, lineY, canvas.Font.TextWidth( text ), canvas.Font.Height )
			End
			canvas.Color = _echoColorStack[ n ]
			canvas.DrawText( text, 5, lineY )
			lineY += canvas.Font.Height
		Next
	End
	
	
	'********************************* Static Functions *********************************
	
	Public
	
	Function Paused:Bool()
		Return _paused	
	End
	
End


Function Echo( text:String, ignoreDebug:Bool = True, color:Color = Color.White )
	If Not Game.Paused()
		If Game.debug Or ignoreDebug
			Game._echoStack.Push( text )
			Game._echoColorStack.Push( color )
		End
	End
End




