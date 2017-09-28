#Import "../game3d"
#Import "../graphics/grid"

#Import "components/spin"
#Import "components/changecolor"

#Import "images/wire.png"
#Import "images/cat.png"
#Import "models/teapotLow.fbx"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
	
	Print Typeof( New Color( 1,1,0,1 ) )
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )
		
		Local gameView := New GameView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.displayInfo = True
		ContentView = gameView
		ClearColor = Color.Black
	End
End

Class GameView Extends SceneView
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Scene.ClearColor = Color.Black
		Scene.EnvColor = Color.Black
		Scene.AmbientLight = Color.Black
		
		Local  fog := New FogEffect( Color.Black, 1.0, 5.0 )
		Scene.AddPostEffect( fog )
		
		Local light := New GameObject( "light" )
		Local lightComp := light.AddComponent( New LightComponent )
		lightComp.CastsShadow = True
		lightComp.Range = 30.0
		light.Transform.Move( 10, 10, 0 )
		light.Transform.PointAt( New Vec3f )
		
		Local bounceLight := New GameObject( "bounceLight" )
		Local bounceLightComp := bounceLight.AddComponent( New LightComponent )
		bounceLightComp.Color = New Float[]( 0, 0.4, 0.75, 1.0 )
		bounceLight.Transform.Move( 0, -10, 0 )
		bounceLight.Transform.Rotate( -90, 0, 0 )
	
		Local wireTex := Texture.Load( "asset::wire.png", "TexWire", TextureFlags.FilterMipmap )
		Local catTex := Texture.Load( "asset::cat.png", "TexCat", TextureFlags.FilterMipmap )
		
		Local mat := New PbrMaterial
		mat.Name = "MatWire"
		mat.ColorTexture = wireTex
		mat.ColorFactor = New Color( 0, 1, 1.5 )
		mat.EmissiveTexture = wireTex
		mat.EmissiveFactor = New Color( 0, 1, 1.5 )

		Local matRed := New PbrMaterial( Color.Red, 0.1, 0.5 )
		matRed.Name = "MatRed"
		matRed.CullMode = CullMode.None
		
		Local matYellow := New PbrMaterial( Color.Yellow, 0.1, 0.5 )
		matYellow.Name = "matYellow"
		
		Local test1 := New GameObject( "test1" )
		test1.AddComponent( New LoadModel( "asset::teapotLow.fbx" ) )
		test1.AddComponent( New LoadMaterial( "MatRed" ) )
		test1.AddComponent( New Spin(0,1,0) )
		test1.AddComponent( New ChangeColor )
		test1.Transform.Move( New Vec3f( 0, 0.5, 0 ) )
		
		Local test2:= New GameObject( "test2" )
		Local donut1 := New DonutModel
		donut1.outerRadius = 0.5
		test2.AddComponent( donut1 )
		test2.AddComponent( New LoadMaterial( "matYellow" ) )
		test2.AddComponent( New Spin(4,0,0) )
		test2.Transform.Move( New Vec3f( 0, 0, -1.0 ) )
		test2.Transform.Scale = New Vec3f( 0.25 )
		test2.Parent = "test1"
		
		Local test3:= New GameObject( "test2" )
		Local donut2 := New DonutModel
		donut2.outerRadius = 0.5
		test3.AddComponent( donut2 )
		test3.AddComponent( New LoadMaterial( "matYellow" ) )
		test3.AddComponent( New Spin(4,0,0) )
		test3.Transform.Move( New Vec3f( 0, 0, 1.0 ) )
		test3.Transform.Scale = New Vec3f( 0.25 )
		test3.Parent = "test1"

		Local gridModel := New Model
		gridModel.Mesh = CreateGrid( 15.0, 15.0, 20, 20, True )
		gridModel.AssignMaterial( "MatWire" )
		gridModel.Rotate( 90,0,0)
				
		Local grid := New GameObject( "grid" )
		grid.SetEntity( gridModel )
		
		Local camera := New GameObject( "camera" )
		Local cam := camera.AddComponent( New CameraComponent )
		cam.Near = 0.1
		cam.Far = 5.0
		cam.FOV = 45
		camera.Transform.Move( 0, 1.5, 3 )
		camera.Transform.PointAt( test1.Transform.Position )
	
'		light.Entity.Visible = False
'		MaterialLibrary.Save( "" )

		Local json := New JsonObject
		For Local g := Eachin GameObject.GetFromScene( Scene )
			json.Serialize( g.Name, g )
		Next
		Print json.ToJson()
		SaveString( json.ToJson(), "/Users/Leo/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/testscene.json" )

	End
End


'************************* test components *************************



