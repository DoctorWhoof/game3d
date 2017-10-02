Namespace game3d

Class LightComponent Extends Component
	
	Property CastsShadow:Bool()
		Return _light.CastsShadow
	Setter( c:Bool )
		_light.CastsShadow = c
	End
	
	Property Color:Double[]()
		Return _light.Color.ToArray()
	Setter( c:Double[] )
		_light.Color = std.graphics.Color.FromArray( c )
	End
	
	Property Range:Double()
		Return _light.Range
	Setter( r:Double )
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
		_light = New Light
		_light.Name  = "EntityLight"
	End
	
	Method OnCreate() Override
		GameObject.SetEntity( _light )
	End
End