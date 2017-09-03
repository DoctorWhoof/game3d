Namespace player

'This player class depends on GameOven for entity access

Class AIPlayer Extends Player

	Const idle := 0
	Const alert := 1
	Const chase := 2
	Const search := 3
	Const returnToBase := 4

	Field entity			:Entity

	Field targets := New Stack< Entity >
	Field base :Vec2<Double>

	Field state := 0		'idle by default'

	Field alertDistance:Double
	Field fightDistance:Double
	Field giveUpDistance:Double

	Field searchDuration:= 1.0
	Field allowHorizontal := True
	Field allowVertical := True

	Protected
	Field currentTarget :Entity
	Field searchStart:Double

	Public
	Method New( name:String, target:Entity )
		Super.New( name )
		If target Then AddTarget( target )
	End
	

	Method AddTarget( target:Entity )
		If target <> Null Then targets.Push( target )
	End
	

	Method OnUpdate() Override
		'Select target
		If targets.Empty Then Return
		If entity.Time > 1.0	'Waits for at least one second before doing anything
			Select state
				'************************************************************************************************************
				Case idle
					' Echo( entity.Name + ": Idle" )
					If fightDistance
						For local t := Eachin targets
							Local distance := t.transform.WorldPosition.Distance( entity.transform.WorldPosition )
							If distance < fightDistance
								If currentTarget
									If distance < t.transform.WorldPosition.Distance( currentTarget.transform.WorldPosition )
										currentTarget = t
									End
								Else
									currentTarget = t
								End
							End
							If currentTarget
								state = chase
								' base = entity.transform.WorldPosition
							End
						Next
					End
				'************************************************************************************************************
				Case alert
'					Echo( entity.Name + ": Alert" )
				'************************************************************************************************************
				Case chase
'					Echo( entity.Name + ": Chase" )
					Local pos := entity.transform.WorldPosition
					Local targetPos := currentTarget.transform.WorldPosition
					If targetPos.X > pos.X + 1
						IssueCommand( "Right" )
					ElseIf targetPos.X < pos.X - 1
						IssueCommand( "Left" )
					End
					If targetPos.Y > pos.Y + 1
						IssueCommand( "Down" )
					ElseIf targetPos.Y < pos.Y - 1
						IssueCommand( "Up" )
					End
					If giveUpDistance
						Local distance := currentTarget.transform.WorldPosition.Distance( entity.transform.WorldPosition )
						If distance > giveUpDistance
							state = search
							searchStart = entity.Time
						End
					End
				'************************************************************************************************************
				Case search
'					Echo( entity.Name + ": Search" )
					If entity.Time - searchStart >= searchDuration
						state = returnToBase
					End
					'To do:
					'Similar to alert
					'Search distance checking goes here. Should be 1.5x longer than fightDistance
				'************************************************************************************************************
				Case returnToBase
'					Echo( entity.Name + ": ReturnToBase" )
					' If base <> Null
					'
					' Else
						state = idle
						currentTarget = Null
					' End
				'************************************************************************************************************
				Default
			End
		End
	End

End
