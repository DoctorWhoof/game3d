Namespace util

#Import "<std>"
Using std..

Class Profile
	
	Private
	Global _starts := New StringMap< Int >
	Global _results := New StringMap< Double >

	Public
	Function Start( name:String )
		If _starts.Contains( name )
			_starts.Set( name, Microsecs() )
		Else
			_starts.Add( name, Microsecs() )
		End
	End

	Function Finish:Double( name:String )
		Local result:Double
		If _starts.Contains( name )
			result = Diff( name, Microsecs() )
			If _results.Contains( name )
				_results.Set( name, result )
			Else
				_results.Add( name, result )	
			End
			
		End
		Return result
	End

	Function Get:Double( name:String )
		If _results.Contains( name )
			Return _results[ name ]
		Else
			Return Null
		End
	End

	Function GetString:String( name:String )
		If _results.Contains( name )
			Return Truncate( _results[ name ], 2 ) + " ms"
		Else
			Return ""
		End
	End

	Function Clear()
		_starts.Clear()
		_results.Clear()	
	End
	
	Private
	Function Diff:Double( name:String, value:Int )
		Return ( Double( value ) - Double( _starts[ name ] ) ) / 1000.0
	End

	Function Truncate:String( number:Double, decimals:Int = 2 )
		Local arr:String[] = String(number).Split(".")
		If arr.Length > 1
			Return arr[0] + "." + arr[1].Left( decimals )
		Else
			Return ""
		End
	End
	
End