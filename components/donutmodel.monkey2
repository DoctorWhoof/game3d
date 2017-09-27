Namespace game3d


Class DonutModel Extends Component
	
	Field outerRadius:= 1.0
	Field innerRadius:= 0.2
	Field outerSegs := 24
	Field innerSegs := 12
	
	Private

	Public
	Method New()
		Super.New( "DonutModel" )
	End
	
	Method OnCreate() Override
		Local model := New Model
		model.Mesh = Mesh.CreateTorus( outerRadius, innerRadius, outerSegs, innerSegs  )
		GameObject.SetEntity( model )
	End
	
End