#Import "../game3d"

#Import "scenes/"
#Import "images/"

#Import "components/circle"
#Import "components/sinePosition"
#Import "components/grid2d"
#Import "components/spin"
#Import "components/changecolor"

#Import "../components/geometry/pivot"
#Import "../components/geometry/spriteanim"

'#Import "../../graphics/animsprite"
'#Import "../components/old/spriteManager"

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
		Layout = "letterbox-int"
	End
	
	Method OnStart() Override
		
		Scene.ClearColor = Color.DarkGrey
		
		Local camDistance := PixelPerfectDistance( 45, 180 )
	
		'-----------------------------------------------------------------
		
		Local camera := New GameObject
		camera.Name = "camera"
	
		Local cam := New CameraComponent
		cam.Near = 0.1
		cam.Far = 1000.0
		cam.FOV = 45
		cam.FogColor = New Double[]( 0.0, 0.0, 0.0, 0.0 )
		cam.EnvColor = New Double[]( 0, 0, 0, 1 )
		cam.ClearColor = New Double[]( 0.3, 0.3, 0.3, 1 )
		cam.AmbientLight = New Double[]( 1, 1, 1, 1 )
		camera.AddComponent( cam )
		
		camera.Transform.Move( 0, 0, -camDistance )
		
		'-----------------------------------------------------------------
		
		Local checkerboard := New GameObject
		checkerboard.Name = "checkerboard"
		
		Local checkerSprite := New SpriteAnim
		checkerSprite.path = "asset::checkerboard.png"
		checkerSprite.cellWidth = 320
		checkerSprite.cellHeight = 180
		checkerboard.AddComponent( checkerSprite )
		
		checkerboard.Entity.Position = New Vec3f( 0, 0, camDistance )
		checkerboard.Entity.Scale = New Vec3f( 640, 360, 1 )
		
		'-----------------------------------------------------------------
		
		Local obj2D := New GameObject
		obj2D.Name = "Object2D"
		
		Local sprite := New SpriteAnim
		sprite.path = "asset::blob.png"
		sprite.animationPath = "asset::blob.json"
		sprite.defaultAnimation = "WalkRight"
		sprite.cellWidth = 16
		sprite.cellHeight = 16
		obj2D.AddComponent( sprite )
		
		Local sine := obj2D.AddComponent( New SinePosition )
		sine.x = 16
		sine.y = 16
		sine.period = 0.5
		
		obj2D.Entity.Scale = New Vec3f( 16, 16, 1 )
		
		'-----------------------------------------------------------------
		
		GameObject.Save( Scene, devPath + "pixelPerfect.json" )
		
	End
	
End


Function PixelPerfectDistance:Double( vertFOV:Double, vertResolution:Double )
	Local degToRad :Double = Pi / 180.0
	Local s := vertResolution/2.0
	Local a := (vertFOV/2.0) * degToRad
	Local h := s / Sin(a)
	Local d := Sqrt( (h*h) - (s*s) )
	Return d
End
















