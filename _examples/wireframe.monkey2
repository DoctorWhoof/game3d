#Import "../game3d"

#Import "models/"
#Import "scenes/"
#Import "materials/"

Using game3d..

Function Main()
	Local config:=New StringMap<String>
	New AppInstance
	New TestWindow
	App.Run()
End


Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable | WindowFlags.HighDPI )
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
		Material.Load( "asset::testMaterials.json" )
		GameObject.Load( "asset::wireframeScene.json" )
	End
End


















