Namespace game3d

Class CameraComponent Extends Component
	
	Property FOV:Float()
		Return _cam.FOV
	Setter( fov:Float )
		_cam.FOV = fov
	End
	
	Property Near:Float()
		Return _cam.Near
	Setter( near:Float )
		_cam.Near = near
	End
	
	Property Far:Float()
		Return _cam.Far
	Setter( far:Float )
		_cam.Far = far
	End
	
	Property Aspect:Float()
		Return _cam.Aspect
	End
	
	Private
	Field _cam :Camera
	
	Public
	Method New()
		Super.New( "CameraComponent" )
	End
	
	Method OnCreate() Override
		_cam = New Camera
		_cam.Name  = "EntityCamera"
		GameObject.SetEntity( _cam )
		GameObject.Viewer.Camera = _cam
	End
	
End