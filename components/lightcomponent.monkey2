Namespace game3d

Class LightComponent Extends Component
	
	Property CastsShadow:Bool()
		Return _light.CastsShadow
	Setter( c:Bool )
		_light.CastsShadow = c
	End
	
	Property Color:Float[]()
		Return _light.Color.ToArray()
	Setter( c:Float[] )
		_light.Color = std.graphics.Color.FromArray( c )
	End
	
	Property Range:Float()
		Return _light.Range
	Setter( r:Float )
		_light.Range = r
	End
	
	Property Type:UInt()
		Return UInt(_light.Type)
	Setter( t:UInt )
		Select t
		Case 1 _light.Type = LightType.Directional
		Case 2 _light.Type = LightType.Point
		Case 3 _light.Type = LightType.Spot
		End
	End
	
	Private
	Field _light:Light
	
	Public
	Method New()
		Super.New( "LightComponent" )
	End
	
	Method OnCreate() Override
		_light = New Light
		_light.Name  = "EntityLight"
		GameObject.SetEntity( _light )		
	End
End