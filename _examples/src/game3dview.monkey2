
#Import "../components/old/card"
#Import "../components/spin"
#Import "../components/old/spriteManager"
#Import "../components/old/donut"
#Import "../../graphics/animsprite"

#Import "../images/"
#Import "../../game3d"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

'************************************************************************************************************

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 960, 540, WindowFlags.Resizable )
		Local view3D := New Game3dView( 320, 180 )
		
		ContentView = view3D
		ClearColor = Color.Black
	End
End

'************************************************************************************************************

Class Game3dView Extends SceneView
	
	Field pivot:Entity
	
	Method New( width:Int, height:Int )
		Super.New( width, height, True )
	End

	Method OnStart() Override
		Scene.ClearColor = New Color( 0.1, 0.1, 0.1 )
		
		Camera = New Camera
		Local camObj := New GameObject
		camObj.SetEntity( Camera )
		Camera.SetPosition( 0, 0, -5 )
		
		'traditional mojo3d model creation... but with components!
'		Local test1 := Model.CreateTorus( 2, .5, 48, 24, New PbrMaterial( Color.Red, 0.1, 0.5 ) )
'		test1.Name = "Test2"
'		
'		Local spin := test1.AddComponent( New Spin )
'		spin.y = 1.0
		
		'component based model creation - the component only "runs" at the start
'		Local test2 := New Model
'		test2.Name = "Test2"
'		test2.Parent = test1
'		test2.Position = New Vec3f( 4, 0, 0 )
'		test2.AddComponent( New Spin( 3, 0 ,0 ) )
'		test2.AddComponent( New Donut( 1, 0.25 ) )
		
		'I may move a lot of the AnimSprite functionality into the SpriteRenderer component, and use regular Sprites instead
		Local test3 := New AnimSprite( "asset::blob.png", 16, 16, 0, 0, Null  )
		test3.LoadAnimations( "asset::blob.json" )
		test3.Animation = "WalkRight"
		test3.Name = "Test3"
		test3.Position = New Vec3f( -4, 0, 0 )
		test3.Scale = New Vec3f( 2, 2, 2 )
'		test3.Parent = test1

		Local  obj3 := New GameObject
		obj3.SetEntity( test3 )
		obj3.AddComponent( New SpriteManager )	'currently does nothing but calling "Update(time)" on AnimSprite on every frame
		
		'Another model creation component
		Local test4 := New Model
		test4.Name = "CatCard"
		test4.Position = New Vec3f( 0, 0, 0 )
		
		Local obj4 := New GameObject
		obj4.SetEntity( test4 )

		'You can store a component in a variable when creating it, AddComponent returns the new component.	
'		Local card:= test4.AddComponent( New Card( "asset::cats.png", 12, 2, 2, 16, 16, TextureFlags.None ) )
'		Print( card.Name )
'		Print( card.alignToCamera )

		'Camera pivot is used in editMode for "Alt Key Navigation" (orbit, track and dolly)
		If editMode
			pivot = New Entity
			pivot.Name = "Pivot"
			pivot.LocalRotation = Camera.LocalRotation
			Camera.SwitchParent( pivot )
		End
	End
	
	Method OnUpdate() Override
'		Echo( Camera.Rotation )
	End
	
	Method OnDraw( canvas:Canvas ) Override
		If editMode
			Local gridSpacing := 1.0
			Local gridSize := 20.0
			Local offsetX := Width / 2.0
			Local offsetY := Height / 2.0
			Local gridHalf := gridSize / 2.0

			For Local x := -gridSize/2.0 To gridSize/2.0 Step gridSpacing
				canvas.Draw3DLine( Camera, New Vec3f( x,0,-gridHalf ), New Vec3f( x,0,gridHalf ), offsetX, offsetY )
			Next
			
			For Local z := -gridSize/2.0 To gridSize/2.0 Step gridSpacing
				canvas.Draw3DLine( Camera, New Vec3f( -gridHalf,0,z ), New Vec3f( gridHalf,0,z ), offsetX, offsetY )
			Next
			Echo( Camera.Viewport )
		End	
	End
	
	Method OnMouseEvent( event:MouseEvent ) Override
		If editMode
			Navigate3D( Self, event, pivot )
		End
	End
	
End