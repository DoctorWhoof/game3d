
Namespace game3d

Class ModelMorph Extends Component
	
	Field path0:= ""
	Field path1:= ""
	Field amount:= 0.5
	
	Private
	
	Field _morpher:Morpher
	
	Public
	
	Method New()
		Super.New( "ModelMorph" )
	End
	
	Method OnAttach() Override
		Local mesh0 := Mesh.Load( path0 )
		Local mesh1 := Mesh.Load( path1 )

		_morpher = New Morpher( mesh0, mesh1 )
		GameObject.SetEntity( _morpher )
	End
	
	Method OnUpdate() Override
		If Keyboard.KeyDown( Key.Up )
			amount += 0.05
		Elseif Keyboard.KeyDown( Key.Down )
			amount -= 0.05
		End
		amount = Clamp( amount, 0.0, 1.0 )
		Viewer.Echo( amount )
		_morpher.amount = amount
	End
		
End


