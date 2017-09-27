Namespace game3d


Class LoadModel Extends Component
	
	Private
	Field _path:= ""
	
	Public
	Method New()
		Super.New( "LoadModel" )
	End
	
	Method New( path:String )
		Super.New( "LoadModel" )
		Self._path = path
	End
	
	Method OnCreate() Override
		GameObject.SetEntity( Model.Load( _path ) )
	End
	
End