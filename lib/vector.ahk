;#Include helpers.ahk
;#SingleInstance, Force ;debug

class Vector {
	__New(array) {
		this.x  := array[1]
		,this.y := array[2]
		,this.z := array[3] = "" ? 0 : array[3]
		;,this.pitch := array[1]
		;,this.yaw   := array[2]
		;,this.roll  := array[3] = "" ? 0 : array[3]
	}

	static up      := new Vector([ 0,  0,  1])
	static down    := new Vector([ 0,  0, -1])
	static forward := new Vector([ 1,  0,  0])
	static back    := new Vector([-1,  0,  0])
	static left    := new Vector([ 0,  1,  0])
	static right   := new Vector([ 0, -1,  0])

	test_func() {
		return Vector.x
	}

	sub(v) {
		return new Vector([this.x-v.x, this.y-v.y, this.z-v.z])
	}

	length() {
		return Sqrt(this.x*this.x + this.y*this.y + this.z*this.z)
	}

	length2D() {
		return Sqrt(this.x*this.x + this.y*this.y)
	}

	snapTo4() {
		l := this.length2D()
		,xp := this.x >= 0
		,yp := this.y >= 0
		,xy := Abs(this.x) >= Abs(this.y)
		if (xp && xy)
			return new Vector([l, 0, 0])
		if (!xp && xy)
			return new Vector([-l, 0, 0])
		if (yp && !xy)
			return new Vector([0, l, 0])
		if (!yp && !xy)
			return new Vector([0, -l, 0])

		return new Vector([0, 0, 0])
	}


	dotProduct2D(v) {
		return this.x * v.x + this.y * v.y
	}

	crossProduct(v) {
		return new Vector([this.y * v.z - this.z * v.y, this.z * v.x - this.x * v.z, this.x * v.y - this.y * v.x])
	}

	distTo(v) {
		return this.sub(v).length()
	}
	

}

fromAngle2D(angle) {
    return new Vector([cos(deg2rad(angle)), sin(deg2rad(angle)), 0])
}

test2() {
	return Vector.x
}


/*
test_v := new Vector([3, 4, 5])
lmao := new Vector([0, 0, 0])
v2test := new Vector([3, 4])
*/
;msgbox % v2test.z ;test_v.distTo(lmao)