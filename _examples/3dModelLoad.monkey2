#Import "../game3d"
#Import "<mojo3d-physics>"

#Import "../util/navigation"
#Import "components/spin"

#Import "models/asteroidLow.fbx"
#Import "images/stars.png"
#Import "images/wireTriangle.png"
#Import "images/black.png"

Using game3d..
Using assimp..
Using mojo3d.physics

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	
	Field gameView:GameView
	
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )' | WindowFlags.Maximized )
		gameView = New GameView( 1280, 720 )
		ContentView = gameView
		ClearColor = Color.Black
'		WasdInit( gameView )
	End
	
	Method OnRender( canvas:Canvas ) Override
		WasdCameraControl( gameView.Camera, gameView, Clock.Delta(), False )	
	End
End

Class GameView Extends SceneView
	
	Field asteroid:Model
	Field asteroidVertices:Vertex3f[]
	Field world:World
	
	Method New( width:Int, height:Int )
		Super.New( width, height, True )
	End	
	
	Method OnStart() Override
		Layout = "letterbox"
		displayInfo = True
		
		Scene.SkyTexture = New Texture( Pixmap.Load( "asset::stars.png"), TextureFlags.Cubemap )
		Scene.EnvTexture = New Texture( Pixmap.Load( "asset::black.png"), TextureFlags.Cubemap )
		Scene.AmbientLight = Color.Black
		Scene.ClearColor = Color.Black
		
		Local bloom := New BloomEffect( 2 )
		Scene.AddPostEffect( bloom )
		
		Local mat :=  New PbrMaterial( True, False, False )
		Local texture := New Texture( Pixmap.Load( "asset::wireTriangle.png" ), TextureFlags.FilterMipmap )
		mat.ColorFactor = Color.Red
		mat.ColorTexture = texture
'		mat.EmissiveFactor = Color.Red
'		mat.EmissiveTexture = texture

		asteroid = Model.Load( "asset::asteroidLow.fbx" )
		asteroid.Materials = New Material[]( mat )
			
'		asteroid.AddComponent( New Spin( Rnd(0,0.1), Rnd(0,0.2), Rnd(0,0.1) ) )
		asteroid.Mesh.FitVertices( New Boxf(-10,-10,-10,10,10,10) )
'		asteroid.Visible = False

		Camera.Move( 0, 0, -15 )
		Camera.Near = 0.2
		Camera.Far = 100.0
		
		KeyLight.Visible = False
		
		world = Scene.World
		
		Local collider := New MeshCollider( asteroid.Mesh )
		Local body := New DynamicBody( collider, asteroid )
		body.ApplyTorqueImpulse( New Vec3f(1, 2, 1 ) )
		
		New KinematicBody( New SphereCollider( 1 ), Camera )
		world.Gravity = New Vec3f( 0,0,0 )
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		If Keyboard.KeyDown( Key.Right )
			Camera.Ry -= 1.0
		Else If Keyboard.KeyDown( Key.Left )
			Camera.Ry += 1.0
		End
		
		If Keyboard.KeyDown( Key.Up )
			Camera.Rx -= 1.0
		Else If Keyboard.KeyDown( Key.Down )
			Camera.Rx += 1.0
		End
		
		Local v1 := New Vec3f(0,-1,0)
		Local v2 := New Vec3f(0,1,0)
		
		canvas.Color = Color.Red
'		canvas.Alpha = 0.1
		If asteroid Then canvas.DrawWireframe( world, Camera, asteroid, Width/2.0, Height/2.0 )
	End
	
End


















