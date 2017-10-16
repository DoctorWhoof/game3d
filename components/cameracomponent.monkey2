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
	
	Property Aspect:Double()
		Return _cam.Aspect
	End
	
	Property FogColor:Double[]()
		Return _fog.Color.ToArray()
	Setter( c:Double[] )
		_fog.Color = std.graphics.Color.FromArray( c )
	End
	
	Property EnvColor:Double[]()
		Return _envColor.ToArray()
	Setter( c:Double[] )
		_envColor = std.graphics.Color.FromArray( c )
	End
	
	Property ClearColor:Double[]()
		Return _clearColor.ToArray()
	Setter( c:Double[] )
		_clearColor = std.graphics.Color.FromArray( c )
	End
	
	Property AmbientLight:Double[]()
		Return _ambLight.ToArray()
	Setter( c:Double[] )
		_ambLight = std.graphics.Color.FromArray( c )
	End
	
	Private
	Field _cam :Camera
	Field _fog :FogEffect
	Field _envColor: Color
	Field _clearColor: Color
	Field _ambLight: Color
	
	Public
	Method New()
		Super.New( "CameraComponent" )
		_cam = New Camera
		_cam.Name  = "EntityCamera"
		
		_fog = New FogEffect( Color.Blue, _cam.Near, _cam.Far )
	End
	
	Method OnAttach() Override
		GameObject.SetEntity( _cam )
		Viewer.Camera = _cam
		If _fog Then Viewer.Scene.AddPostEffect( _fog )
		If _envColor Then Viewer.Scene.EnvColor = _envColor
		If _clearColor Then Viewer.Scene.ClearColor = _clearColor
		If _ambLight Then Viewer.Scene.AmbientLight = _ambLight
	End
	
End