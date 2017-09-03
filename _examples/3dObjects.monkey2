
#Import "../game3d"
#Import "components/donutRenderer"
#Import "components/spriteRenderer"
#Import "components/cardRenderer"
#Import "components/spin"

#Import "images/cats.png"
#Import "images/cat.png"
#Import "images/blob.png"
#Import "images/blob.json"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1024, 600, WindowFlags.Resizable )
		ContentView = New GameView( 1280, 720 )
	End
End


Class GameView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height )
		Layout = "fill"
	End

	Method OnStart() Override
		currentScene.ClearColor = Color.Grey
		
		Local test1 := New GameObj( "Donut" )
		test1.AddComponent( New DonutRenderer )
		test1.AddComponent( New Spin )

		Local test2 := New GameObj( "Donut" )
		test2.AddComponent( New DonutRenderer )
		test2.Parent = test1
		
		test2.entity.Position = New Vec3f( 4, 0, 0 )
		test2.entity.Scale = New Vec3f( 0.5, 0.5, 0.5 )
		
		Local test3 := New GameObj( "Sprite" )
		Local spriteComp := New SpriteRenderer( "asset::blob.png", 16, 16, 0, 0, Null )
		spriteComp.sprite.LoadAnimations( "asset::blob.json" )
		spriteComp.sprite.Animation = "WalkRight"
		test3.AddComponent( spriteComp )
		
		
		test3.entity.Position = New Vec3f( -4, 0, 0 )
		test3.entity.Scale = New Vec3f( 2, 2, 2 )
		test3.Parent = test1
		
		Local test4 := New GameObj( "Cat" )
		test4.AddComponent( New CardRenderer( "asset::cats.png", 12, 10, 10, 16, 16, TextureFlags.None ) )
		test4.Parent = test2

		WasdInit( Self )
		camera.Position = New Vec3f( 10, 0, 0 )
		camera.Rotation = New Vec3f( 0, 90, 0 )
	End
	
	Method OnUpdate() Override
		WasdCameraControl( game.camera, Self, Clock.Delta() )
	End
	
End
