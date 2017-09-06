
Namespace game3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "gameobj"
#Import "math/math"
#Import "math/area"
#Import "math/matrix_ext"
#Import "clock/clock"
#Import "util/wasd"
#Import "util/profile"
#Import "graphics/canvas_ext"


Using std..
Using mojo..
Using mojo3d..

Using math..
Using clock..
Using util..

Const smallFont:Font = Font.Load( "font::DejaVuSans.ttf", 10 )

Class SceneView Extends View

	Field keyPause := Key.P						'shortcut used to pause
	Field displayInfo:= False					'displays feedback info
	Field editMode:= False						'allows content editing
	Field autoRender := True					'if on, events need to call RequestRender(), app style
	Field render3DScene := False				'enable to render Mojo3D scenes
	
	Protected
	Field _canvas:Canvas
	Field _currentScene:Scene
	Field _camera:Camera
	Field _camera2D:Area<Double>
	Field _keyLight:Light
	Field _fog:FogEffect
	
	Private
	Field _firstFrame := True
	Field _paused:= False
	Field _echoStack:= New Stack<String>		'Contains all the text messages to be displayed
	Field _echoColorStack:= New Stack<Color>	'Contains all the text messages colors
	
	Public
	'********************************* Public Properties *********************************

	Property Canvas:Canvas()
		Return _canvas
	End
	
	
	Property CurrentScene:Scene()
		Return _currentScene
	End
	
	
	Property Camera:Camera()
		Return _camera
	End
	
	
	Property Camera2D:Area<Double>()
		Return _camera2D
	End
	
	
	Property KeyLight:Light()
		Return _keyLight
	End
	
	
	Property Fog:FogEffect()
		Return _fog
	End
	
	
	Property Paused:Bool()
		Return _paused	
	End
	
	
	Property AspectRatio:Double()
		Return Double(Width)/Double(Height)
	End
	
	
	Property CanvasScale:Vec2<Double>()
		Local frameWidth:Double = Double(Frame.Width) + 0.00000001		'prevents some annoying roundng errors
		Local frameHeight:Double = Double(Frame.Height) + 0.00000001
		Local aspect:Double= AspectRatio
		Local parentAspect:Double = frameWidth / frameHeight
		Local w:Double, h:Double
		'Calculates width and height including letterboxing areas 
		If parentAspect = aspect
			w = _camera2D.Width
			h = _camera2D.Height
		ElseIf parentAspect > aspect
			w = _camera2D.Height*parentAspect
			h = _camera2D.Height
		Else
			w = _camera2D.Width
			h = _camera2D.Width/parentAspect
		End
		'Handle Layout styles
		Select Layout
		Case "stretch"
			Return New Vec2<Double>( frameWidth/_camera2D.Width, frameHeight/_camera2D.Height )
		Case "stretch-int"
			Return New Vec2<Double>( Floor(frameWidth/_camera2D.Width), Floor(frameHeight/_camera2D.Height) )
		Case "scale-int","letterbox-int"
			Return New Vec2<Double>( Floor(frameWidth/w), Floor(frameHeight/h) )
		Case "scale","letterbox"
			Return New Vec2<Double>( frameWidth/w, frameHeight/h )
		End
		'All other Layout styles
		Return New Vec2<Double>( 1.0, 1.0 )
	End
	
	
	Property ViewMouse:Vec2i()
		Return TransformPointFromView( App.MouseLocation, Null )
	End
	
	
	Property WorldMouse:Vec2i()
		Local _mouse := TransformPointFromView( App.MouseLocation, Null )
		Return New Vec2i( (_mouse.X/(Width/_camera2D.Width)) + _camera2D.Left, _mouse.Y+_camera2D.Top )
	End
	
	
	'********************************* Public Methods *********************************
	
	Method New( width:Int=1280, height:Int=720, create3DScene:Bool )
		'Camera2D, used for 2D rendering on top of the 3D scene. Sets the virtual resolution.
		_camera2D = New Area<Double>( 0, 0, width, height )
		Style.BorderColor = Color.Black
		
		If create3DScene
			render3DScene = True
			
			'3D Scene
			_currentScene = Scene.GetCurrent()
			_currentScene.ClearColor = Color.Black'New Color( .1, .1, .1 )
			_currentScene.AmbientLight = Color.Black
			
			'Camera
			_camera = New Camera
			_camera.Fov = 60
			_camera.Near = 0.1
			_camera.Far = 100
			_camera.Move( 5, 5, -10 )
			_camera.Rotate( 30, 45, 0 )
			
			'Default Light
			_keyLight = New Light
			_keyLight.Rotate( 45, 45, 0 )
		End
		
		Style.Font = smallFont
	End
	
	
	Method OnMeasure:Vec2i() Override Final
		Return _camera2D.Size
	End
	
	
	Method OnRender( canvas:Canvas ) Override Final
		Echo( "Width="+Width+",Height="+Height+",    Camera2D=" + Camera2D.ToString() + ",    FPS="+App.FPS + ",    WorldMouse=" + WorldMouse + ",    Clock:" + Truncate( Clock.Now() ) )

		If autoRender Then App.RequestRender()		
		Self._canvas = canvas
		
		If _firstFrame
			'********* Init *********
			Clock.Reset()
			OnStart()
			For Local obj := Eachin GameObj.all.Values
				obj.Init()
			Next
			_firstFrame = False
			App.RequestRender()
		Else
			'********* Update necessary modules *********
			Clock.Update()
			
			'********* Update *********
			Profile.Start( "upd" )
			_camera2D.SetSize( Width, Height )
			If Not editMode
				If Not _paused
					OnUpdate()
					For Local obj := Eachin GameObj.rootObjs.Values
						obj.Update()
					Next
				End
			End
			Profile.Finish( "upd" )
			Echo( "Update: " + Profile.GetString( "upd" ) )
			
			'********* Draw *********
			Profile.Start( "drw" )
			'3D drawing
			If render3DScene Then _currentScene.Render( _canvas, _camera )
			'2D drawing
			canvas.PushMatrix()
'			canvas.Scale( CanvasScale, CanvasScale )
			canvas.Translate( -_camera2D.X + (_camera2D.Width/2.0), -_camera2D.Y + (_camera2D.Height/2.0) )
			OnDraw( canvas )
			canvas.PopMatrix()			
			canvas.Flush()
			Profile.Finish( "drw" )
			Echo( "Render: " + Profile.GetString( "drw" ) )
			If displayInfo Then DrawEcho( canvas )

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
	
	
	Method Echo( text:String, alwaysDisplay:Bool = True, color:Color = Color.White )
		If Not Paused
			If displayInfo Or alwaysDisplay
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

	
	Method DrawEcho( canvas:Canvas, drawRect:Bool = False )
		canvas.PushMatrix()
		canvas.Scale( 1.0/ CanvasScale.X, 1.0/ CanvasScale.Y )	'compensates for Layout scaling
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
			lineY += _canvas.Font.Height
		Next
		canvas.PopMatrix()
	End
	
	
	'********************************* Static Functions *********************************
	
	Public
	
End




