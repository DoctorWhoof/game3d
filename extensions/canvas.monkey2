
Namespace mojo.graphics

Class Canvas Extension
	
	Method Draw3DLine( camera:Camera, v0:Vec3f, v1:Vec3f, offsetX:Float=0, offsetY:Float=0  )		
		Local s0 := camera.ProjectToViewport( v0 )
		Local s1 := camera.ProjectToViewport( v1 )
'		If( ( Abs(s0.X) / camera.Viewport.Width ) < 2.0  )And ( ( Abs(s0.Y) / camera.Viewport.Height ) < 2.0 )
'			If( ( Abs(s1.X) / camera.Viewport.Width ) < 2.0  )And ( ( Abs(s1.Y) / camera.Viewport.Height ) < 2.0 )
				If camera.Viewport.Contains( s0 , s1 )
					DrawLine( s0.X-offsetX, -s0.Y+offsetY, s1.X-offsetX, -s1.Y+offsetY )
				End
'			End
'		End
	End

	'Draws the same image repeatedly
	Method DrawBatch( img:Image, startX:Double, startY:Double, width:Double, height:Double, cellWidth:Float = -1, cellHeight:Float = -1 )
		If img
			Local imgWidth := img.Width
			Local imgHeight := img.Height

			If cellWidth > 0 Then imgWidth = cellWidth
			If cellHeight > 0 Then imgHeight = cellHeight

			Local columns :Int = Abs( Ceil( Float(width) / imgWidth ) )
			Local rows :Int = Abs( Ceil( Float(height) / imgHeight ) )
			Local total := columns* rows

			Local verts := New Float[ total * 8 ]
			Local uvs := New Float[ total * 8 ]

			Local uvLeft := Float( img.Rect.Left ) / img.Texture.Width
			Local uvRight := Float( img.Rect.Right ) / img.Texture.Width
			Local uvTop := Float( img.Rect.Top ) / img.Texture.Height
			Local uvBottom := Float( img.Rect.Bottom ) / img.Texture.Height

			Local i := 0
			For Local x := 0 Until columns
				For Local y := 0 Until rows

					Local left := ( x * imgWidth ) + startX
					Local top := ( y * imgHeight ) + startY
					Local right := left + imgWidth
					Local bottom := top + imgHeight

					verts[ i ] = left
					verts[ i+1 ] = top
					verts[ i+2 ] = right
					verts[ i+3 ] = top
					verts[ i+4 ] = right
					verts[ i+5 ] = bottom
					verts[ i+6 ] = left
					verts[ i+7 ] = bottom

					uvs[ i ] = uvLeft
					uvs[ i+1 ] = uvTop
					uvs[ i+2 ] = uvRight
					uvs[ i+3 ] = uvTop
					uvs[ i+4 ] = uvRight
					uvs[ i+5 ] = uvBottom
					uvs[ i+6 ] = uvLeft
					uvs[ i+7 ] = uvBottom

					i += 8
				Next
			Next
			DrawPrimitives( 4, total, verts.Data, 8, uvs.Data, 8, Null, 4, img, Null )
		End
	End

	'To do
'	Method DrawPatch( imgs:Image[], startX:Double, startY:Double, width:Double, height:Double )
'		If imgs
''   			DrawImage( imgs[0], startX
'		End
'	End

End
