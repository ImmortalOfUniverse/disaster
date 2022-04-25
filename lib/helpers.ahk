IsCursorShowing() {
	VarSetCapacity(ci, A_PtrSize+16)
	NumPut(A_PtrSize+16, ci, "uint")
	DllCall("GetCursorInfo", "ptr", &ci)
	return NumGet(ci, 0x4, "int")
}

DotProduct(a, b) {
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
}

crossProduct(a, b) {
	return [a[2]*b[3]-a[3]*b[2], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-a[2]*b[1]]
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
