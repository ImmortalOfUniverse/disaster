ForceForward(v) {
	csgo.write(client + dwForceForward, v, "int")
}

ForceLeft(v) {
	csgo.write(client + dwForceLeft, v, "int")
}

ForceBackward(v) {
	csgo.write(client + dwForceBackward , v, "int")
}

ForceRight(v) {
	csgo.write(client + dwForceRight, v, "int")
}

ForceJump(v) {
	csgo.write(client + dwForceJump, v, "int")
}

perfectDelta(speed) {
	static initialized := 0
	static speedVar
	static airVar 
	static wishVar
	if (!initialized) {
		speedVar := Cvar.FindFast("sv_maxspeed")
		airVar   := Cvar.FindFast("sv_airaccelerate")
		wishVar  := Cvar.FindFast("sv_air_max_wishspeed")
		if (speedVar.GetPointer() && airVar.GetPointer() && wishVar.GetPointer()) {
			initialized := 1
		}
	}

	term := wishVar.GetFloat() / airVar.GetFloat() / speedVar.GetFloat() * 100 / speed

	if (term < 1 && term > -1)
		return Acos(term)

	return 0
}


autoBhop() {
	if (!LocalPlayer.entity || !LocalPlayer.is_alive() || (LocalPlayer.moveType() = MOVETYPE_LADDER) || IsCursorShowing())
		return


	if (GetKeyState("SPACE", "P") && (csgo.read(client + dwForceJump, "int") != 6) && (LocalPlayer.flags() & FL_ONGROUND)) {
		ForceJump(6)
	}
}

;Multidirectional Auto Strafer
autoStrafe() {
	static angle := 0
	static should_fix_move_and_key := 0
	
	if (!GetKeyState("SPACE", "P") && should_fix_move_and_key) {
		cl_forwardspeed.SetFloat(450)
		cl_backspeed.SetFloat(450)
		cl_sidespeed.SetFloat(450)
		ForceForward(GetKeyState("w", "P"))
		ForceBackward(GetKeyState("s", "P"))
		ForceLeft(GetKeyState("a", "P"))
		ForceRight(GetKeyState("d", "P"))

		should_fix_move_and_key := 0
		return
	}

	if (!LocalPlayer.entity || !LocalPlayer.is_alive() || (LocalPlayer.flags() & FL_ONGROUND) || (LocalPlayer.moveType() = MOVETYPE_LADDER) || IsCursorShowing())
		return

	speed := LocalPlayer.vec_velocity().length2D()
	if (speed < 5)
		return

	if (GetKeyState("SPACE", "P")) {
		should_fix_move_and_key := 1
		ForceForward(1)
		ForceRight(1)
		ForceLeft(0) ;Make sure pressing movelefe doesn't affect auto strafe
		ForceBackward(0) ;Make sure pressing back doesn't affect auto strafe
	}

	back := GetKeyState("s", "P")
	,forward := GetKeyState("w", "P")
	,right := GetKeyState("d", "P")
	,left := GetKeyState("a", "P")

	if (back) {
		angle := -180
		if (left)
			angle -= 45
		else if (right)
			angle += 45
	}
	else if (left) {
		angle := 90
		if (back)
			angle += 45
		else if (forward)
			angle -= 45
	}
	else if (right) {
		angle := -90
		if (back)
			angle -= 45
		else if (forward)
			angle += 45
	}
	else {
		angle := 0
	}

	pDelta := perfectDelta(speed)

	if (pDelta) {
		should_fix_move_and_key := 1
		,yaw := deg2rad(LocalPlayer.vec_view_angles().y)
		,velDir := atan2(LocalPlayer.vec_velocity().y, LocalPlayer.vec_velocity().x) - yaw
		,wishAng := deg2rad(angle)
		,delta := angleDiffRad(velDir, wishAng)

		,moveDir := delta < 0 ? (velDir + pDelta) : (velDir - pDelta)

		cl_forwardspeed.SetFloat(Cos(moveDir) * 450)
		cl_sidespeed.SetFloat(-Sin(moveDir) * 450)
	}


	
}
