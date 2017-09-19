Namespace game3d

#Import "../../graphics/animsprite"

Class SpriteAnim Extends Component
	
	'To do: move some of the AnimSprite functionality into this component? Maybe all of it, and just use regular Sprites?
	
	Public
	Method New()
		Super.New( "SpriteRenderer" )
	End
	
	Method OnUpdate() Override
		Cast<AnimSprite>( Entity ).Update( Time )
	End
	
End


