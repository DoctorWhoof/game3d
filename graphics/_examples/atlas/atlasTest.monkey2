#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
#Import "../../atlas"
#Import "../../grid"

#Import "cats.png"
#Import "crystalCaves.png"
#Import "crystalCaves.txt"

Using std..
Using mojo..
Using mojo3d..

Function Main()
	New AppInstance
	New Test
	App.Run()
End

Class Test Extends Window
	Field scene:Scene
	Field mainCam:Camera
	Field keyLight:Light

	Method New()
		Super.New( "Test", 800, 450, WindowFlags.Resizable )
		
		'Scene
		scene = Scene.GetCurrent()
		scene.ClearColor = Color.Black
   		scene.AmbientLight = Color.White
		
		'Since we're using a PBR material (for now), let's make the environment black.
		Local blackEnv:= New Pixmap( 4,3 )
		blackEnv.Clear( Color.Black )
		scene.EnvTexture = New Texture( blackEnv, TextureFlags.Cubemap )
		
		'Camera
		mainCam = New Camera
		mainCam.Move( 0, -30, -12 )
		mainCam.Rotate( -45, 0, 0 )
		mainCam.Fov = 60
		
		'Load image atlas for the tilemap
		Local tileSheet:= New Atlas( "asset::crystalCaves.png", 32, 32, 0, 0, TextureFlags.None )
		
		'3d tilemap generated from the Atlas
		Local mapmesh:= LoadTileMap( "asset::crystalCaves.txt", tileSheet.Coords, 2.5, 2.5 )
		Local mapmat:=  New PbrMaterial( True, False, False )
		mapmat.RoughnessFactor = 1.0
		mapmat.MetalnessFactor = 0.0
		mapmat.ColorTexture = tileSheet.Texture
		Local tileMapObj:= New Model( mapmesh, mapmat )

		'Load image atlas for the cat sprites
		Local catSheet:= New Atlas( "asset::cats.png", 16, 16, 0, 0, TextureFlags.None )
		
		'Cats!
		Local area := New Rectf( -30, -30, 25, 25 )
		For Local n := 1 To 100
			Local catMesh:= CreateSprite( Rnd(0,16), tileSheet.Coords, 2.0, 2.0 )
			Local catmat:=  New PbrMaterial( True, False, False )
			catmat.ColorTexture = catSheet.Texture
			Local catObj:= New Model( catMesh, catmat )
			catObj.Position = New Vec3f( Rnd( area.Left, area.Right), Rnd( area.Top, area.Bottom ), -1 )
			catObj.Rotation = New Vec3f( -60, 0, 0 )
		Next
	End

	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		scene.Render( canvas, mainCam )
		mainCam.Y += 0.1
		If mainCam.Y > 20 Then  mainCam.Y = -40
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
	End
End



'		'Cats! Single mesh attempt.
'		Local area := New Rectf( -30, -30, 25, 25 )
'		Local catMesh := New Mesh
'		For Local n := 1 To 100
'			Local x := Rnd( area.Left, area.Right )
'			Local y := Rnd( area.Top, area.Bottom )
'			Local matrix := New AffineMat4f
'			matrix.Translate( x, y, -1 )
'			Local tempMesh := catSheet.CreateSprite( Rnd(0,16), 2.0, 2.0 )
'			tempMesh.TransformVertices( matrix )
''			tempMesh.UpdateTangents()
'			catMesh.AddMesh( tempMesh )
''			catMesh.UpdateTangents()
'		Next
'		Local catmat:=  New PbrMaterial( Color.White )
'		catmat.ColorTexture = catSheet.texture
'		Local catObj:= New Model( catMesh, catmat )
'
