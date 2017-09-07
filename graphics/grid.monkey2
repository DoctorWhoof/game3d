Namespace mojo3d.graphics

Function CreateGrid:Mesh( width:Double, height:Double, columns:Int, rows:Int, quadMap:Bool = False, center:Vec2f = New Vec2f(0.5, 0.5 ) )
	If columns < 1 Then columns = 1
	If rows < 1 Then rows = 1
	
	Local i := -1
	Local verts := New Stack<Vertex3f>
	Local faces := New Stack<UInt>
	
	Local cellWidth := width / columns
	Local cellHeight := height / rows
	
	For Local y := 0 Until rows
		For Local x := 0 Until columns
			
			'Create each quad
			Local startX := x*cellWidth - ( width*center.X )
			Local startY := y*cellHeight - ( height*center.Y )
			
			Local s0 := 0.0
			Local s1 := 1.0
			Local t0 := 1.0
			Local t1 := 0.0
			If Not quadMap
				s0 = Double(x)/Double( columns )
				s1 = Double(x+1)/Double( columns )
				t0 = Double(rows-y)/Double( rows )
				t1 = Double(rows-y-1)/Double( rows )
			End
			
			verts.Push( New Vertex3f( startX, startY, 0, s0, t0, 0, 0, -1 ) )							'TL
			verts.Push( New Vertex3f( startX + cellWidth, startY, 0, s1, t0, 0, 0, -1  ) )				'TR
			verts.Push( New Vertex3f( startX + cellWidth, startY + cellHeight, 0, s1, t1, 0, 0, -1 ) )	'BR
			verts.Push( New Vertex3f( startX, startY + cellHeight, 0, s0, t1, 0 ,0, -1 ) )				'BL

			faces.Push( i+4 )
			faces.Push( i+3 )
			faces.Push( i+1 )
			faces.Push( i+3 )
			faces.Push( i+2 )
			faces.Push( i+1 )
			i += 4
		Next
	Next
 
	Local data := New Mesh( verts.ToArray(), faces.ToArray() )
	data.UpdateTangents()
	Return data
End


Function CreateTileMap:Mesh( map:Int[,], atlasCoordinates:Rect<Double>[], mapCols:Int, mapRows:Int, quadWidth:Float, quadHeight:Float, center:Vec2f = New Vec2f(0.5, 0.5 ) )
	Local i := -1
	Local verts := New Stack<Vertex3f>
	Local faces := New Stack<UInt>
	
	Local width := quadWidth * mapCols
	Local height := quadHeight * mapRows
			
	For Local y := 0 Until mapRows
		For Local x := 0 Until mapCols
			'Create each quad
			Local startX := x*quadWidth - ( width*center.X )
			Local startY := height-(y*quadHeight) - ( height*center.Y )	'y coordinates are reversed (up is positive)
			Local n := map[x,y]
			Local s0 := atlasCoordinates[n].Left
			Local s1 := atlasCoordinates[n].Right
			Local t0 := atlasCoordinates[n].Top
			Local t1 := atlasCoordinates[n].Bottom
			
			verts.Push( New Vertex3f( startX, startY, 0, s0, t0, 0, 0, -1 ) )
			verts.Push( New Vertex3f( startX + quadWidth, startY, 0, s1, t0, 0, 0, -1  ) )
			verts.Push( New Vertex3f( startX + quadWidth, startY - quadHeight, 0, s1, t1, 0, 0, -1 ) )
			verts.Push( New Vertex3f( startX, startY - quadHeight, 0, s0, t1, 0 ,0, -1 ) )

			faces.Push( i+1 )
			faces.Push( i+2 )
			faces.Push( i+3 )
			faces.Push( i+1 )
			faces.Push( i+3 )
			faces.Push( i+4 )
			i += 4
		Next
	Next
 
	Local data:= New Mesh( verts.ToArray(), faces.ToArray() )
	data.UpdateTangents()
	Print( "New TileMap Mesh: " + mapCols + "x" + mapRows )
	Return data
End


Function LoadTileMap:Mesh( path:String, atlasCoordinates:Rect<Double>[], quadWidth:Float, quadHeight:Float, center:Vec2f = New Vec2f(0.5, 0.5 ) )
	'Uses Pyxel's txt format
	Local tileData := ""
	Local lines := LoadString( path ).Split( "~n" )
	Local mapRows :Int
	Local mapColumns:Int
'	Local cellWidth:Float
'	Local cellHeight:Float
	
	'Parse txt file
	For Local l := Eachin lines
		Local temp := l.Split( " " )	'splits the line into a command and an argument ( temp[0] and temp[1] )
		Select temp[0]
		Case "tileswide"
			mapRows = Cast<Int>( temp[1] )
		Case "tileshigh"
			mapColumns = Cast<Int>( temp[1] )
		Case "tilewidth"
'			cellWidth = Cast<Int>( temp[1] )
		Case "tileheight"
'			cellHeight = Cast<Int>( temp[1] )
		Case "layer"
			'Ignore for now
		Default
			tileData += temp[0]		'If there's no recognisable command, use it as simple tile data
		End
	Next
	
	'Populate array
	Local data := tileData.Split( "," )	
	Local map:= New Int[ mapRows, mapColumns ]
	Local row := 0
	Local col := 0
	For Local value := Eachin data
		map[ col, row ] = Cast<Int>( value )
		col += 1
		If col = mapColumns
			col = 0
			row += 1
		End
		If row = mapRows Then Exit
	Next
	
	'Generate mesh
	Return CreateTileMap( map, atlasCoordinates, mapColumns, mapRows, quadWidth, quadHeight, center )
End


Function CreateCard:Mesh( frame:Int, atlasCoordinates:Rect<Double>[], quadWidth:Float, quadHeight:Float, center:Vec2f = New Vec2f(0.5, 0.5 ) )
	Local startX := -quadWidth*center.X
	Local startY := quadHeight*center.Y
	Local s0 := atlasCoordinates[frame].Left
	Local s1 := atlasCoordinates[frame].Right
	Local t0 := atlasCoordinates[frame].Top
	Local t1 := atlasCoordinates[frame].Bottom

	Local data:= New Mesh( 
		New Vertex3f[](
			New Vertex3f( startX, startY, 0, s0, t0, 0, 0, -1 ),
			New Vertex3f( startX + quadWidth, startY, 0, s1, t0, 0, 0, -1  ),
			New Vertex3f( startX + quadWidth, startY - quadHeight, 0, s1, t1, 0, 0, -1 ),
			New Vertex3f( startX, startY - quadHeight, 0, s0, t1, 0 ,0, -1 ) ),
		New UInt[](
			0,1,2,
			0,2,3 ) )
	
	data.UpdateTangents()
	Return data
End
