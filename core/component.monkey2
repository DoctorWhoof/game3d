Namespace game3d

Class Component

	Field enabled			:= True
	
	Protected
	Field _box				:EntityBox
	Field _entity 			:Entity
	Field _name 			:= "noName"
	Field _superClass		:= "Component"	'normally set by Name, override it to be able to GetComponent by superclass (i.e. items)
	Field _init				:= False


	'************************************* Public properties *************************************

	Public		
	Property Name:String()
		Return _name
	Setter( name:String )
		_name = name
		_superClass = name
	End
	
	Property Entity:Entity()
		Return _box.Entity
	End
	
	Property Viewer:SceneView()
		Return _box.Viewer
	End
	
'	Marked for removal
'	Property Box:EntityBox()
'		Return _box	
'	End
	
	Property Camera:Camera()
		Return _box.Viewer.Camera
	End
	
	Property Time:Double()
		Return _box.Time
	End
	
	'************************************* Public methods *************************************
		
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
		If enabled
			OnUpdate()
		End
	End
	
	Method Draw( canvas:Canvas )
		If enabled
			OnDraw( canvas )
		End
	End
	
	Method LateUpdate()
		If enabled
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
		_box.RemoveComponent( Self )
	End

	'************************************* Virtual methods *************************************
	
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