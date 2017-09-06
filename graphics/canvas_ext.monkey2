
Namespace mojo.graphics

Class Canvas Extension

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
'   			Echo( columns + "," + rows )
			DrawPrimitives( 4, total, verts.Data, 8, uvs.Data, 8, Null, 4, img, Null )
		End
	End


'	Method DrawPatch( imgs:Image[], startX:Double, startY:Double, width:Double, height:Double )
'		If imgs
''   			DrawImage( imgs[0], startX
'		End
'	End


End
