
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

Const smallFont:Font = Font.Load( "font::DejaVuSans.ttf", 10 )

Class SceneView Extends View
	
	Field canvas:Canvas
	Field currentScene:Scene
	Field camera:Camera
	Field camera2D:Area<Double>
	Field keyLight:Light
	Field fog:FogEffect
	
	Field keyPause := Key.P
	Field debug:= True
	Field render3DScene := False
	
	Protected
	Field _firstFrame := True
	Field _paused:= False
	Field _echoStack:= New Stack<String>		'Contains all the text messages to be displayed
	Field _echoColorStack:= New Stack<Color>	'Contains all the text messages colors
	
	Public
	'********************************* Public Properties *********************************
	
	Property Aspect:Double()
		Return Double(Width)/Double(Height)
	End
	
	Property CanvasScale:Double()
		Return Double(Height)/camera2D.Height
	End
	
	Property Paused:Bool()
		Return _paused	
	End
	
	Property WorldMouse:Vec2i()
		Local _mouse := TransformPointFromView( App.MouseLocation, Null )
		Return New Vec2i( (_mouse.X/(Width/camera2D.Width)) + camera2D.Left, (_mouse.Y/CanvasScale) + camera2D.Top )
	End
	
	'********************************* Public Methods *********************************
	
	Method New( width:Int=1280, height:Int=720, create3DScene:Bool )
		'Camera2D, used for 2D rendering on top of the 3D scene. Sets the virtual resolution.
		camera2D = New Area<Double>( 0, 0, width, height )
		
		If create3DScene
			render3DScene = True
			
			'3D Scene
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
			
			'Default Light
			keyLight = New Light
			keyLight.Rotate( 45, 45, 0 )
		End
		
'		game = Self
		Style.Font = smallFont
	End
	
	
	Method OnMeasure:Vec2i() Override Final
		Return camera2D.Size
	End
	
	
	Method OnRender( canvas:Canvas ) Override Final
		Echo( "Width="+Width+",Height="+Height+",    Camera2D=" + camera2D.ToString() + ",    FPS="+App.FPS + ",    WorldMouse=" + WorldMouse + ",    Clock:" + Truncate( Clock.Now() ) )
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
	
	
	Method Echo( text:String, ignoreDebug:Bool = True, color:Color = Color.White )
		If Not Paused
			If debug Or ignoreDebug
				_echoStack.Push( text )
				_echoColorStack.Push( color )
			End
		End
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
	
	Method DrawEcho( drawRect:Bool = False )
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
	
End




