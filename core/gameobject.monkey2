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
	
	Property Position:Float[]()
		Return Entity.Position.ToArray()
	Setter( p:Float[] )
		Entity.Position = Vec3f.FromArray( p )
	End
	
	Property Rotation:Float[]()
		Return Entity.Rotation.ToArray()
	Setter( r:Float[] )
		Entity.Scale = Vec3f.FromArray( r )
	End
	
	Property Scale:Float[]()
		Return Entity.Scale.ToArray()
	Setter( s:Float[] )
		Entity.Scale = Vec3f.FromArray( s )
	End
	
	Property Parent:String()
		If Entity.Parent
			Return GetFromEntity( Entity.Parent ).Name
		Else
			Return Null
		End
	Setter( pName:String )
		If pName <> ""
			Entity.Parent = Find( pName ).Entity
		Else
			Entity.Parent = Null
		End
	End
	
	Property Entity:Entity()
		Return _entity
	End
	
	Property Transform:Entity()
		Return _entity
	End
	
	Property Viewer:SceneView()
		Return _viewer
	End
	
	Property Time:Double()
		Return _time	
	End
	
	Property Components:Component[]()
		Return _components.ToArray()
	Setter( c:Component[] )
		'dummy setter for proper serialization!
	End
	
	'************************************* Public Methods *************************************
	
	Method New( name:String )
		_viewer = SceneView.Current()		'May need rethinking. Do we need it to be assigned more specifically?
		_all.Push( Self )
		Name = name
	End
	
	
	Method SetEntity( ent:Entity )
		If _entity
'			Print ( "Removing entity: " + _entity.Name + " from GameObject " + Name)
			ent.Parent = _entity.Parent
			ent.Position = _entity.Position
			ent.Rotation = _entity.Rotation
			ent.Scale = _entity.Scale
			ent.Visible = _entity.Visible
			_allByEntity.Remove( _entity )
			_entity.Destroy()
		End
		_entity = ent
		_allByEntity.Add( _entity, Self )
'		Print ( "Added entity: " + _entity.Name + " to GameObject " + Name )
	End
	

	Method AddComponent<T>:T( c:T ) Where T Extends Component
		If _componentsByName.Contains( c.Name )
			Print( "GameObject: Component	" + c.Name + " already exists." )
			Return Null
		End
		_componentsByName.Add( c.Name, c )
		_components.Push( c )
		c.SetGameObject( Self )
		c.OnCreate()
		Return c
	End
	
	
	Method GetComponent<T>:T( name:String ) Where T Extends Component
		Local c := _componentsByName.Get( name )
		If c <> Null Then Return Cast<T>( c )
		Print( "GameObject: Warning, no component named " + name + " found in entity " + _entity.Name + "." )
		Return Null
	End
	
	
	Method GetComponentBySuperClass<T>:T( sup:String ) Where T Extends Component
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
	
	
	Method AddComponentsToJson( json:JsonObject )
		For Local c := Eachin Components
			json.Serialize( c.Name, c )
		Next
	End
	
	
	'************************************* Component events *************************************
		
	Method Start()
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
		If _entity
			_entity.Destroy()
			_entity = Null
		End
	End
	'************************************* Static Functions *************************************

	Function  GetFromEntity:GameObject( e:Entity )
		Return _allByEntity[ e ]
	End
	
	Function  GetFromEntityWithChildren:GameObject[]( e:Entity )
		Local stack := New Stack<GameObject>
		stack.Push( _allByEntity[ e ] )
		For Local c := Eachin e.Children
			stack.AddAll( GetFromEntityWithChildren( c ) )
		Next
		Return stack.ToArray()
	End

	Function  Find:GameObject( name:String )
		Return _allByName[ name ]
	End
	
	Function GetFromScene:GameObject[]( scene:Scene )
		Local stack := New Stack<GameObject>
		For Local e:= Eachin scene.GetRootEntities()
			stack.AddAll( GetFromEntityWithChildren( e ) )
		End
		Return stack.ToArray()
	End
	
End
















