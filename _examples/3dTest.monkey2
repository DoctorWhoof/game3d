
#Import "../game3d"
#Import "view/game3dview"
#Import "../util/navigation"

#Import "components/spriteRenderer"
#Import "components/donutRenderer"
#Import "components/cardRenderer"
#Import "components/spin"

#Import "images/cats.png"
#Import "images/cat.png"
#Import "images/blob.png"
#Import "images/blob.json"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	
	Field gameView:Game3dView
	
	Method New()
		Super.New( "Test", 1024, 600, WindowFlags.Resizable | WindowFlags.Maximized )
		gameView = New Game3dView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.displayInfo = True
		gameView.Camera.Move( 0, 5, -10 )
		gameView.Camera.PointAt( New Vec3f )
		gameView.wasdControls = True
		
		ContentView = gameView
		ClearColor = Color.Black
		WasdInit( gameView )
	End
	
	Method OnRender( canvas:Canvas ) Override
		WasdCameraControl( gameView.Camera, gameView, Clock.Delta() )	
	End
	
End


