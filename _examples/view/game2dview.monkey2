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
	
End