
Namespace game3d

#Import "<mojo3d>"
#Import "component"


Using mojo3d..
Using mojo..
Using std..

Class GameObj

	Public
	
	Global all			:= New StringMap<GameObj>
	Global rootObjs		:= New StringMap<GameObj>
	
	Field entity		:Entity								'Mojo3D entity
	
	Field enabled		:= True
	Field children		:= New Stack<GameObj>
	Field components	:= New Stack<Component>				'Main component list, they can be reordered
	
	'Gameplay
	Field timeOffset	:Double								'Use this to create offsets when the entity is reset (startTime = current time + timeOffset)
	Field vulnerable	:= True
	
	Protected
	
	Field _componentsByName	:= New StringMap<Component>		'allows fast access indexed by name

	Field _name				:= "entity"
	Field _parent			:GameObj						'Parent obj directly above this one
	Field _root				:GameObj						'Top parent obj (root of the entire hierarchy)
	Field _view				:SceneView
	Field _init				:= False						'Has this entity been initialized?

	Field _time				:Double
	Field _startTime		:Double
	Field _canvas 			:Canvas
'   	Field _player 			:Player
	Field _flicker			:Bool
	
	Field _initialEnabled	:Bool
	Field _initialVisible	:Bool
	
	
	'************************************* Public Properties *************************************

	Public

	Property Name:String()
		Return _name
	Setter( n:String )
		SetUniqueName( n )
	End

	Property Parent:GameObj() Virtual
		Return _parent
	Setter( dad:GameObj ) Virtual
		If dad
			Local dadIsMyChild := False
			For local e := Eachin children
				If e = dad
					dadIsMyChild = True
				End
			Next
			If dad <> Self And Not dadIsMyChild
				If _parent
					If dad = _parent Then Return
					_parent.children.RemoveEach( Self )
					
				Else
					rootObjs.Remove( _name )
				End
				_parent = dad
				_parent.children.Push( Self )
'				layer.rootList.Remove( Self )
'				layer = _parent.layer
				_root = SearchRoot()
				Print( Name + " parented to " + dad.Name )
				If entity <> Null
					entity.Parent = dad.entity
					If entity Then Print( Name + ".MeshRenderer parented" )
				End
'				_parent.transform.AttachChild( Self.transform )
				OnParent( dad )
			Else
				Print("Entity: Warning, " + _name + " can't parent to itself or to one of its own children.")
			End
		Else
			If Not rootObjs.Contains( Self.Name )
				If _parent
					_parent.children.RemoveEach( Self )
					entity.Parent = Null
				End
'				_parent.transform.RemoveChild( Self.transform )
				OnParent( Null )
				_parent = Null
				rootObjs.Add( _name, Self )
			End
			_root = Self
		End
	End

'   	Property player:Player()
'   		Return _player
'   	Setter( value:Player )
'   		_player = value
'   	End
	
	Property Root:GameObj()
		Return _root
	End

	Property Time:Double()
		Return _time
	End

	Property StartTime:Double()
		Return _startTime
	End
	
	Property View:SceneView()
		Return _view
	End
	
	
	'************************************* Public Methods *************************************
	
	
	Method New( name:String, view:SceneView )
		SetUniqueName( name )
		all.Add( name, Self )
		rootObjs.Add( name, Self )
		_root = Self
		_view = view
'   		Self.layer = layer
'   		layer.Add( Self )
'   		animation = New Animation( Self )
		
	End


	Method SetUniqueName( name:String )
		Local isRoot := False
		If rootObjs.Contains( _name )
			isRoot = True
			rootObjs.Remove( Self._name )
		End
		all.Remove( Self._name )

		Local n := 0
		Local originalName := name
		While all.Contains( name )
			n += 1
			name = originalName + n
		End
		Self._name = name

		all.Add( name, Self )
		If isRoot Then rootObjs.Add( name, Self )
	End
	
	
	Method Destroy( removeFromParent:Bool = True )
		OnDestroy()
		
		If entity <> Null
			entity.Destroy()
			entity = Null
		End
		
		all.Remove( _name )

		If Parent And removeFromParent
			_parent.children.RemoveEach( Self )
			_parent = Null
		End

		For local e := Eachin children
			e.Destroy( False )	'removeFromParent = false is needed when recursively destroying a hierarchy
		Next
		children.Clear()

		If Not components.Empty
			For local comp := Eachin components
				comp.Destroy()
				comp = Null
			End
			components.Clear()
		End
	End


	Method Update() Final
