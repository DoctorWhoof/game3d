#Import "../components/circle"
#Import "../components/sinePosition"
#Import "../components/grid2d"
#Import "../../components/geometry/pivot"

Const devPath := HomeDir() + "/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/"

Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		render3DScene = False
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
	End
	
	Method OnStart() Override
		Local obj2D := New GameObject
		obj2D.Name = "Object2D"
		
		Local pivot := obj2D.AddComponent( New Pivot )
		
		Local grid := obj2D.AddComponent( New Grid2D )
		
		Local circle := obj2D.AddComponent( New Circle )
		circle.radius = 20.0
		
		Local sine := obj2D.AddComponent( New SinePosition )
		sine.x = 20
		sine.y = 20
		sine.period = 0.5
		
		GameObject.Save( Scene, devPath + "test2D.json" )
		
	End
	
End