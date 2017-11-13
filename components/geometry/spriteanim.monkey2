Namespace game3d


Class SpriteAnim Extends Component
	
	Field path :String				'Path to texture file
	Field animationPath: String		'Path to json animations file
	Field defaultAnimation: String 
	
	Field cellWidth:Int
	Field cellHeight:Int
	Field padding:Int = 0
	Field border:Int = 0
	Field flags:UInt

	Protected
	
	Field _sprite:Sprite
	
	'Event functions
	Field _onLastFrame :Void()
	Field _onFirstFrame :Void()
	
	'Atlas values
	Field _frame:Int = 0									'The frame currently displayed
	Field _coordinates:= New Stack<Rect<Double>>			'A stack containing the UV coordinates for each cell

	'Animation clip management
	Field _timeScale := 1.0									'Adjusts playback speed. Can be used to create slow motion effects without changing the framerate.
	Field _anim :AnimationClip								'The animation clip currently playing
	Field _animations := New StringMap< AnimationClip >		'List of available animation clips
	Field _offset :Int										'Current frame offset
	Field _framerate:Double	= 15.0							'Frame rate, if a clip is not provided

	'Misc
	Field _firstFrame := True
	Field _hasReachedEnd := False
	Field _hasReachedStart := False
	
	'******************************* Public Properties *******************************
	Public
	
	'Current frame
	Property Frame:Int()		
		Return _frame
	Setter( number:Int )
		If number <> _frame
			_frame = Clamp( number, 0, _coordinates.Length-1 )
			_sprite.TextureRect = _coordinates[ _frame ]
			If _frame >= LastFrame
				If Not _hasReachedEnd
					_onLastFrame()
					_hasReachedEnd = True
					_hasReachedStart = False
				End		
			End
			If _firstFrame
				_onFirstFrame()
				_firstFrame = False
			Else
				If _frame = FirstFrame
					If Not _hasReachedStart
						_onFirstFrame()
						_hasReachedStart = True
						_hasReachedEnd = False
					End		
				End		
			End
		End
	End
	
	
	'current AnimationClip
	Property Animation:String()
		If _anim Return _anim.name
		Return ""
	Setter( name:String )
		If _animations[ name ]
			_anim = _animations[ name ]
		Else
			Print( "AnimSprite: animation '" + name + "' Not found!" )
		End
	End
	
	
	'Map with all animations as values and their names as keys
	Property AllAnimations:StringMap< AnimationClip >()
		Return _animations
	End
	
	
	'Offsets the current frame, useful when creating multiple copies of the same sprite
	Property FrameOffset:Int()
		Return _offset
	Setter( number:Int )
		_offset = number
	End
	
	
	'Sets the default frame rate. If a clip is in use, that clip's frame rate will be returned.
	Property FrameRate:Double()
		If _anim
			Return _anim.framerate
		Else
			Return _framerate
		End
	Setter( value:Double )
		If _anim
			_anim.framerate = value
		Else
			_framerate = value
		End
	End
	
	
	'Duration (in seconds) of the current animation clip. If none, duration of the entire spritesheet is provided.
	Property Duration:Double()
		Local _period:Double = ( 1.0 / FrameRate ) * _timeScale
		If _anim
			Return _period * _anim.frames.Length
		Else
			Return _period * _coordinates.Length
		End
	End

	
	'First frame in clip
	Property FirstFrame:Int()
		If _anim
			Return _anim.frames[ 0 ]
		Else
			Return 0
		End	
	End
	
	
	'Last frame in clip
	Property LastFrame:Int()
		If _anim
			Return _anim.frames[ _anim.frames.Length-1 ]
		Else
			Return _coordinates.Length - 1
		End	
	End
	
	
	'******************************* Public Methods *******************************
	
	Method New()
		Super.New( "SpriteAnim" )
	End
	
	
	Method OnAttach() Override
		LoadSprite( path, cellWidth, cellHeight, padding, border, IntFlags( flags ) )
		Assert( _sprite, "SpriteAnim: Load fail" )
		Load( animationPath )
		Animation = defaultAnimation
		GameObject.SetEntity( _sprite )	
	End
	
	
	Method LoadSprite( path:String, cellWidth:Int, cellHeight:Int, padding:Int = 0, border:Int = 0, flags:TextureFlags = TextureFlags.FilterMipmap )
		'Creates new Sprite with material
		Local mat := SpriteMaterial.Load( path, flags )
		_sprite = New Sprite( mat )
		
		Local texture := mat.ColorTexture
		Assert( texture, "SpriteAnim: Load fail" )
		
		Local _paddedWidth:Double = cellWidth + ( padding * 2 )
		Local _paddedHeight:Double = cellHeight + ( padding * 2 )
		Local _rows:Int = ( texture.Height - border - border ) / _paddedHeight
		Local _columns:Int = ( texture.Width - border - border ) / _paddedWidth
		'Generates UV coordinates for each frame
		Local numFrames := _rows * _columns
		Local w:Double = texture.Width
		Local h:Double = texture.Height
		For Local i:= 0 Until numFrames
			Local col := i Mod _columns
			Local x:Double = ( col * _paddedWidth ) + padding + border
			Local y:Double = ( ( i / _columns ) * _paddedHeight ) + padding + border
			_coordinates.Push( New Rectf( x/w, y/h, (x+cellWidth)/w, (y+cellHeight)/h ) )
		Next
		'Defaults to frame 0
		Self.Frame = 0
		Self.cellWidth = cellWidth
		Self.cellHeight = cellHeight
		Self.padding = padding
		Self.border = border
		Self.flags = UInt( flags )
	End
	
	
	'Update time is in seconds (Double), not milliseconds
	Method OnUpdate() Override
		Local time := Time
		Local frameLength:Double = ( 1.0 / FrameRate ) / _timeScale
		time += ( _offset * frameLength )
		
		If _anim
			If _anim.loop
				Frame = _anim.frames[ Int( ( time Mod Duration ) / frameLength ) ]
			Else
				Frame = _anim.frames[ Int( time / frameLength ) ]
			End
		Else
			Frame = Int( ( time Mod Duration ) /frameLength )
		End
	End
	
	
	'Adds new animation clips.
	Method AddAnimationClip( _name:String, _loop:Bool = True, framerate:Int, _frames:Int[] )
		local animClip := New AnimationClip
		animClip.name = _name
		animClip.loop = _loop
		animClip.frames = _frames
		animClip.framerate = framerate
		_animations.Add( _name, animClip )
