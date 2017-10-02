#Import "../game3d"

#Import "components/spin"
#Import "components/changecolor"

#Import "images/wireGlow.png"
#Import "models/teapotLow.fbx"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )
		Local gameView := New GameView( 1280, 720, True )
		ContentView = gameView
	End
End

Class GameView Extends SceneView
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Layout = "letterbox"
		displayInfo = True
		
		Scene.ClearColor = Color.Black
		Scene.EnvColor = Color.Black
		Scene.AmbientLight = Color.Black

		Local json := JsonObject.Load( "/Users/Leo/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/testScene.json" )
		DeserializeGameObjects( json )
	End
	
	Method OnUpdate() Override
		WasdCameraControl( Camera, Self )	
	End
End

