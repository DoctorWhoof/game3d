#Import "../game3d"
#Import "components/circle"
#Import "components/sinePosition"
#Import "components/grid2d"
#Import "../components/geometry/pivot"
#Import "../components/geometry/spriteanim"

#Import "scenes/"
#Import "images/"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 960, 540, WindowFlags.Resizable )
		Local view2D := New Game2dView( 320, 180 )
		
		ContentView = view2D
		ClearColor = Color.Black
	End
End


Class Game2dView Extends SceneView

	Method New( width:Int, height:Int )
		Super.New( width, height, False )
		Style.BackgroundColor = New Color( 0.4, 0.4, 0.4 )
		Style.Font = smallFont
		Layout = "letterbox-int"
		devMode = True
	End
	
	Method OnStart() Override
		GameObject.Load( "asset::test2D.json" )
	End
	
End



