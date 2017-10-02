Namespace game3d

Class Component
	
	Protected
	Field _gameObj			:GameObject
	Field _entity			:Entity
	Field _name				:= "noName"
	Field _superClass		:= "Component"	'normally set by Name, override it to be able to GetComponent by superclass (i.e. items)
	Field _init				:= False
	Field _enabled			:= True


	'************************************* Public properties *************************************

	Public		
	Property Name:String()
		Return _name
	Setter( name:String )
		_name = name
		_superClass = name
	End
	
'	Property GameObjectByName:String()
'		Return _gameObj.Name
'	Setter( name:String )
'		_gameObj = GameObject.Find( name )
'	End
	
	Property Enabled:Bool()
		Return _enabled
	Setter( isEnabled:Bool )
		_enabled = isEnabled
	End
	
	Property GameObject:GameObject()
		Return _gameObj
	End
	
	Property Entity:Entity()
		Return _gameObj.Entity
	End
	
	Property Viewer:SceneView()
		Return _gameObj.Viewer
	End
	
	Property Camera:Camera()
		Return _gameObj.Viewer.Camera
	End
	
	Property Time:Double()
		Return _gameObj.Time
	End
	
'	Private
'	Property Owner:String()
'		Return _gameObj.Name
'	Setter( name:String )
'		If _gameObj Then _gameObj.RemoveComponent( Self )
'		_gameObj = GameObject.Find( name )
'		_gameObj.AddComponent( Self )
'		Print _gameObj.Name + "+= " + Name
'	End
	
	'************************************* Public methods *************************************
	
	Public
'	Method ToJsonValue:JsonValue()
'		Return Serialize( Self )
'	End
'	
'	Method FromJson( json:JsonObject )
'	End

	Method New( name:String )
		Name = name
	End
	
'	Method Init()
'		'Call this after deserializing, to ensure all fields values are applied, and before OnCreate()
'		Local type := Self.DynamicType	
'		For Local d := Eachin type.GetDecls()
'			Print Name + ":" + d.Name
'		Next
'	End
'	
	Method SetGameObject( obj:GameObject )
		_gameObj = obj
'		Print "    " + Name + " gameObject:" + obj.Name
	End
	
	Method Start()
		_init = True
		OnStart()	
	End
		
	Method Update()
		If Not _init
			Start()
		End
		If _enabled
			OnUpdate()
		End
	End
	
	Method Draw( canvas:Canvas )
		If _enabled
			OnDraw( canvas )
		End
	End
	
	Method LateUpdate()
		If _enabled
			OnLateUpdate()
		End
	End
	
	Method Reset()
		If Not _init
			Start()
		End
		OnReset()
	End

	Method Destroy()
		OnDestroy()
		_entity = Null
		_gameObj = Null
	End
	
	'Called right after component is added (and already knows its gameobject)
	Method OnCreate() Virtual
	End
	
	Method To:String()
		Return Name	
	End
	
	'************************************* Virtual methods *************************************

	Protected

	'Called before the first frame update
	Method OnStart() Virtual
	End
	
	Method OnUpdate() Virtual
	End
	
	Method OnReset() Virtual
	End

	Method OnDestroy() Virtual
	End
	
	Method OnDraw( canvas:Canvas ) Virtual
	End

	Method OnLateUpdate() Virtual
	End
	
	Method StoreInitialState() Virtual	
	End



End