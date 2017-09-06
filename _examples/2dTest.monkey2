
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
		Local view2D := New Game2dView( 320, 180 )
		view2D.displayInfo = True
		view2D.Layout = "letterbox-int"
		
		ContentView = view2D
		ClearColor = Color.Black
	End
End



