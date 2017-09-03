
#Import "../game3d"
#Import "view/game2dview"

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
		Super.New( "Test", 960, 540, WindowFlags.Resizable )
		ContentView = New Game2DView( 320, 180 )
		ClearColor = New Color( 0.4, 0.4, 0.4 )
	End
End



