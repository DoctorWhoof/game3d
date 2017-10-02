Namespace std.Json

Function VariantToString:String( v:Variant )
	Local typeName := v.Type.Name
	If v.Type.Kind = "Array"
		Select typeName
		Case "Float[]"
			Return VariantArrayToString<Float>( v )
		Case "Double[]"
			Return VariantArrayToString<Double>( v )
		Case "Int[]"
			Return VariantArrayToString<Int>( v )
		Case "String[]"
			Return VariantArrayToString<String>( v )
		Default
			Return typeName 
		End
	Else
		Select typeName
		Case "Double"
			Return String( Cast<Double>( v ) )
		Case "Float"
			Return String( Cast<Float>( v ) )
		Case "String"
			Return String( Cast<String>( v ) )
		Case "Bool"
			Local b := Cast<Bool>( v ) 
			If b
				Return "True"
			Else
				Return "False"
			End
		Case "Int"
			Return String( Cast<Int>( v ) )
		Case "UInt"
			Return String( Cast<UInt>( v ) )
		End
	End
	Return typeName
End


Function VariantArrayToString<T>:String( v:Variant )
	Assert( ( v.Type.Kind = "Array" ), "Variant " + v.Type.Name + " is not an array" )
	Local arr := Cast<T[]>( v )
	Local text := "[ "
	For Local n := 0 Until arr.Length
		text += arr[n]
		If n < arr.Length - 1
			text += ", "
		End
	Next
	text += " ]"	
	Return text
End