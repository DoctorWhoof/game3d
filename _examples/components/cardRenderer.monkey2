Namespace game3d

#Import "../../graphics/grid"
#Import "../../graphics/atlas"

Class CardRenderer Extends Component
	
	Field alignToCamera:= True
	Field stayUpright:= True
	
	Field mesh: Mesh
	Field mat:PbrMaterial
	Field model: Model
	
	Field center := New Vec2f( 0.5, 0.5 )
	
	Method New( path:String, frameNumber:Int, quadWidth:Double, quadHeight:Double, cellWidth:Int, cellHeight:Int, flags:TextureFlags = TextureFlags.FilterMipmap )
		Super.New( "CardRenderer" )
		Local sheet := New Atlas( path, cellWidth, cellHeight, 0, 0, flags )
		mesh = CreateSprite( frameNumber, sheet.Coords, quadWidth, quadHeight )
		mat =  New PbrMaterial( Color.White )
		mat =  New PbrMaterial( True, False, False )
		mat.ColorTexture = sheet.Texture
		model = New Model( mesh, mat )
	End
	
	Method OnStart() Override
		Entity = model
	End
	
	Method OnUpdate() Override
		Local camPos := View.Camera.Position
		If alignToCamera
			If stayUpright
				Entity.Ry = AngleBetween( camPos.X, camPos.Z, Entity.X, Entity.Z ) - 90
			Else
				Entity.PointAt( View.Camera )
				Entity.RotateY( 180 )				
			End
		End
	End
End


