Namespace game3d

#Import "<std>"
#Import "<reflection>"
#Import "<mojo>"
#Import "<mojo3d>"
#Import "<mojo3d-loaders>"
#Import "<mojo3d-physics>"

#Import "core/gameobject"
#Import "core/materialLibrary"

#Import "components/cameracomponent"
#Import "components/lightcomponent"
#Import "components/assignmaterial"
#Import "components/geometry/loadmodel"
#Import "components/geometry/donutmodel"
#Import "components/geometry/gridmodel"

#Import "extensions/entity"
#Import "extensions/matrix"
#Import "extensions/rect"
#Import "extensions/canvas"
#Import "extensions/vector"
#Import "extensions/color"
#Import "extensions/scene"
#Import "extensions/material"
#Import "extensions/texture"
#Import "extensions/model"
#Import "extensions/gameobject"

#Import "core/serial"

#Import "math/math"
#Import "math/area"

#Import "clock/clock"

#Import "graphics/grid"

#Import "util/profile"
#Import "util/navigation"


Using std..
Using mojo..
Using mojo3d..

Using math..
Using clock..
Using util..

Const smallFont:Font = Font.Load( "font::DejaVuSans.ttf", 12 )

Global developmentPath:String = Null

Class SceneView Extends View
	Field keyPause := Key.P						'shortcut used to pause
	Field keyReload := Key.R					'shortcut used to reload the current scene
	
	Field devMode:= False					'displays feedback info, allows dev shortcuts
	Field editMode:= False						'allows content editing
	Field autoRender := True					'if on, events need to call RequestRender(), app style
	Field render3DScene := False				'enable to render Mojo3D scenes
	
	Field StartDone: Void()
	
	Protected
	Field _scene:Scene
	Field _canvas:Canvas
	
	Field _camera:Camera
	Field _camera2D:Area<Double>
	Field _virtualRes:Rect<Double>
	Field _keyLight:Light
	
	Private
	Global _currentViewer:SceneView

	Field _firstFrame := True
	Field _init := False
	Field _paused:= False
	Field _echoStack:= New Stack<String>		'Contains all the text messages to be displayed
	Field _echoColorStack:= New Stack<Color>	'Contains all the text messages colors
	
	Public
	
	'********************************* Public Properties *********************************

	Property Canvas:Canvas()
		Return _canvas
	End
	
	
	Property Scene:Scene()
		Return _scene
	End
	
	
	Property Camera:Camera()
		Return _camera
	Setter( cam:Camera )
		_camera = cam
	End
	
	
	Property Camera2D:Area<Double>()
		Return _camera2D
	End
	
	
	Property KeyLight:Light()
		Return _keyLight
	End
	
	
	Property Paused:Bool()
		Return _paused
	Setter( state:Bool )
		_paused = state
		Clock.Pause( state )	
	End
	
	
	Property AspectRatio:Double()
		Return _camera2D.Width/_camera2D.Height
	Setter( ratio:Double )
		_camera2D.Width = _camera2D.Height * ratio
	End
	
	
	Property CanvasScale:Vec2<Double>()
		Local frameWidth:Double = Double(Frame.Width) 
		Local frameHeight:Double = Double(Frame.Height)
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
		
		'Integer layout hack, prevents some annoying rounding errors
		Select Layout
		Case "stretch-int", "letterbox-int","scale-int"
			frameWidth += 0.00000001
			frameHeight += 0.00000001
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
	
	Method New( width:Int=1280, height:Int=720, render3DScene:Bool = True )
		_currentViewer = Self
		
		'Camera2D, used for 2D rendering on top of the 3D scene. Sets the virtual resolution.
		_camera2D = New Area<Double>( 0, 0, width, height )
		
		Self.render3DScene = render3DScene

		'3D Scene
