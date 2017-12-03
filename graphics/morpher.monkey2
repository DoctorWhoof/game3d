Namespace mojo3d

Class Morpher Extends Renderable
	
	Field amount:Float
	Field material:Material
	
	Private
	
	Field _vertices0:Vertex3f[]
	Field _vertices1:Vertex3f[]
	Field _vbuffer:VertexBuffer
	Field _ibuffer:IndexBuffer
	Field _nvertices:Int

	Public

	Method New( mesh0:Mesh, mesh1:Mesh , parent:Entity = Null )
		Super.New( parent )
		'get mesh vertices - don't need entire meshes	
		_vertices0=mesh0.GetVertices()
		_vertices1=mesh1.GetVertices()
		'create vertexbuffer
		_vbuffer=New VertexBuffer( Vertex3f.Format,_vertices0.Length )
		'create and initilize indexbuffer
		Local indices:=mesh0.GetIndices( 0 )
		_ibuffer=New IndexBuffer( IndexFormat.UINT32,indices.Length )
		_ibuffer.SetIndices( indices.Data,0,indices.Length )
		
		Visible=true
	End
	
	Protected
	
	Method OnRender( rq:RenderQueue ) Override
		Assert( material, "Morpher: No material assigned!")
		'lock vertex buffer
		Local vp:=Cast<Vertex3f Ptr>( _vbuffer.Lock() )
		For Local i:=0 Until _vbuffer.Length
			Local v:=_vertices0[i]
			'interpolate position			
			v.position=_vertices0[i].position.Blend( _vertices1[i].position,amount )
			'interpolate normal
			v.normal=_vertices0[i].normal.Blend( _vertices1[i].normal,amount ).Normalize()
			vp[i]=v
		Next
		'invalidate all vertices
		_vbuffer.Invalidate()
		'unlock vertices
		_vbuffer.Unlock()
		'add renderop
		rq.AddRenderOp( material,Self,_vbuffer,_ibuffer,3,_ibuffer.Length/3,0 )
	End
End
