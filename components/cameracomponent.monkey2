Namespace game3d

Class CameraComponent Extends Component
	
	Property FOV:Double()
		Return _cam.FOV
	Setter( fov:Double )
		_cam.FOV = fov
	End
	
	Property Near:Double()
		Return _cam.Near
	Setter( near:Double )
		_cam.Near = near
		If _fog Then _fog.Near = near
	End
	
	Property Far:Double()
		Return _cam.Far
	Setter( far:Double )
		_cam.Far = far
		If _fog Then _fog.Far = far
	End
	
	Property FogColor:Double[]()
		Return _fog.Color.ToArray()
	Setter( c:Double[] )
		_fog.Color = std.graphics.Color.FromArray( c )
	End
	
	Property Aspect:Double()
		Return _cam.Aspect
	End
	
	Private
	Field _cam :Camera
	Field _fog :FogEffect
	
	Public
	Method New()
		Super.New( "CameraComponent" )
		_cam = New Camera
		_cam.Name  = "EntityCamera"
		
		_fog = New FogEffect( Color.Blue, _cam.Near, _cam.Far )
	End
	
	Method OnCreate() Override
		GameObject.SetEntity( _cam )
		GameObject.Viewer.Camera = _cam
		GameObject.Viewer.Scene.AddPostEffect( _fog )
	End
	
End