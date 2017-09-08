
#Import "../components/card"
#Import "../components/spin"
#Import "../components/spriteRenderer"
#Import "../components/donutRenderer"
#Import "../../graphics/animsprite"

#Import "../images/cats.png"
#Import "../images/cat.png"
#Import "../images/blob.png"
#Import "../images/blob.json"

Class Game3dView Extends SceneView
	
	Field wasdControls :Bool
	Field pivot:Entity
	
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Scene.ClearColor = New Color( 0.1, 0.1, 0.1 )
		
		'traditional mojo3d model creation
		Local test1 := Model.CreateTorus( 2, .5, 48, 24, New PbrMaterial( Color.Red, 0.1, 0.5 ) )
		test1.Name = "Test2"
		test1.AddComponent( New Spin( 0, 1, 0 ) )

		'component based model creation - the component only "runs" at the start
		Local test2 := New Model
		test2.Name = "Test2"
		test2.Parent = test1
		test2.Position = New Vec3f( 4, 0, 0 )
		test2.AddComponent( New Spin( 3, 0 ,0 ) )
		test2.AddComponent( New DonutRenderer( 1, 0.25 ) )
'		
		'I may move a lot of the AnimSprite functionality into the SpriteRenderer component, and use regular Sprites instead
		Local test3 := New AnimSprite( "asset::blob.png", 16, 16, 0, 0, Null  )
		test3.LoadAnimations( "asset::blob.json" )
		test3.Animation = "WalkRight"
		test3.Name = "Test3"
		test3.Position = New Vec3f( -4, 0, 0 )
		test3.Scale = New Vec3f( 2, 2, 2 )
		test3.Parent = test1
		test3.AddComponent( New SpriteRenderer )	'currently does nothing but calling "Update(time)" on AnimSprite on every frame
		
		'Another model creation component
		Local test4 := New Model
		test4.Name = "CatCard"
		test4.Position = New Vec3f( 4, 0, 0 )
		test4.Parent = test1
		test4.AddComponent( New Card( "asset::cats.png", 12, 2, 2, 16, 16, TextureFlags.None ) )

		Camera.Move( 0, 2, -10 )
		Camera.PointAt( New Vec3f )

		pivot = Model.CreateSphere( 1, 12, 12, New PbrMaterial( Color.Red ) )
		pivot.Name = "Pivot"
		pivot.LocalRotation = Camera.LocalRotation
		
		Local zeroOut := New Entity
		zeroOut.Position = Camera.Position
		zeroOut.Rotation = Camera.Rotation
		
		Camera.Parent = pivot
		Camera.Position = zeroOut.Position
		Camera.Rotation = zeroOut.Rotation
	End
	
	Method OnDraw( canvas:Canvas ) Override
		Echo( Camera.Rotation )
	End
	
	Method OnMouseEvent( event:MouseEvent ) Override
		If editMode
			Navigate3D( Self, event, pivot )
		End
	End
	
End