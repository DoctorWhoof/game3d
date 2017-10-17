Namespace game3d

'Known bug: only works properly in letterbox layout

Class WireframeRenderer Extends Component
	
	Field color:Color = Color.Green
	
	Private
	Field _model :Model
	Field _mesh :Mesh
	Field _vertices :Vertex3f[]
	Field _indices :UInt[]
	
	Public
	Method New()
		Super.New( "WireframeRenderer" )
	End
	
	
	Method OnAttach() Override
		_model = Cast<Model>( GameObject.Entity )
		If _model
			_mesh = _model.Mesh
			_vertices = _model.Mesh.GetVertices()
			_indices = _model.Mesh.GetAllIndices()
		Else
			Print( "WireframeRenderer: Error, GameObject needs a 'Model' entity")
		End
	End
	
	
	Method OnDraw( canvas:Canvas ) Override
		
		If _mesh
			Local matrix := _model.Matrix
			
			For Local n := 0 Until _indices.Length - 1 Step 3
				Local v0 := matrix * _vertices[_indices[n]].position 
				Local v1 := matrix * _vertices[_indices[n+1]].position
				Local v2 := matrix * _vertices[_indices[n+2]].position
				
				Local offsetX := canvas.Viewport.Width/2.0
				Local offsetY := canvas.Viewport.Height/2.0
				
				canvas.Color = color
				canvas.Draw3DLine( Camera, v0, v1, offsetX, offsetY )
				canvas.Draw3DLine( Camera, v1, v2, offsetX, offsetY )
			Next
		End
		
	End
End