#Import "../components/circleRenderer"
#Import "../components/grid2d"

Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
	End
	
	Method OnStart() Override
		Local obj1 := New GameObj( "Test1", CurrentGameScene, Self )
		obj1.AddComponent( New Grid2D )
		obj1.AddComponent( New CircleRenderer )
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