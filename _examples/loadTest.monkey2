
#Import "../game3d"
#Import "../graphics/grid"

#Import "components/spin"
#Import "components/loadmodel"
#Import "components/loadpbrmaterial"

#Import "images/wire.png"
#Import "images/cat.png"
#Import "images/black.png"
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
		Scene.EnvTexture = Texture.Load( "asset::black.png", Null )

'		Local json := JsonObject.Load( "/Users/Leo/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/testsceneTemp.json" ) 
		Local json := JsonObject.Load( "/home/leosantos/dev/game3d/_examples/scenes/testscene.json" ) 
		Deserialize( json )
		
		For Local g := Eachin GameObject.All()
			g.List()
		End
	End
End

