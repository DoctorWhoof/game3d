#Import "../../game3d"

#Import "../scenes/"
#Import "../images/"

#Import "../components/circle"
#Import "../components/sinePosition"
#Import "../components/grid2d"
#Import "../../components/geometry/pivot"
#Import "../../components/geometry/spriteanim"

#Import "../components/spin"
#Import "../components/changecolor"

Using game3d..

Const devPath := HomeDir() + "/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/"

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 960, 540, WindowFlags.Resizable )
		Local view2D := New Game2dView( 320, 180 )
		
		ContentView = view2D
		ClearColor = Color.Black
	End
End


Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height )
		devMode = True
	End
	
	Method OnStart() Override
		
'		Scene.ClearColor = Color.DarkGrey
		
		Local camera := New GameObject
		camera.Name = "camera"
	
		Local cam := New CameraComponent
		cam.Near = 0.1
		cam.Far = 150.0
		cam.FOV = 45
		cam.FogColor = New Double[]( 0.3, 0.3, 0.3, 1 )
		cam.EnvColor = New Double[]( 0, 0, 0, 1 )
		cam.ClearColor = New Double[]( 0.3, 0.3, 0.3, 1 )
		cam.AmbientLight = New Double[]( 1, 1, 1, 1 )
		camera.AddComponent( cam )
		
		camera.Transform.Move( 0, 0, -5 )
		camera.Transform.PointAt( New Vec3f )
		
		'-----------------------------------------------------------------
		
		Local obj2D := New GameObject
		obj2D.Name = "Object2D"
		
		Local sprite := New SpriteAnim
		sprite.path = "asset::blob.png"
		sprite.animationPath = "asset::blob.json"
		sprite.cellWidth = 16
		sprite.cellHeight = 16
		
		obj2D.AddComponent( sprite )
		sprite.Animation = "WalkRight"
		
'		Local sine := obj2D.AddComponent( New SinePosition )
'		sine.x = 20
'		sine.y = 20
'		sine.period = 0.5
		
		'-----------------------------------------------------------------
		
		Local light := New GameObject
		light.Name = "light"
		
		Local lightComp := light.AddComponent( New LightComponent )
		lightComp.CastsShadow = True
'		lightComp.Range = 30.0
		
		light.Transform.Move( 10, 10, 0 )
		light.Transform.PointAt( New Vec3f )
		
		'-----------------------------------------------------------------
		
		Local donut1:= New GameObject
		donut1.Name = "donut1"

		Local donutComp1 := New DonutModel
		donutComp1.outerRadius = 0.5
		donut1.AddComponent( donutComp1 )
		
		Local donut1Spin := New Spin
		donut1Spin.x = 4.0
		donut1.AddComponent( donut1Spin )
		
		'-----------------------------------------------------------------
		
		GameObject.Save( Scene, devPath + "test2D_extra.json" )
		
	End
	
End