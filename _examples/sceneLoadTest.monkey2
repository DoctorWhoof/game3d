#Import "../game3d"
#Import "components/spin"
#Import "components/changecolor"

#Import "scenes/"
#Import "images/"
#Import "models/"

Using game3d..

Const devPath := HomeDir() + "/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/"
'Const devPath := "asset::"

Function Main()
	Local config:=New StringMap<String>
	config["mojo3d_renderer"]="forward"
	New AppInstance( config )
'	New AppInstance
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
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Texture.Load( devPath + "testTextures.json" )
		Material.Load( devPath + "testMaterials.json" )
		GameObject.Load( devPath + "testScene.json" )
		
		Local glow := New BloomEffect(2)
		Scene.AddPostEffect( glow )
	End

	Method OnUpdate() Override
		WasdCameraControl( Camera, Self )', 1.0, True )	'Use touch mode if any mouse/keyboard sharing system is present	
	End
End

