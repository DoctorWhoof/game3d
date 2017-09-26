Namespace game3d

Class Component
	
	Protected
	Field _box				:EntityBox
	Field _entity 			:Entity
	Field _name 			:= "noName"
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
	
	Property Entity:Entity()
		Return _box.Entity
	End
	
	Property Viewer:SceneView()
		Return _box.Viewer
	End
	
	Property Camera:Camera()
		Return _box.Viewer.Camera
	End
	
	Property Time:Double()
		Return _box.Time
	End
	
	'************************************* Public methods *************************************
	
	Method ToJsonValue:JsonValue()
		Return Serialize( Self )
	End
'	
'	Method FromJson( json:JsonObject )
'	End
		
	Method New( name:String )
		Name = name
	End
	
	
	Method SetBox( box:EntityBox )
		_box = box	
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
		_box = Null
	End
	

	'************************************* Virtual methods *************************************

	Protected
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