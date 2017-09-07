
#Import "../game3d"
#Import "view/game3dview"

#Import "components/donutRenderer"
#Import "components/spriteRenderer"
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
	Method New()
		Super.New( "Test", 1024, 600, WindowFlags.Resizable )
		Local gameView := New Game3dView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.Camera.Move( 0, 5, -10 )
		gameView.Camera.PointAt( New Vec3f )
		
		ContentView = gameView
		ClearColor = Color.Black
	End
End


