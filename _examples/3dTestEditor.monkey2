
#Import "view/game3dview"
#Import "view/gameDock"
#Import "view/scenetreeview"

#Import "../game3d"
#Import "../util/navigation"
#Import "<mojo>"
#Import "<mojox>"

Using std..
Using mojo..
Using mojox..
Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End


Class TestWindow Extends Window
	Public
	Method New()					
		Super.New( "Test", 1280, 960, WindowFlags.Resizable )
		Local dock := New GameDock
		ContentView = dock
	End
	
	Method OnKeyEvent( event:KeyEvent ) Override
		ContentView.OnKeyEvent( event )
	End
End
































