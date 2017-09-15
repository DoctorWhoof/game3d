Namespace clock

#Import "<std>"
Using std..

Class Clock

	Global scale:Double = 1.0		'Set this to slow down or speed up time
	Global frameRate:Double = 60.0	'Desired "ideal" frame rate. Affects delta calculation, does not actually affect rendering frame rate
	
	Global deltaStyle:Int = 0		'fixed, per frame or per second
	Const fixed := 0
	Const perFrame := 1
	Const perSecond := 2

	Private
	Global _now:Double				'The current time, in seconds
	Global _last:Int				'Used to get the time elapsed since the last frame
	Global _paused:Bool				'Current pause state
	
	Global _fps	:= 60				'fps counter
	Global _fpscount := 0.0			'temporary fps counter
	Global _tick := 0				'Only stores the current time once every second
	Global _delta:Double			'holds Delta timing (using a 60fps frame rate as reference)
	
	'********************** Functions **********************
	Public
	
	Function Now:Double()
		Return _now
	End


	Function Update()
		'Main time advance
		_delta = ( Microsecs() - _last ) / ( 1000000.0 / scale )
		If Not _paused
			_now += _delta
		End
		
		'Basic fps counter
		If Microsecs() - _tick > 1008000
			_fps = _fpscount
			_tick = Microsecs()
			_fpscount=0
		Else
			_fpscount +=1
		End
		
		'Stores current app time
		_last = Microsecs()
	End


	Function Reset()
		_now = 0.0
		_delta = 1.0 / frameRate
		_paused = False
		_last = Microsecs()
	End
	
	
	Function Pause( state:Bool )
		_paused = state
	End
	
	
	Function Delta:Double()
		Select deltaStyle
			Case perFrame
				Return _delta / ( 1.0 / frameRate )
			Case perSecond
				Return ( _fps / frameRate ) * scale
		End
		Return 1.0
	End
	
	
	Function FPS:Int()
		Return _fps
	End
	
End