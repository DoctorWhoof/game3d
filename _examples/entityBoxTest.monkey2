
#Import "../game3d"

Using game3d..

Function Main()
	New AppInstance
	New TestWindow
	App.Run()
End

Class TestWindow Extends Window
	Method New()
		Super.New( "Test", 1280, 720, WindowFlags.Resizable )
		
		Local gameView := New GameView( 1280, 720, True )
		gameView.Layout = "letterbox"
		gameView.displayInfo = True
		gameView.Camera.Move( 0, 3, -6 )
		gameView.Camera.PointAt( New Vec3f )
		
		ContentView = gameView
		ClearColor = Color.Black
	End
End

Class GameView Extends SceneView
	Method New( width:Int, height:Int, enable3D:Bool )
		Super.New( width, height, enable3D )
	End

	Method OnStart() Override
		Scene.ClearColor = New Color( 0.1, 0.1, 0.1 )
		
		Local test1 := Model.CreateTorus( 2, .5, 48, 24, New PbrMaterial( Color.Lime, 0.1, 0.5 ) )
		test1.Name = "Test1"
		test1.AddComponent( New HUD )
		test1.AddComponent( New Spin(1,0,0) )
		test1.AddComponent( New ChangeColor )
		
		Local test2 := Model.CreateTorus( 1, .25, 48, 24, New PbrMaterial( Color.Orange, 0.1, 0.5 ) )
		test2.Name = "Test2"
		test2.Parent = test1
		test2.Move( 0, 2, 0 )
		test2.AddComponent( New Spin(0,0,5) )
		test2.AddComponent( New Spin(0,0,5) )
		test2.AddComponent( New ChangeColor )
	End
End


'************************* test components *************************


Class HUD Extends Component
	Field style:= New Style
	
	Method New()
		Super.New( "HUD" )
		style.Font = Font.Load( "font::DejaVuSans.ttf", 24 )
		style.TextColor = Color.Orange
	End
	
	Method OnDraw( canvas:Canvas ) Override
		style.DrawText( canvas, Entity.Name + ": Hit spacebar to change color!", 20, 20 )
	End
End


Class ChangeColor Extends Component
	Method New()
		Super.New( "Bounce" )
	End

	Method OnUpdate() Override
		If Keyboard.KeyHit( Key.Space )
			Cast<Model>(Entity).Material = New PbrMaterial( New Color( Rnd(), Rnd(), Rnd() ), 0.1, 0.5 )
		End
	End
End


Class Spin Extends Component
	Field x:Double, y:Double, z:Double
	
	Method New( x:Double, y:Double, z:Double )
		Super.New( "Spin" )
		Self.x = x
		Self.y = y
		Self.z = z
	End

	Method OnUpdate() Override
		Entity.Rotate( x, y, z, True )
	End
End