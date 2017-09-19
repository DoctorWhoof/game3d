
Namespace game3d


Class LoadPbrMaterial Extends Component
	
	Field metalness:Float
	Field roughness:Float
	
	Field color:Float[]
	Field colorTexture:String
	
	Field emissive:Float[]
	Field emissiveTexture:String
	
	Field filter:= True
	
	Private
	Field IAMPRIVATE:String
	Field dontShowMe:Float
	
	Public
	Method New( color:Color, metalness:Float, roughness:Float, emissive:Color = Null, colorTexture:String = Null, emissiveTexture:String = Null )
		Super.New( "LoadPbrMaterial" )
		
		Self.metalness = metalness
		Self.roughness = roughness
		Self.color = New Float[]( color.R, color.G, color.B )
		Self.colorTexture = colorTexture
		Self.emissive = New Float[]( emissive.R, emissive.G, emissive.B )
		Self.emissiveTexture = emissiveTexture
	End
	
	Method OnStart() Override
		Local model := Cast<Model>( Entity )
		Assert( model, "LoadModel: Entity needs to be of 'Model' class" )
		
		Local textured:= False
		If( colorTexture Or emissiveTexture )Then textured = True
		
		Local pbr := New PbrMaterial( True, False, False )
		pbr.RoughnessFactor = roughness
		pbr.MetalnessFactor = metalness
		pbr.ColorFactor = New Color( color[0], color[1], color[2] )
		pbr.EmissiveFactor = New Color( emissive[0], emissive[1], emissive[2] )
		If textured
			pbr.ColorTexture = Texture.Load( colorTexture, filter? TextureFlags.FilterMipmap Else Null )
			pbr.EmissiveTexture = Texture.Load( colorTexture, filter? TextureFlags.FilterMipmap Else Null )
		End
		
		model.Materials = New Material[]( pbr )
	End
	
End
