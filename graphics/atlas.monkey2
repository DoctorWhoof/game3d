Namespace mojo3d.graphics

Class Atlas

	Protected

	Field texture:Texture
	Field coordinates:= New Stack<Rect<Double>>	'A stack containing the UV coordinates for each cell
	
	Field rows:Int								'Number of rows in the original image file
	Field columns:Int							'Number of collumns in the original image file
	Field cellWidth:Double						'The width of an individual cell (frame or tile), in pixels
	Field cellHeight:Double						'The height of an individual cell (frame or tile), in pixels
	Field padding :Double						'the gap between cells, in pixels
	Field border :Double						'the gap between the texture's edges and the cells, in pixels
	Field paddedWidth:Double					'the total width of a cell + padding, in pixels
	Field paddedHeight:Double					'the total height of a cell + padding, in pixels
	
	
	'*************************************** Public Properties ***************************************
	
	Public
	
	Property Images:Image[]()
		Local images := New Stack<Image>
		For Local n := 0 Until coordinates.Length
			Local c := coordinates[n]
			images.Push( New Image( texture, New Recti( c.Left*texture.Width, c.Top*texture.Height, c.Right*texture.Width, c.Bottom*texture.Height ) ) )
		Next
		Return images.ToArray()
	End
	
	
	Property Coords:Rect<Double>[]()
		Return coordinates.ToArray()	
	End
	
	
	Property Texture:Texture()
		Return texture
	End
	
	
	'*************************************** Public Methods ***************************************
	
	
	Method New( path:String, _cellWidth:Int, _cellHeight:Int, _padding:Int = 0, _border:Int = 0, _flags:TextureFlags = TextureFlags.FilterMipmap )
		'Loads texture, populates all fields and generates UV coordinates for each cell (frame)
		texture = Texture.Load( path, _flags )
		Assert( texture, " ~n ~nGameGraphics: Image " + path + " not found.~n ~n" )	
		Print ( "New Texture: " + path + "; " + texture.Width + "x" + texture.Height + " Pixels" )
		
		padding = _padding
		border = _border
		cellWidth = _cellWidth
		cellHeight = _cellHeight
		paddedWidth = cellWidth + ( padding * 2 )
		paddedHeight = cellHeight + ( padding * 2 )
		rows = ( texture.Height - border - border ) / paddedHeight
		columns = ( texture.Width - border - border ) / paddedWidth
		
		Local numFrames := rows * columns
		Local w:Double = texture.Width
		Local h:Double = texture.Height
		
		For Local i:= 0 Until numFrames
			Local col := i Mod columns
			Local x:Double = ( col * paddedWidth ) + padding + border
			Local y:Double = ( ( i / columns ) * paddedHeight ) + padding + border
			coordinates.Push( New Rectf( x/w, y/h, (x+cellWidth)/w, (y+cellHeight)/h ) )
		Next
		
		Print ( "New SpriteSheet: " + rows + "x" + columns )
	End


End