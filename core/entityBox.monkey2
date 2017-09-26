Namespace game3d

#Import "component"

Class EntityBox
	
	Field timeOffset:Double = 0.0
	
	Private
	Global _all:= New Map< Entity,EntityBox >

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
	
	Property Components:Component[]()
		Return _components.ToArray()
	End
	
	'************************************* Public Methods *************************************
	
	Method New( e:Entity )
		_entity = e
		_viewer = SceneView.Current()
		_all.Add( e, Self )
	End

	Method AddComponent( c:Component )
		If _componentsByName.Contains( c.Name )
'			Print( "EntityBox: Component	" + c.Name + " already exists." )
			Return
		End
		_componentsByName.Add( c.Name, c )
		_components.Push( c )
		c.SetBox( Self )
'		Print( "EntityBox '" + _entity.Name + "': Added Component " + c.Name )
	End
	
	Method GetComponent<T>:T( name:String )
		Local c := _componentsByName.Get( name )
		If c <> Null Then Return Cast<T>( c )
		Print( "EntityBox: Warning, no component named " + name + " found in entity " + _entity.Name + "." )
		Return Null
	End
	
'	Method GetComponent:Component( name:String )
'		Local c := _componentsByName.Get( name )
'		If c <> Null Then Return c
'		Print( "EntityBox: Warning, no component named " + name + " found in entity " + _entity.Name + "." )
'		Return Null
'	End
	
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
		_all.Remove( _entity )
		_entity = Null
	End
	'************************************* Static Functions *************************************

	Function  GetFromEntity:EntityBox( e:Entity )
		Return _all[ e ]
	End
	
		
	Function StartAll()
		For Local eBox:= Eachin _all.Values
			eBox.Start()
		Next
	End
		
	Function UpdateAll()
		For Local eBox:= Eachin _all.Values
			eBox.Update()
		Next
	End
	
	Function DrawAll( canvas:Canvas )
		For Local eBox:= Eachin _all.Values
			eBox.Draw( canvas )
		Next
	End
	
	Function LateUpdateAll()
		For Local eBox:= Eachin _all.Values
			eBox.LateUpdate()
		Next
	End
	
	Function ResetAll()
		For Local eBox:= Eachin _all.Values
			eBox.Reset()
		Next
	End
	
End