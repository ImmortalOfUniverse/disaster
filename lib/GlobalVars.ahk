global GLOBALVARS_T := {} ;0x24
GLOBALVARS_T.realtime          := 0x0 ;float
GLOBALVARS_T.framecount        := 0x4 ;int
GLOBALVARS_T.absoluteFrameTime := 0x8 ;float
GLOBALVARS_T.currenttime       := 0x10 ;float
GLOBALVARS_T.frametime         := 0x14 ;float
GLOBALVARS_T.maxClients        := 0x18 ;int
GLOBALVARS_T.tickCount         := 0x1C ;int
GLOBALVARS_T.intervalPerTick   := 0x20 ;float

class c_GlobalVars {
	realtime() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.realtime, "float")
	}
	framecount() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.framecount, "int")
	}
	absoluteFrameTime() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.absoluteFrameTime, "float")
	}
	currenttime() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.currenttime, "float")
	}
	frametime() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.frametime, "float")
	}
	maxClients() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.maxClients, "int")
	}
	tickCount() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.tickCount, "int")
	}
	intervalPerTick() {
		return csgo.read(engine + dwGlobalVars + GLOBALVARS_T.intervalPerTick, "int")
	}
}