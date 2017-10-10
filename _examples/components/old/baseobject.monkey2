
Namespace game3d


Class BaseObject Extends Component
	
	Public
	Property Position:Float[]()
		Return Entity.Position.ToArray()
	Setter( p:Float[] )
		Entity.Position.FromArray( p )
	End
	
	Property Rotation:Float[]()
		Return Entity.Rotation.ToArray()
	Setter( r:Float[] )
		Entity.Scale.FromArray( r )
	End
	
	Property Scale:Float[]()
		Return Entity.Scale.ToArray()
	Setter( s:Float[] )
		Entity.Scale.FromArray( s )
	End
	
	Property Parent:String()
		If Entity.Parent
			Return Entity.Parent.Name
		Else
			Return Null
		End
	Setter( pName:String )
		If pName
			Entity.Parent = Entity.Find( pName )
		End
	End
	
	Method New( name:String )
		Super.New( "BaseObject" )
		_entityName = name
	End
	
	Method OnStart() Override
		Entity.Name = _entityName
	End
	
	Private
	Field _entityName:String
	
End