'		Print( "SpriteAnim: Added animation " + _name )
	End
	
	'Loads Json file
	Method Load( path:String )
		Local json := JsonObject.Load( path )
		If json
			Local anims := json.GetObject( "animations" )
			If anims
				For Local a := Eachin anims.ToObject()
					Local obj := a.Value.ToObject()
					Local loop := obj[ "loop" ].ToBool()
					Local rate := obj[ "rate" ].ToNumber()

					Local frameStack := obj[ "frames" ].ToArray()
					Local frames:Int[] = New Int[ frameStack.Length ]
					For Local n := 0 Until frameStack.Length
						frames[n] = frameStack[n].ToNumber()
					Next
					AddAnimationClip( a.Key, loop, rate, frames )
				Next
			End
		Else
			Print( "AnimSprite: Warning, json file not found or invalid" )
		End
	End
	
End


'**************************************************************************************************************************************'


Class AnimationClip						'AnimationClips contain a sequence of frames to be played, its name, framerate and loop state.
	
	field name			:String			'Animation name
	field loop			:= True			'looping can be controlled per animation
	field frames 		:Int[]			'Frame list array, contains the sequence in which the frames play
	Field framerate		:= 15.0			'frame rate per clip

	Property FrameCount:Int()
		Return frames.Length
	End
	
End
