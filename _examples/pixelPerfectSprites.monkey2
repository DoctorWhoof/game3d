#Import "../game3d"

#Import "scenes/"
#Import "images/"

#Import "components/circle"
#Import "components/sinePosition"
#Import "components/grid2d"
#Import "components/spin"
#Import "components/changecolor"

#Import "../components/geometry/pivot"
#Import "../components/geometry/spriteanim"

Using game3d..
Const devPath := HomeDir() + "/GoogleDrive/Code/Monkey2/game3d/_examples/scenes/"

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
		Super.New( width, height )
		devMode = True
		Layout = "letterbox-int"
	End
	
	Method OnStart() Override
		GameObject.Load( devPath + "pixelPerfect.json" )
	End
	
End

















