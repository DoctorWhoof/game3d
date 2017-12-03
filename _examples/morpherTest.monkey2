#Import "../game3d"

#Import "scenes/"
#Import "materials/"
#Import "images/"
#Import "models/"

Using game3d..

Function Main()
	Local config:=New StringMap<String>
	New AppInstance()
	New TestWindow
	App.Run()
End


Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )
		Local gameView := New GameView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.devMode = True
		
		ContentView = gameView
		ClearColor = Color.Black
	End
End


Class GameView Extends SceneView
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D, False )
	End

	Method OnStart() Override
		Texture.Load( "asset::testTextures.json" )
		Material.Load( "asset::testMaterials.json" )
		GameObject.Load( "asset::morpher.json" )
		
		Scene.ClearColor = Color.Black
		Local glow := New BloomEffect(2)
		Scene.AddPostEffect( glow )
	End

	Method OnUpdate() Override
		WasdCameraControl( Camera, Self )', 1.0, True )	'Use touch mode if any mouse/keyboard sharing system is present	
	End
End

