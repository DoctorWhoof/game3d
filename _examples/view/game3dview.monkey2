Class Game3dView Extends SceneView
	
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		CurrentScene.ClearColor = New Color( 0.1, 0.1, 0.1 )
		
		Local test1 := New GameObj( "Donut", Self )
		test1.AddComponent( New DonutRenderer )
		test1.AddComponent( New Spin )

		Local test2 := New GameObj( "Donut", Self )
		test2.AddComponent( New DonutRenderer )
		test2.Parent = test1
		
		test2.entity.Position = New Vec3f( 4, 0, 0 )
		test2.entity.Scale = New Vec3f( 0.5, 0.5, 0.5 )

		Local spriteComp := New SpriteRenderer( "asset::blob.png", 16, 16, 0, 0, Null )
		spriteComp.sprite.LoadAnimations( "asset::blob.json" )
		spriteComp.sprite.Animation = "WalkRight"
		
		Local test3 := New GameObj( "Sprite", Self )
		test3.AddComponent( spriteComp )
		test3.entity.Position = New Vec3f( -4, 0, 0 )
		test3.entity.Scale = New Vec3f( 2, 2, 2 )
		test3.Parent = test1
		
		Local test4 := New GameObj( "Cat", Self )
		test4.AddComponent( New CardRenderer( "asset::cats.png", 12, 10, 10, 16, 16, TextureFlags.None ) )
		test4.Parent = test2

'		WasdInit( Self )
'		Camera.Position = New Vec3f( 10, 0, 0 )
'		Camera.Rotation = New Vec3f( 0, 90, 0 )
		
		Local pivot := New Entity
		Camera.Parent = pivot
		
	End
	
	Method OnUpdate() Override
'		WasdCameraControl( camera, Self, Clock.Delta() )
	End
	
End