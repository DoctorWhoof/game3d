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
	
	Print Typeof( New Color( 1,1,0,1 ) )
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )
		
		Local gameView := New GameView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.displayInfo = True
		gameView.Camera.Move( 0, 1.2, -2 )
		gameView.Camera.PointAt( New Vec3f )
		
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
		Scene.EnvTexture = Texture.Load( "asset::black.png", Null )
		
		Local  fog := New FogEffect( Color.Black, 0, 12 )
		Scene.AddPostEffect( fog )

		Local wireTex := Texture.Load( "asset::wire.png", "TexWire", TextureFlags.FilterMipmap )
		Local catTex := Texture.Load( "asset::cat.png", "TexCat", TextureFlags.FilterMipmap )

		Local mat := New PbrMaterial( True, False, False )
		mat.Name = "MatWire"
		mat.ColorTexture = wireTex
		mat.ColorFactor = New Color( 0, 1, 1.5 )
		mat.EmissiveTexture = wireTex
		mat.EmissiveFactor = New Color( 0, 1, 1.5 )
		
		Local test1 := New Model
		test1.Name = "Test1"
		test1.Move( New Vec3f( 0, 0.5, 0 ) )
		test1.AddComponent( New LoadModel( "asset::teapotLow.fbx" ) )
		test1.AssignMaterial( "MatWire" )
'		test1.AddComponent( New LoadPbrMaterial( Color.Red, 0.1, 0.5, New Color(5,0,0), "asset::wire.png", "asset::wire.png") )
		test1.AddComponent( New Spin(0,1,0) )
		test1.AddComponent( New ChangeColor )

		Local grid := New Model
		grid.Name = "grid"
		grid.AssignMaterial( "MatWire" )
'		grid.AddComponent( New LoadPbrMaterial( Color.Blue, 0.1, 0.5, New Color(0,0.5,1.5), "asset::wire.png", "asset::wire.png") )
'		grid.Materials = New Material[]( mat )
		grid.Mesh = CreateGrid( 30.0, 30.0, 20, 20, True )
		grid.Rotate( 90,0,0)
		
		Local test2 := Model.CreateTorus( 1.1, .05, 48, 32, New PbrMaterial( Color.Orange, 0.1, 0.5 ) )
		test2.Name = "Test2"
		test2.Parent = test1
'		test2.Move( 0, 1, 0 )
		test2.AddComponent( New Spin(0,0,5) )
		test2.AddComponent( New Spin(0,0,5) )
		test2.AddComponent( New ChangeColor )

		KeyLight.Visible = False
		
		For Local c := Eachin test1.Components
			c.List()
		Next
		
		MaterialLibrary.Save( "" )
	End
End


'************************* test components *************************


Class ChangeColor Extends Component
	Method New()
		Super.New( "Bounce" )
	End

	Method OnUpdate() Override
		If Keyboard.KeyHit( Key.Space )
			Cast<Model>(Entity).Material = New PbrMaterial( New Color( Rnd(), Rnd(), Rnd() ), 0.1, 0.5 )
		End
	End
End
