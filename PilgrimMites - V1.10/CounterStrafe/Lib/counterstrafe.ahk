; http://mathhelpplanet.com/static.php?p=onlayn-mnk-i-regressionniy-analiz
SendMode Input

counterstrafe(key, counter, start)
{

	global hop
	global enable_counter
	if !hop
	{
		if(enable_counter == 1)
		if !GetKeyState("shift", "P")
		if !GetKeyState("alt", "P")
		if !GetKeyState(counter, "P")
		{

			KeyWait, %key%
			finish := A_TickCount
			Send {Blind}{%counter% down}

			movetime := (finish - start)

			loop 1
			{
				if(movetime <= 0)
					break

				if(movetime <= 200)
					maxspeed_percentage := movetime*0.2

				if(movetime > 200)
                    maxspeed_percentage := 100

                if(movetime > 400)
                    maxspeed_percentage := 120


				stop := A_TickCount + (1 * maxspeed_percentage)

				While (!GetKeyState(key, "P") && A_TickCount < stop)
			 		DllCall("Sleep", UInt, 1)
		 	}

		 	If !GetKeyState(counter, "P")
				Send {Blind}{%counter% up}
		}
	}
}
