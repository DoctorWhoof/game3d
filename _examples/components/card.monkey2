Namespace game3d

#Import "../../graphics/grid"
#Import "../../graphics/atlas"

Class Card Extends Component
	
	Field frame:= 0
	Field alignToCamera:= True
	Field stayUpright:= False
	
	Field mesh: Mesh
	Field mat:PbrMaterial
	Field model: Model
	Field sheet: Atlas
	Field center := New Vec2f( 0.5, 0.5 )
	
	Private
	Field quadSize :Vec2f
	
	Public
	Method New( path:String, frame:Int, quadWidth:Double, quadHeight:Double, cellWidth:Int, cellHeight:Int, flags:TextureFlags = TextureFlags.FilterMipmap )
		Super.New( "CardRenderer" )
		sheet = New Atlas( path, cellWidth, cellHeight, 0, 0, flags )
		Self.frame = frame
		quadSize = New Vec2f( quadWidth, quadHeight )
	End
	
	Method OnStart() Override
		mesh = CreateCard( frame, sheet.Coords, quadSize.X, quadSize.Y, center )
		mat =  New PbrMaterial( True, False, False )
		mat.ColorTexture = sheet.Texture
		
		model = Cast<Model>( Entity )
		model.Mesh = mesh
		model.Material = mat
	End
	
	Method OnUpdate() Override
		Local camPos := Viewer.Camera.Position
		If alignToCamera
			If stayUpright
				Entity.Ry = AngleBetween( camPos.X, camPos.Z, Entity.X, Entity.Z ) - 90
			Else
				Entity.PointAt( Viewer.Camera.Position )
				Entity.RotateY( 180 )				
			End
		End
	End
End


