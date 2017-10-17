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
	
	'************************************* Public methods *************************************
	
	Public
	Method New( name:String )
		Name = name
	End

	Method Attach( obj:GameObject )
		_gameObj = obj
		OnAttach()
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
	
	Method To:String()
		Return Name	
	End
	
	'************************************* Virtual methods *************************************

	Protected

	'Called before the first frame update
	Method OnStart() Virtual
	End
	
	'Called right after component is added to a GameObject
	Method OnAttach() Virtual
	End
	
	'Called on every frame update
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