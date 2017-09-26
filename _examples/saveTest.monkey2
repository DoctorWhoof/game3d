
#Import "../game3d"
#Import "../graphics/grid"

#Import "components/spin"
#Import "components/baseobject"
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
		
		Camera.Move( 0, 1, -2 )
		Camera.PointAt( New Vec3f( 0 ) )
		
		Local teapot := New Model
		teapot.AddComponent( New BaseObject( "teapot" ) )
		teapot.AddComponent( New LoadModel( "asset::teapotLow.fbx" ) )
		teapot.AddComponent( New LoadPbrMaterial( Color.Red, 0.1, 0.5 ) )
		
		teapot.Move( 0, 0.1, 0.2 )
		
		StartDone = Lambda()
			Local json:= New JsonObject
			For Local e := Eachin Scene.GetRootEntities()
				Print e.Name
				json.SetObject( e.Name, e.ToJson().ToObject() )
			Next
'			json.SetObject( teapot.Name, teapot.ToJson().ToObject() )
'			SaveString( json.ToJson(), "/Users/Leo/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/testscene.json" )
			Print( json.ToJson() )
		End

	End
	
	
End

