#Import "../components/donutRenderer"
#Import "../components/spriteRenderer"
#Import "../components/cardRenderer"
#Import "../components/spin"

#Import "../images/cats.png"
#Import "../images/cat.png"
#Import "../images/blob.png"
#Import "../images/blob.json"

Class Game3dView Extends SceneView
	
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Current3DScene.ClearColor = New Color( 0.1, 0.1, 0.1 )
		
		Local test1 := New GameObj( "Donut", CurrentGameScene, Self )
		test1.AddComponent( New DonutRenderer )
		test1.AddComponent( New Spin(0,1,0) )

		Local test2 := New GameObj( "Donut", CurrentGameScene, Self )
		test2.AddComponent( New DonutRenderer )
		test2.Parent = test1
		test2.AddComponent( New Spin(1,0,0) )
		
		test2.Entity.Position = New Vec3f( 4, 0, 0 )
		test2.Entity.Scale = New Vec3f( 0.75, 0.75, 0.75 )

		Local spriteComp := New SpriteRenderer( "asset::blob.png", 16, 16, 0, 0, Null )
		spriteComp.sprite.LoadAnimations( "asset::blob.json" )
		spriteComp.sprite.Animation = "WalkRight"
		
		Local test3 := New GameObj( "Sprite", CurrentGameScene, Self )
		test3.AddComponent( spriteComp )
		test3.Entity.Position = New Vec3f( -4, 0, 0 )
		test3.Entity.Scale = New Vec3f( 2, 2, 2 )
		test3.Parent = test1
		
		Local test4 := New GameObj( "Cat", CurrentGameScene, Self )
		test4.AddComponent( New CardRenderer( "asset::cats.png", 12, 2, 2, 16, 16, TextureFlags.None ) )
		test4.Entity.Position = New Vec3f( 4, 0, 0 )
		test4.Parent = test1

'		WasdInit( Self )
		Local pivot := New Entity
		Camera.Parent = pivot
	End
	
	Method OnUpdate() Override
'		WasdCameraControl( camera, Self, Clock.Delta() )
	End
	
End