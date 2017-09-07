Namespace game3d

#Import "component"

Class ComponentBox
	
	Field timeOffset:Double = 0.0
	
	Private
	Global _all:= New Map< Entity,ComponentBox >
	
	Field _entity:Entity
	Field _viewer:SceneView
	Field _time:Double
	Field _components := New Stack<Component>
	Field _componentsByName	:= New StringMap<Component>		'allows fast access indexed by name
	
	Public
	Property Entity:Entity()
		Return _entity
	End
	
	Property Viewer:SceneView()
		Return _viewer
	End
	
	Property Time:Double()
		Return _time	
	End
	
	'************************************* Public Methods *************************************
	
	Method New( e:Entity )
		_entity = e
		_viewer = SceneView.Current()
		_all.Add( e, Self )
	End

	Method AddComponent( c:Component )
		If _componentsByName.Contains( c.Name )
			Print( "ComponentBox: Component	" + c.Name + " already exists." )
			Return
		End
		_componentsByName.Add( c.Name, c )
		_components.Push( c )
		c.SetBox( Self )
		Print( "ComponentBox '" + _entity.Name + "': Added Component " + c.Name )
	End
	
	Method GetComponent<T>:T( name:String )
		Local c := _componentsByName.Get( name )
		If c <> Null Then Return Cast<T>( c )
		Print( "ComponentBox: Warning, no component named " + name + " found in entity " + _entity.Name + "." )
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
		For Local c:= Eachin _components
			c.Start()
		Next
	End
		
	Method Update()
		_time = Clock.Now() + timeOffset
		For Local c:= Eachin _components
			If c.enabled Then c.Update()
		Next
	End
	
	Method Draw( canvas:Canvas )
		For Local c:= Eachin _components
			If c.enabled Then c.Draw( canvas )
		Next
	End
	
	Method LateUpdate()
		For Local c:= Eachin _components
			If c.enabled Then c.LateUpdate()
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
		_all.Remove( _entity )
	End
	'************************************* Static Functions *************************************

	Function  GetFromEntity:ComponentBox( e:Entity )
		Return _all[ e ]
	End
	
		
	Function StartAll()
		For Local cBox:= Eachin _all.Values
			cBox.Start()
		Next
	End
		
	Function UpdateAll()
		For Local cBox:= Eachin _all.Values
			cBox.Update()
		Next
	End
	
	Function DrawAll( canvas:Canvas )
		For Local cBox:= Eachin _all.Values
			cBox.Draw( canvas )
		Next
	End
	
	Function LateUpdateAll()
		For Local cBox:= Eachin _all.Values
			cBox.LateUpdate()
		Next
	End
	
	Function ResetAll()
		For Local cBox:= Eachin _all.Values
			cBox.Reset()
		Next
	End
	
End