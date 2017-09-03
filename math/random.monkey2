Namespace math

'*********************** Random functions ***********************

Function RandomChance:Bool( chance:Double ) 
	If Rnd( 0.0, 1.0 ) <= chance Then Return True
	Return False
End


Function RandomPick:Int( choices:Int[] )
	Return choices[ Round( Rnd( 0.0, 1.0 ) * ( choices.Length - 1.0) ) ]
End


Function RandomPick:Double( choices:Double[], chances:Double[] )
	'Each chance should be a number between 0 and 1.0
	'All chances should add up to 1.0.
	'Example: RandomPick( [1,2,3], [0.2, 0.5, 0.3])
	local totalChance:Double = 0.0
	For local n := 0 Until choices.Length
		totalChance += chances[n]
		local random :Double = Rnd( 0.0, 1.0 )
		If random <= totalChance
			Return choices[n]
		End
	End
	Return choices[ choices.Length - 1 ]
End