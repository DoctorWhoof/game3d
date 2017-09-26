Namespace game3d

#Import "component"

Class GameObject
	
	Field timeOffset:Double = 0.0
	
	Private
	Global _all := New Stack<GameObject >
	Global _allByEntity:= New Map< Entity,GameObject >
	Global _allByName:= New Map< String,GameObject >

	Field _name:String
	Field _entity:Entity
	Field _viewer:SceneView
	Field _time:Double
	Field _components := New Stack<Component>
	Field _componentsByName	:= New StringMap<Component>		'allows fast access indexed by name
	
	Public
	Property Name:String()
		Return _name
	Setter( name:String )
		_allByName.Remove( _name )
		_allByName.Add( name, Self )
		_name = name
	End
	
	Property Entity:Entity()
		Return _entity
	End
	
	Property Transform:Entity()
		Return _entity
	End
	
	Property Viewer:SceneView()
		Return _viewer
	Setter( v:SceneView )
		_viewer = v
	End
	
	Property Time:Double()
		Return _time	
	End
	
	Property Components:Component[]()
		Return _components.ToArray()
	End
	
	'************************************* Public Methods *************************************
	
	Method New( name:String )
		Name = name
		_viewer = SceneView.Current()
		_all.Push( Self )
		
'		Local ent := New Entity
'		ent.Name = name + "DefaultEntity"
'		SetEntity( ent)
	End
	
	
	Method SetEntity( ent:Entity )
		If _entity
			Print ( "Removing entity: " + _entity.Name + " from GameObject " + Name)
			ent.Parent = _entity.Parent
			ent.Position = _entity.Position
			ent.Rotation = _entity.Rotation
			ent.Scale = _entity.Scale
			ent.Visible = _entity.Visible
			_allByEntity.Remove( _entity )
			_entity.Destroy()
		End
		_entity = ent
		_entity.Destroyed = Lambda()
			Self.Destroy()
		End
		_allByEntity.Add( _entity, Self )
		Print ( "Added entity: " + _entity.Name + " to GameObject " + Name + "~n")
	End
	

	Method AddComponent( c:Component )
		If _componentsByName.Contains( c.Name )
			Print( "GameObject: Component	" + c.Name + " already exists." )
			Return
		End
		_componentsByName.Add( c.Name, c )
		_components.Push( c )
		c.SetGameObject( Self )
		c.OnCreate( Viewer )
	End
	
	
	Method GetComponent<T>:T( name:String )
		Local c := _componentsByName.Get( name )
		If c <> Null Then Return Cast<T>( c )
		Print( "GameObject: Warning, no component named " + name + " found in entity " + _entity.Name + "." )
		Return Null
	End
	
	
	Method GetComponentBySuperClass<T>:T( sup:String )
		For Local c := Eachin _components
			If c.superClass = sup
				Local castComp := Cast<T>( c )
				Return castComp
			End
		Next
		Return Null
	End
	
	
	Method RemoveComponent( c:Component )
		_componentsByName.Remove( c.Name )
		_components.Remove( c )
	End
	
	
	'************************************* Component events *************************************
		
	Method Start()
		Print ( "Starting " + Name )
		For Local c:= Eachin _components
			c.Start()
		Next
	End
	
		
	Method Update()
		_time = Clock.Now() + timeOffset
		For Local c:= Eachin _components
			If c.Enabled Then c.Update()
		Next
	End
	
	
	Method Draw( canvas:Canvas )
		For Local c:= Eachin _components
			If c.Enabled Then c.Draw( canvas )
		Next
	End
	
	
	Method LateUpdate()
		For Local c:= Eachin _components
			If c.Enabled Then c.LateUpdate()
		Next
	End
	
	
	Method Reset()
		For Local c:= Eachin _components
			c.Reset()
		Next
	End

	'To do:destroy needs to be called from Entity.Destroyed
	Method Destroy()
		For Local c:= Eachin _components
			c.Destroy()
		Next
		_components.Clear()
		_componentsByName.Clear()
		_all.Remove( Self )
		_allByName.Remove( Name )
		_allByEntity.Remove( _entity )
		_entity = Null
	End
	'************************************* Static Functions *************************************

	Function  GetFromEntity:GameObject( e:Entity )
		Return _allByEntity[ e ]
	End

	Function  Find:GameObject( name:String )
		Return _allByName[ name ]
	End
	
End