'   		transform.SetOldPosition( transform.WorldPosition )
		If Not _init
			Init()
			Return
		End
		_time = Clock.Now() - _startTime
		If enabled
'   			If player Then player.Update()
			OnUpdate()
			For Local c := Eachin components
				c.gameObj = Self
				c.Update()
			End
'   			Transform()
'   			If collider <> Null Then collider.Transform()
			For local e := Eachin children
				e.Update()
			Next
'   			If _root = Self
'   				familyBBox.Copy( worldShape )
'   				SetBBoxSize( familyBBox )	'Recursive function, only runs if object is the root of a hierarchy
'   			End
		End
	End


	Method LateUpdate() Final	'Do not use LateUpdate for movement! transform and collisions are not re-updated.
		If enabled
			OnLateUpdate()
'   			Transform( False )
			For Local c := Eachin components
				c.gameObj = Self
				c.LateUpdate()
			End
			For local e := Eachin children
				e.LateUpdate()
			Next
		End
	End


	Method Init() Final
		_init = True
		ResetTime()
		OnStart()
		'Ensures entities are parented if they were created during OnStart()
		If Parent
			If Parent.entity
				entity.Parent = Parent.entity
			End
		End
		'To do: Store initial state
	End
	
	
	Method ResetTime()
		_startTime = Clock.Now() + timeOffset
	End
	
	
	'********* Component management *********
	
	
	Method AddComponent:Component( comp:Component, index:Int = -1 )
		If _componentsByName.Get( comp.Name ) <> Null
			Print( "Entity: Warning, a component named " + comp.Name + " already belongs to entity " + Name + "." )
			Return Null
		End
		If index < 0 Then index = components.Length
		comp.gameObj = Self
		_componentsByName.Add( comp.Name, comp )
		components.Insert( index, comp )
		
		'This line is experimental! Prevents null access issues by running Init (which calls OnStart) when adding components. Add components in the right order!
		comp.Init()
		
		Return comp
	End


	Method GetComponent<T>:T( compName:String )
		Local c := _componentsByName.Get( compName )
		If c <> Null Then Return Cast<T>( c )
		Print( "Entity: Warning, no component named " + compName + " found in entity " + Name + "." )
		Return Null
	End


	Method GetComponentBySuperClass<T>:T( sup:String )
		For Local c := Eachin components
			If c.superClass = sup
				Local castComp := Cast<T>( c )
				Return castComp
			End
		Next
		Return Null
	End
	
	
'************************************* Virtual Methods *************************************


	Method Reset() Virtual
		If Not _init Then Init()
		enabled = _initialEnabled
'   		visible = _initialVisible
		OnReset()
'   		animation.Reset()
'   		transform.Reset()
		For Local c := Eachin components
			c.gameObj = Self
			c.Reset()
		End
		For local e := Eachin children
			e.Reset()
		Next
	End
	
'   	Method StoreInitialState()
'   		transform.StoreInitialState()
'   		animation.StoreInitialState()
'   		_initialEnabled = enabled
'   		_initialVisible = visible
'   		For Local n := 0 Until components.Length
'   			Local c := components[n]
'   			c.StoreInitialState()
'   		End
'   		For local e := Eachin children
'   			e.StoreInitialState()
'   		Next
'   	End

	Method OnStart() Virtual
	End

	Method OnUpdate() Virtual
	End

	Method OnReset() Virtual
	End

	Method OnDestroy() Virtual
	End

	Method OnInteract(  owner:GameObj, target:GameObj ) Virtual
	End

	Method OnOverlap( other:GameObj, tag:String ) Virtual
	End

	Method OnCollision( other:GameObj, tag:String ) Virtual
	End

	Method OnParent( dad:GameObj ) Virtual
	End

	Method OnDraw() Virtual
	End

	Method OnGuiDraw() Virtual
	End

	Method OnLateUpdate() Virtual
	End
	
	'************************************* Class Functions *************************************

	Function Find:GameObj( name:String )
		Local obj := all.Get( name )
		If Not obj Then Print( "Warning: GameObject " + name + " does not exist" )
		Return obj
	End


	'************************************* Private methods *************************************

	Protected

	'Recursive method to find topmost entity (root)
	Method SearchRoot:GameObj()
		Local temp :GameObj
		If _parent
			temp = _parent.SearchRoot()
			Return temp
		End
		Return Self
	End
	
End
