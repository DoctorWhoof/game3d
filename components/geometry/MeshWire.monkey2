Namespace game3d

Class WireMesh Extends Component
	
	Field pathBase:= ""
	Field pathWire:= ""
	
	Field matBase:= ""
	Field matWire:= ""

	Field near:= 1.0
	Field far:= 120.0

	Field nearPush := 0.12
	Field farPush := 0.18
	
	Private
	Field _morpher:Morpher
	Field _model:Model
	
	Public
	
	Method New()
		Super.New( "WireMesh" )
	End
	
	Method OnAttach() Override
		
		Local mesh0 := Mesh.Load( pathWire )
		Local mesh1 := Mesh.Load( pathWire )
		
		'push mesh2
		For Local i:=0 Until mesh1.NumVertices
			Local v:=mesh1.GetVertex( i )
			v.position += ( v.normal * farPush )
			mesh1.SetVertex( i,v )
		Next

		_morpher = New Morpher( mesh0, mesh1 )
		GameObject.SetEntity( _morpher )
		
		_model = Model.Load( pathBase )
		_model.Parent = _morpher
	End
	
	Method OnStart() Override
		Local materialBase := mojo3d.Material.Get( matBase )
		Local materialWire := mojo3d.Material.Get( matWire )
		
		If materialBase Then _model.Materials = New Material[]( materialBase )
		If materialWire Then _morpher.material = materialWire
	End
	
	Method OnUpdate() Override
		Local dist := _morpher.Position.Distance( Camera.Position )
		Local amount := Clamp<Float>( dist / far, 0.0, 1.0 )
		
		Viewer.Echo( Truncate(dist, 3) + ": " + Truncate( amount, 3) )
		_morpher.amount = amount
	End
		
End

