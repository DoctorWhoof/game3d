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
	Field _componentsByName	:= New StringMap<Component>
	
	Public
	Property Name:String()
		Return _name
	Setter( name:String )
		_allByName.Remove( _name )
		_allByName.Add( name, Self )
		_name = name
	End
	
	
	Property Visible:Bool()
		If _entity
			Return _entity.Visible
		Else
			Return False
		End
	Setter( vis:Bool )
		If Entity
			_entity.Visible = vis
		End
	End
	
	
	Property Position:Double[]()
		CheckEntity()
		If _entity Then Return Entity.LocalPosition.ToArray()
		Return Null
	Setter( p:Double[] )
		CheckEntity()
		If _entity Then Entity.LocalPosition = Vec3<Double>.FromArray( p )
	End
	
	
	Property Rotation:Double[]()
		CheckEntity()
		If _entity Then Return Entity.LocalRotation.ToArray()
		Return Null
	Setter( r:Double[] )
		CheckEntity()
		If _entity Then Entity.LocalRotation = Vec3<Double>.FromArray( r )
	End
	
	
	Property Scale:Double[]()
		CheckEntity()
		If _entity Return Entity.LocalScale.ToArray()
		Return Null
	Setter( s:Double[] )
		CheckEntity()
		If _entity Then Entity.LocalScale = Vec3<Double>.FromArray( s )
	End
	
	
	Property Parent:String()
		CheckEntity()
		If _entity
			If _entity.Parent Return GetFromEntity( _entity.Parent ).Name
		End
		Return Null		
	Setter( pName:String )
		CheckEntity()
		Local gameObjParent := Find( pName )
		If _entity
			If gameObjParent
				If pName <> ""
					_entity.Parent = Find( pName ).Entity
				Else
					_entity.Parent = Null
				End
			End
		End
	End
	
	
	Property Components:Component[]()
		Return _components.ToArray()
	Setter( compArray:Component[] )
		_components.Clear()
		For Local c := Eachin compArray
			If c Then AddComponent( c )
		Next
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
	
	'************************************* Public Methods *************************************

	Method New()
		_viewer = SceneView.Current()		'May need rethinking. Do we need it to be assigned more specifically?
		_all.Push( Self )
	End
	
	
	Method SetEntity( ent:Entity )
		If _entity
			ent.Parent = _entity.Parent
			ent.Position = _entity.Position
			ent.Rotation = _entity.Rotation
			ent.Scale = _entity.Scale
			ent.Visible = _entity.Visible
			_allByEntity.Remove( _entity )
			_entity.Destroy()
		End
		_entity = Null
		_entity = ent
		_allByEntity.Add( _entity, Self )
	End
	
	
	Method CheckEntity()
		If Not _entity Print( "GameObject: Error, " + Name + " contains no mojo3d Entity" )
	End
	

	Method AddComponent<T>:T( c:T ) Where T Extends Component
		If _componentsByName.Contains( c.Name )
			Print( "GameObject: Component	" + c.Name + " already exists." )
			Return Null
		End
		_componentsByName.Add( c.Name, c )
		_components.Push( c )
		c.Attach( Self )
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
	
	
	Method List()
		Local info := InstanceType
		Local v:= Variant( Self )
		Print "~n" + Name
		For Local d := Eachin info.GetDecls()
			If( d.Kind = "Field" And Not d.Name.StartsWith( "_" ) ) Or ( d.Kind = "Property" And d.Settable )
				Select d.Name
				Case "Components"
					Print "Components:"
					For Local c := Eachin Components
						Print "|   |    " + c.Name
					Next
				Default
					Print "|   " + d.Name + ": " + VariantToString( d.Get( v ) )
				End
			End
		End
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
	
	
	Method ResetTime()
		timeOffset = -Clock.Now()
	End

	'To do:destroy needs to be called from Entity.Destroyed
	Method Destroy( destroyEntity:Bool = True )
		For Local c:= Eachin _components
			c.Destroy()
		Next
		_components.Clear()
		_componentsByName.Clear()
		_all.Remove( Self )
		_allByName.Remove( Name )
		_allByEntity.Remove( _entity )
		If destroyEntity
			If _entity
				_entity.Destroy()
				_entity = Null
			End
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
		If name <> ""
			Local g := _allByName[ name ]
			If Not g
				Print ( "GameObject: Can't find GameObject " + name )
				Return Null
			End
		End
		Return _allByName[ name ]
	End
	
	Function GetFromScene:GameObject[]( scene:Scene )
		Local stack := New Stack<GameObject>
		For Local e:= Eachin scene.GetRootEntities()
			stack.AddAll( GetFromEntityWithChildren( e ) )
		End
		Return stack.ToArray()
	End
	
	Function All:GameObject[]()
		Return _all.ToArray()
	End
	
End
















