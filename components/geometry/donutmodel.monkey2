Namespace game3d


Class DonutModel Extends Component
	
	Field outerRadius:= 1.0
	Field innerRadius:= 0.2
	Field outerSegs := 24
	Field innerSegs := 12

	Method New()
		Super.New( "DonutModel" )
	End
	
	Method OnAttach() Override
		Local model := New Model
		model.Mesh = Mesh.CreateTorus( outerRadius, innerRadius, outerSegs, innerSegs  )
		model.AssignMaterial( New PbrMaterial( Color.Yellow ) )
		GameObject.SetEntity( model )
	End
	
End