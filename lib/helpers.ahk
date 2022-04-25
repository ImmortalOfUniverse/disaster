





IsCursorShowing() {
	VarSetCapacity(ci, A_PtrSize+16)
	NumPut(A_PtrSize+16, ci, "uint")
	DllCall("GetCursorInfo", "ptr", &ci)
	return NumGet(ci, 0x4, "int")
}

GetClientRect(hwnd) {
	VarSetCapacity(struct_rc, 16)
    DllCall("GetClientRect", "Uint", hwnd, "ptr", &struct_rc)
    return [NumGet(struct_rc, 0x0, "int"), NumGet(struct_rc, 0x4, "int"), NumGet(struct_rc, 0x8, "int"), NumGet(struct_rc, 0xC, "int")]
}

WorldToScreen(pos, Byref screenpos, matrix) {
	clipCoords := {}
	clipCoords.x := pos[1]*matrix[1]  + pos[2]*matrix[2]  + pos[3]*matrix[3]  + matrix[4]
	,clipCoords.y := pos[1]*matrix[5]  + pos[2]*matrix[6]  + pos[3]*matrix[7]  + matrix[8]
	;,clipCoords.z := pos[1]*matrix[9]  + pos[2]*matrix[10] + pos[3]*matrix[11] + matrix[12]
	,clipCoords.w := pos[1]*matrix[13] + pos[2]*matrix[14] + pos[3]*matrix[15] + matrix[16]
	if (clipCoords.w < 0.1) {
        return false
	}
	screenpos[1] := (windowWidth>>1)*(clipCoords.x/clipCoords.w) + (clipCoords.x/clipCoords.w) + (windowWidth>>1)
	,screenpos[2] := -(windowHeight>>1)*(clipCoords.y/clipCoords.w) + (clipCoords.y/clipCoords.w) + (windowHeight>>1)
	return true
}

VectorTransform(Vector, matrix) {
	return [DotProduct(Vector, [matrix[1], matrix[2], matrix[3]]) + matrix[4], DotProduct(Vector, [matrix[5], matrix[6], matrix[7]]) + matrix[8], DotProduct(Vector, [matrix[9], matrix[10], matrix[11]]) + matrix[12]]
}

;fromAngle2D(angle) {
;    return [cos(deg2rad(angle)), sin(deg2rad(angle))]
;}

DotProduct(a, b) {
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
}

crossProduct(a, b) {
	return [a[2]*b[3]-a[3]*b[2], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-a[2]*b[1]]
}

SplitRGBColor(RGBColor, ByRef Red, ByRef Green, ByRef Blue) {
    Red    := RGBColor >> 16 & 0xFF
    ,Green := RGBColor >> 8 & 0xFF
    ,Blue  := RGBColor & 0xFF
}

SplitARGBColor(ARGBColor, ByRef Alpha, ByRef Red, ByRef Green, ByRef Blue) {
	Alpha := ARGBColor >> 24 & 0xFF
    ,Red    := ARGBColor >> 16 & 0xFF
    ,Green := ARGBColor >> 8 & 0xFF
    ,Blue  := ARGBColor & 0xFF
}

remainder(a, b) {
	rquot := Round(a/b)
	return a - rquot * b
}

normalizeRad(a) {
	return a != "" ? remainder(a, 4*ATan(1) * 2) : 0
}

angleDiffRad(a1, a2) {
	delta := normalizeRad(a1 - a2)
	if (a1 > a2)
	{
		if (delta >= 4*ATan(1))
			delta -= 4*ATan(1) * 2
	}
	else {
		if (delta <= -4*ATan(1))
			delta += 4*ATan(1) * 2
	}
	return delta
}

deg2rad(degrees) {
    return degrees * ((4*ATan(1)) / 180)
}

rad2deg(radians) {
    return radians * (180 / (4*ATan(1)))
}

add3(a, b) {
	return [a[1]+b[1], a[2]+b[2], a[3]+b[3]]
}

sub3(a, b) {
	return [b[1]-a[1], b[2]-a[2], b[3]-a[3]]
}

hypot(d) {
	return Sqrt(d[1]**2 + d[2]**2 + d[3]**2)
}

dist(a, b) {
	return Sqrt((b[1]-a[1])**2 + (b[2]-a[2])**2 + (b[3]-a[3])**2)
}

length2D(a) {
	return Sqrt(a[1]**2 + a[2]**2)
}

atan2(y, x) {
	static atan2_func := DllCall("GetProcAddress", "Ptr", DllCall("LoadLibrary", "Str", "msvcrt.dll", "Ptr"), "AStr", "atan2", "Ptr")
	return dllcall(atan2_func, "Double", y, "Double", x, "CDECL Double")
}

atan2f(y, x) {
	static atan2f_func := DllCall("GetProcAddress", "Ptr", DllCall("LoadLibrary", "Str", "msvcrt.dll", "Ptr"), "AStr", "atan2f", "Ptr")
	return dllcall(atan2f_func, "float", y, "float", x, "CDECL float")
}

normalizeYaw(yaw) {
	if (yaw >= -180 && yaw <= 180)
	    return yaw

	rot := round(Abs(yaw / 360))

	,yaw := (yaw < 0) ? yaw + (360 * rot) : yaw - (360 * rot)
    return yaw
}


AngleFromCrosshair(a, b) {
	ViewAngles := LocalPlayer.view_angles()
	,delta := sub3(a, b)
	,hyp   := hypot(delta)
	,pitch := rad2deg(asin(delta[3]/hyp)) - ViewAngles[1]
	,yaw   := rad2deg(atan(delta[2]/delta[1])) + (delta[1]>=0 ? 180:0) - ViewAngles[2]
	while (yaw < -180) {
		yaw += 360
	}
	while (yaw > 180) {
		yaw -= 360
	}
	return Sqrt(pitch**2 + yaw**2)
}

ExecuteConsoleCommand(ByRef str) {
	vSize := StrPut(str, "UTF-8")
	VarSetCapacity(m_pCommand, vSize)
	StrPut(str, &m_pCommand, vSize, "UTF-8")
	VarSetCapacity(COPYDATASTRUCT, 0x24, 0)
	NumPut(0, COPYDATASTRUCT, 0x0, "ptr")
	NumPut(vSize + 1, COPYDATASTRUCT, 0x8, "ptr")
	NumPut(&m_pCommand, COPYDATASTRUCT, 0x10, "ptr")
	SendMessage, 0x004A,, &COPYDATASTRUCT,, Counter-Strike: Global Offensive - Direct3D 9
}
