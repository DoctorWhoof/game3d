Namespace mojo3d.graphics

Class Material Extension

	Property Name:String()
		Return MaterialLibrary.GetName( Self )
	Setter( name:String )
		MaterialLibrary.AddMaterial( name, Self )
	End

	Function Get:Material( name:String )
		Return MaterialLibrary.GetMaterial( name )
	End

'	Method ToJson:JsonObject()
'
'		Local json:= New JsonObject()
'		Local info :TypeInfo = Self.InstanceType
'
'		For Local decl:DeclInfo = Eachin info.GetDecls()	'all decls
'			If decl.Kind = "Property" And decl.Settable
'				Select decl.Type.Name
'				Case "Float", "Double"
'					json.SetNumber( decl.Name, Cast<Float>( decl.Get( Self ) ) )
'' 				Case "Color"
'' 					'Not working! Struct?
'' 					Local c := Cast<Color>( decl.Get( Self ) )
'' '					Local jValue := New JsonArray
'' '					jValue.SetNumber( 0, c.R )
'' '					jValue.SetNumber( 1, c.G )
'' '					jValue.SetNumber( 2, c.B )
'' '					jValue.SetNumber( 3, c.A )
'' '					json.SetArray( decl.Name, jValue.ToArray() )
'' '					json.SetArray( decl.Name, c.ToJson().ToArray() )
'' 				Case "mojo.graphics.Texture"
'' 					Local tName := Cast<Texture>( decl.Get( Self ) ).Name
'' 					If tName Then json.SetString( decl.Name, tName )
'				Default
''					Print "Unhandled type: " + decl.Type.Name
''					Local pInfo := decl.
'					Local objInfo:TypeInfo = TypeInfo.GetType( decl.Type.Name )
'					If objInfo
''						Local p := newObj.GetDecl( decl.Name )
''						Local v := p.Get( Self )
''						Print objInfo.Name
'						json.SetString( decl.Name, objInfo.Name )
'					End
''					For Local d:DeclInfo = Eachin v.GetDecls()
''						
''					End
'					
'				End
'			End
'		Next
'
'		Return json
'	End

End


'Struct Color Extension
'
'	Property Type:String()
'		Return "Color"
'	End
'
'	Method ToJson:JsonValue()
''		Local json := New JsonObject
'		Local jValue := New JsonArray
'		jValue.SetNumber( 0, R )
'		jValue.SetNumber( 1, G )
'		jValue.SetNumber( 2, B )
'		jValue.SetNumber( 3, A )
''		json.SetArray( "Color", jValue.ToArray() )
'		Return jValue
'	End
'
'End
