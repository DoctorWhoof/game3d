Namespace game3d

Class Component

	Field enabled			:= True
	Field gameObj 			:GameObj			'The owner of this component

	Field superClass		:= "Component"	'normally set by Name, override it to be able to GetComponent by superclass (i.e. items)
	
	Global all				:= New List<Component>
	
	Protected
	Field _name 			:= "noName"
	Field _init				:= False
	Field _view				:SceneView


	'************************************* Instance properties *************************************

	Public		
	Property Name:String() Virtual
		Return _name
	Setter( name:String )
		If name = ""
			name = "ComponentName"
			Print( "Component: Warning, component has no name. Naming it 'ComponentName'." )
		End
		_name = name
		superClass = name
	End
	
	Property Entity:Entity()
		Return gameObj.entity
	Setter( ent:Entity )
		gameObj.entity = ent
	End
	
	Property View:SceneView()
		Return gameObj.View
	End
	
	'************************************* Instance methods *************************************
		
	Method New( name:String )
		Name = name
		all.Add( Self )
	End

	Method Init()
		_init = True
		OnStart()	
	End
		
	Method Update()
		If Not _init
			Init()
		End
		If enabled
			OnUpdate()
		End
	End
	
	Method LateUpdate()
		If enabled
			OnLateUpdate()
		End
	End
	
	Method Reset()
		If Not _init
			Init()
		End
		OnReset()
	End
	
	Method Destroy()
		all.Remove( Self )
		OnDestroy()
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
	
	Method OnInteract( owner:Entity, target:Entity ) Virtual
	End
	
	Method OnOverlap( other:Entity, tag:String ) Virtual
	End
	
	Method OnCollision( other:Entity, tag:String ) Virtual
	End
	
	Method OnDraw( canvas:Canvas ) Virtual
	End
	
	Method OnLateDraw( canvas:Canvas ) Virtual
	End
	
	Method OnGuiDraw( canvas:Canvas ) Virtual
	End

	Method OnLateUpdate() Virtual
	End
	
	Method StoreInitialState() Virtual	
	End



End