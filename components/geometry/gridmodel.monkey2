Namespace game3d

Class GridModel Extends Component
	
	Field rows:= 10.0
	Field collumns:= 10.0
	Field width := 1.0
	Field height := 1.0
	Field quadMap := True
	
	Property Center:Double[]()
		Return _center.ToArray()
	Setter( c:Double[] )
		_center = Vec2<Double>.FromArray( c )
	End
	
	Private
	Field _center:= New Vec2<Double>( 0.5, 0.5 )

	Public
	Method New()
		Super.New( "GridModel" )
	End
	
	Method OnCreate() Override
		Local model := New Model
		model.Mesh = CreateGrid( width, height, rows, collumns, True, _center )
		GameObject.SetEntity( model )
	End
	
End