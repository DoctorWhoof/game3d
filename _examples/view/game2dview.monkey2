#Import "../components/circleRenderer"
#Import "../components/sinePosition"
#Import "../components/grid2d"

Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		render3DScene = False
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
	End
	
	Method OnStart() Override
		Local obj1 := New Entity	'Look Ma! No 3d renderer! :-)
		obj1.AddComponent( New Grid2D )
		obj1.AddComponent( New CircleRenderer( 20 ) )
		obj1.AddComponent( New SinePosition( 0.5, 20, 20, 0 ) )
	End
	
	
	Method OnUpdate() Override
		If Keyboard.KeyDown( Key.Left )
			Camera2D.X -= 1
		Elseif Keyboard.KeyDown( Key.Right )
			Camera2D.X += 1
		End
		If Keyboard.KeyDown( Key.Up )
			Camera2D.Y -= 1
		Elseif Keyboard.KeyDown( Key.Down )
			Camera2D.Y += 1
		End
	End
	
End