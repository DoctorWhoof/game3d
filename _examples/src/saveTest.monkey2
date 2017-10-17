#Import "../../game3d"
#Import "../components/spin"
#Import "../components/changecolor"

#Import "../images/"
#Import "../models/"

Using game3d..

Const devPath := HomeDir() + "/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/"

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

		Local wireTex := Texture.Create( "TexWire", "asset::wireGlow.png", TextureFlags.FilterMipmap )
		Local catTex := Texture.Create( "TexCat", "asset::cat.png", TextureFlags.FilterMipmap )
		
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
		matYellow.Name = "MatYellow"
		
		'-----------------------------------------------------------------
		
		Local camera := New GameObject
		camera.Name = "camera"
	
		Local cam := New CameraComponent
		cam.Near = 0.1
		cam.Far = 15.0
		cam.FOV = 45
		cam.FogColor = New Double[]( 0, 0, 0, 1 )
		cam.EnvColor = New Double[]( 0, 0, 0, 1 )
		cam.ClearColor = New Double[]( 0, 0, 0, 1 )
		cam.AmbientLight = New Double[]( 0, 0, 0, 1 )
		camera.AddComponent( cam )
		
		camera.Transform.Move( 0, 1.5, 3 )
		camera.Transform.PointAt( New Vec3f( 0, 0.5, 0 ) )
		
		'-----------------------------------------------------------------
		
		Local light := New GameObject
		light.Name = "light"
		
		Local lightComp := light.AddComponent( New LightComponent )
		lightComp.CastsShadow = True
		lightComp.Range = 30.0
		
		light.Transform.Move( 10, 10, 0 )
		light.Transform.PointAt( New Vec3f )
		
		'-----------------------------------------------------------------
		
		Local bounceLight := New GameObject
		bounceLight.Name = "bounceLight"
		
		Local bounceLightComp := New LightComponent
		bounceLightComp.Color = New Double[]( 0, 0.8, 1.5, 2.0 )
		bounceLightComp.CastsShadow = True
		bounceLight.AddComponent( bounceLightComp )
		
		bounceLight.Transform.Move( 0, -10, 0 )
		bounceLight.Transform.Rotate( -90, 0, 0 )
		
		'-----------------------------------------------------------------
		
		Local teapot := New GameObject
		teapot.Name = "teapot"
		
		Local teapotModel := New LoadModel
		teapotModel.path = "asset::teapotLow.fbx" 
		teapot.AddComponent( teapotModel )
		
		Local teapotMat := New AssignMaterial
		teapotMat.material = "MatRed"
		teapot.AddComponent( teapotMat )
		
		Local teapotSpin := New Spin
		teapotSpin.y = 1.0
		teapot.AddComponent( teapotSpin )
		
		teapot.AddComponent( New ChangeColor )
		
		teapot.Transform.Move( New Vec3f( 0, 0.5, 0 ) )
		
		'-----------------------------------------------------------------
		
		Local donut1:= New GameObject
		donut1.Name = "donut1"

		Local donutComp1 := New DonutModel
		donutComp1.outerRadius = 0.5
		donut1.AddComponent( donutComp1 )

		Local donut1Mat := New AssignMaterial
		donut1Mat.material = "MatYellow"
		donut1.AddComponent( donut1Mat )
		
		Local donut1Spin := New Spin
		donut1Spin.x = 4.0
		donut1.AddComponent( donut1Spin )
		
		donut1.Parent = "teapot"
		donut1.Transform.Move( New Vec3f( 0, 0, -1.0 ) )
		donut1.Transform.Scale = New Vec3f( 0.25 )
	
		'-----------------------------------------------------------------
		
		Local donut2:= New GameObject
		donut2.Name = "donut2"
		
		Local donut2Comp := New DonutModel
		donut2Comp.outerRadius = 0.5
		donut2.AddComponent( donut2Comp )

		Local donut2Mat := New AssignMaterial
		donut2Mat.material = "MatYellow"
		donut2.AddComponent( donut2Mat )
		
		Local donut2Spin := New Spin
		donut2Spin.x = 4.0
		donut2.AddComponent( donut2Spin )
		
		donut2.Parent = "teapot"
		donut2.Transform.Move( New Vec3f( 0, 0, 1.0 ) )
		donut2.Transform.Scale = New Vec3f( 0.25 )
		
		'-----------------------------------------------------------------
				
		Local grid := New GameObject
		grid.Name = "grid"
		
		Local gridModel := New GridModel
		gridModel.width = 40
		gridModel.height = 40
		gridModel.rows = 20
		gridModel.collumns = 20
		grid.AddComponent( gridModel )
		
		Local gridMat := New AssignMaterial
		gridMat.material = "MatWire"
		grid.AddComponent( gridMat )
		
		grid.Transform.Rotate( 90,0,0)
		
		'-----------------------------------------------------------------
	
		light.Visible = False
		
		Local json := New JsonObject
		For Local g := Eachin GameObject.GetFromScene( Scene )
			json.Serialize( g.Name, g )
		Next

		Print json.ToJson()
		SaveString( json.ToJson(), devPath + "testScene.json" )
		Print Texture.Save( devPath + "testTextures.json" ).ToJson()
		Print Material.Save( devPath + "testMaterials.json" ).ToJson()

	End

End
