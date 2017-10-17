#Import "../game3d"
#Import "components/spin"
#Import "../components/wireframerenderer"

#Import "models/asteroidLow.fbx"

#Import "scenes/wireframeScene.json"
#Import "scenes/testMaterials.json"

Using game3d..

Const devPath := "asset::"

Function Main()
	Local config:=New StringMap<String>
	config["mojo3d_renderer"]="forward"

	New AppInstance( config )
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
		Material.Load( devPath + "testMaterials.json" )
		GameObject.Load( devPath + "wireframeScene.json" )
	End
End


















