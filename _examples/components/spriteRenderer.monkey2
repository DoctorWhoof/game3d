#Import "../../graphics/animsprite"

Class SpriteRenderer Extends Component
	
	Field sprite:AnimSprite
	
	Private
	Field material :SpriteMaterial
	Field path:String
	
	Public
	Method New( path:String, _cellWidth:Int, _cellHeight:Int, _padding:Int = 0, _border:Int = 0, _flags:TextureFlags = TextureFlags.FilterMipmap )
		Super.New( "SpriteRenderer" )
		sprite = New AnimSprite( path, _cellWidth, _cellHeight, _padding, _border, _flags )
	End
	
	Method OnStart() Override
		Entity = sprite
		sprite.Update( gameObj.Time )
	End
	
	Method OnUpdate() Override
		sprite.Update( gameObj.Time )
		Print( "oy" )
	End
	
End