'		_scene = Scene.GetCurrent()
		
		Style.Font = smallFont
	End
	
	
	Method OnMeasure:Vec2i() Override Final
		Return _camera2D.Size
	End
	
	
	Method OnRender( canvas:Canvas ) Override Final
		Echo( "Width="+Frame.Width+",Height="+Frame.Height+",    Camera2D=" + Camera2D.ToString() + ",    FPS="+App.FPS + ",    WorldMouse=" + WorldMouse + ",    Clock:" + Truncate( Clock.Now() ) )

		If autoRender Then App.RequestRender()		
		Self._canvas = canvas
		
		'****************** Init *********************
		
		If Not _init
			Reload()
		End
		
		'****************** First frame **************
		
		If _firstFrame
			Print( "Game3D: First frame" )
			Scene.Start()	'Maybe: set Viewer property here?
			StartDone()
			_firstFrame = False
		End
		
		'********* Update necessary modules *********
		
		Clock.Update()
		
		'****************** Update loop *************
		
		Profile.Start( "upd" )
		
		If Not editMode
			If Not _paused
				OnUpdate()
				Scene.Update()
				_scene.World.Update()
			End
		End
		
		Profile.Finish( "upd" )
		Echo( "Update: " + Profile.GetString( "upd" ) )
		
		'****************** Draw loop ****************
		
		Profile.Start( "drw" )
		
		'3D drawing
		If render3DScene
			If Camera
				_scene.Render( _canvas, _camera )
			Else
				Echo( "No Camera!")
			End
		End
		
		'2D drawing
		canvas.PushMatrix()
		
		_camera2D.Width = Clamp<Double>( _camera2D.Width, 8.0 * AspectRatio, 2160.0 * AspectRatio )
		_camera2D.Height = Clamp<Double>( _camera2D.Height, 8.0, 2160.0 )
		
		Select Layout
		Case "fill", "resize"
			Local frameAspect := Double(Frame.Width)/Double(Frame.Height)
			AspectRatio = frameAspect
			Local scale := Double(Frame.Height)/_camera2D.Height
			canvas.Scale( scale, scale )
		End
		canvas.Translate( -_camera2D.X + (_camera2D.Width/2.0), -_camera2D.Y + (_camera2D.Height/2.0) )
		Scene.Draw( canvas )
		OnDraw( canvas )
		canvas.PopMatrix()			
		canvas.Flush()
		
		Profile.Finish( "drw" )
		Echo( "Render: " + Profile.GetString( "drw" ) )
		If devMode Then DrawEcho( canvas )

		'**************** Input ****************	'Needs to be after DrawEcho()
		
		If devMode And Keyboard.KeyDown( Key.LeftGui ) And Keyboard.KeyDown( Key.LeftAlt )
			If Keyboard.KeyHit( keyPause ) Then Paused = Not Paused		
			If Keyboard.KeyHit( keyReload )
				Reload()
				Paused = False	
			End
		End
		
		'**************** Clean up ****************
		
		If Not _paused
			_echoStack.Clear()
			_echoColorStack.Clear()
		End
	End
	
	
	Method Reload()
		
		'****************** Clear current Mojo3d scene *********************
		
		Print( "Game3D: Init" )
		MaterialLibrary.Clear()
		
		If _scene
			For Local obj := Eachin GameObject.GetFromScene( _scene )
				obj.Destroy( False )
			Next
			_scene.DestroyAllEntities()
		End

		'****************** Init *********************
		
		_scene = New Scene
		mojo3d.graphics.Scene.SetCurrent( _scene )
		
		If Layout = "fill" Then _camera2D.SetSize( Width, Height )
		Clock.Reset()
		OnStart()
		_init = True
		_firstFrame = True	'forces OnStart() to run again
		
	End
	
	
	Method Echo( text:String, alwaysDisplay:Bool = True, color:Color = Color.White )
		If Not Paused
			If devMode Or alwaysDisplay
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
	
	Function Current:SceneView()
		Return _currentViewer	
	End
	
End

Function Asset:String( folder:String, file:String )
	Local path := ""
	If developmentPath
		path = developmentPath + folder + "/" + file
	Else
		path = "asset::" + file
	End
	Return path
End




