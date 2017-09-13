#Import "../game3d"
#Import "<mojo3d-physics>"
#Import "../util/navigation"
#Import "components/spin"

#Import "models/asteroidLow.obj"
#Import "images/stars.png"

Using game3d..
Using mojo3d.physics

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	
	Field gameView:GameView
	
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable | WindowFlags.Maximized )
		gameView = New GameView( 1280, 720 )
		ContentView = gameView
		ClearColor = Color.Black
'		WasdInit( gameView )
	End
	
	Method OnRender( canvas:Canvas ) Override
		WasdCameraControl( gameView.Camera, gameView, Clock.Delta() )	
	End
End

Class GameView Extends SceneView
	
	Field asteroid:Model
	Field asteroidVertices:Vertex3f[]
	Field world:World
	
	Method New( width:Int, height:Int )
		Super.New( width, height, True )
	End	
	
	Method OnStart() Override
		Layout = "fill"
		displayInfo = True
		
'		asteroid = Model.Load( "asset::asteroidLow.obj" )
		asteroid = Model.CreateBox( New Boxf( -1,-1,-1,1,1,1 ), 1, 1, 1, New PbrMaterial( Color.Orange, 0, 1.0 )  )
		Print assimp.aiGetErrorString()
		asteroid.Material = New PbrMaterial( Color.Orange, 0, 1.0 )
		asteroid.AddComponent( New Spin( Rnd(0,0.1), Rnd(0,0.2), Rnd(0,0.1) ) )
'		asteroid.Mesh.FitVertices( New Boxf(-10,-10,-10,10,10,10) )
'		asteroid.Visible = False

		Camera.Move( 0, 0, -5 )
		Camera.Near = 1.0
		Camera.Far = 100.0
		
		world = New World( Scene )
		Local collider := New MeshCollider( asteroid.Mesh )
		Local body := New DynamicBody( collider, asteroid )
		New KinematicBody( New SphereCollider( 2 ), Camera )
		
		world.Gravity = New Vec3f( 0,0,0 )
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		If Keyboard.KeyDown( Key.Right )
			Camera.Ry -= 1.0
		Else If Keyboard.KeyDown( Key.Left )
			Camera.Ry += 1.0
		End
		
		If Keyboard.KeyDown( Key.Up )
			Camera.Rx -= 1.0
		Else If Keyboard.KeyDown( Key.Down )
			Camera.Rx += 1.0
		End
		
		Local v1 := New Vec3f(0,-1,0)
		Local v2 := New Vec3f(0,1,0)
		DrawWireframe( canvas, Camera, asteroid, Width/2.0, Height/2.0 )
	End
	
	
	Method Draw3DLine( canvas:Canvas, camera:Camera, v0:Vec3f, v1:Vec3f, offsetX:Float=0, offsetY:Float=0  )		
		Local s0 := camera.ProjectToView( v0 )
		Local s1 := camera.ProjectToView( v1 )
		canvas.DrawLine( s0.X-offsetX, -s0.Y+offsetY, s1.X-offsetX, -s1.Y+offsetY )
	End
	
	
	Method DrawWireframe( canvas:Canvas, camera:Camera, model:Model, offsetX:Float=0, offsetY:Float=0)
		Local vertices := model.Mesh.GetVertices()
		Local indices := model.Mesh.GetAllIndices()
		Local matrix := model.Matrix
		For Local n := 0 Until indices.Length - 1 Step 3
			Local v0 := matrix * vertices[indices[n]].position
			Local v1 := matrix * vertices[indices[n+1]].position
			Local v2 := matrix * vertices[indices[n+2]].position
			
			Local ray0 := world.RayCast( camera.Position, vertices[indices[n]].position )
			Local ray1 := world.RayCast( camera.Position, vertices[indices[n+1]].position )
			Local ray2 := world.RayCast( camera.Position, vertices[indices[n+2]].position )
			
			If ray0 Then Echo ("hit")
			
'			Local forward := camera.Basis * New Vec3f( 0, 0, 1.0 )
'			Local dot0 := forward.Dot( vertices[indices[n]].normal )
'			Local dot1 := forward.Dot( vertices[indices[n+1]].normal )
'			Local dot2 := forward.Dot( vertices[indices[n+1]].normal )
'			Echo( Truncate(forward) )
'			If dot0 > 0 And dot1 > 0 And dot2 > 0
			If( ray0 = Null ) And ( ray1 = Null ) Then Draw3DLine( canvas, camera, v0, v1, offsetX, offsetY )
			If( ray1 = Null ) And ( ray2 = Null ) Then Draw3DLine( canvas, camera, v1, v2, offsetX, offsetY )
			If( ray2 = Null ) And ( ray0 = Null ) Then Draw3DLine( canvas, camera, v2, v0, offsetX, offsetY )
'			End
		Next
	End
	
End


Class Camera Extension
	
	Method ProjectToView:Vec2f( worldVertex:Vec3f )
 		Local clip_coords:=ProjectionMatrix * InverseMatrix * New Vec4f( worldVertex,1.0 )
		Local ndc_coords:=clip_coords.XY/clip_coords.w
		Local vp_coords:=Cast<Vec2f>( Viewport.Size ) * (ndc_coords * 0.5 + 0.5)
		Return vp_coords
	End
	
End

















