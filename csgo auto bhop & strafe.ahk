﻿#Include lib\classMemory.ahk
#Include lib\offsets.ahk
#Include lib\ConvarManager.ahk
#Include lib\GlobalVars.ahk
#Include lib\helpers.ahk
#Include lib\entity.ahk
#Include lib\hack.ahk
#Include lib\Vector.ahk
#NoEnv
#Persistent
#InstallKeybdHook
#SingleInstance, Force
SetKeyDelay,-1, -1
SetControlDelay, -1
SetMouseDelay, -1
SendMode Input
SetBatchLines, -1
ListLines, Off
SetTitleMatchMode, 2
;Process, Priority, , H

OnExit, on_exit

global game_window := "Counter-Strike: Global Offensive - Direct3D 9"



GetLocalPlayer() {
	return csgo.read(client + dwLocalPlayer, "uint")
}

GetLocalPlayerID() {
	return csgo.read(clientState + dwClientState_GetLocalPlayer, "int")
}

GetEntityByID(index) {
	return csgo.read(client + dwEntityList + index * 0x10, "Uint")
}

IsInGame() {
	Return csgo.read(clientState + dwClientState_State, "int")=6
}

GetViewMatrix() {
	csgo.readRaw(client + dwViewMatrix, matrix, 64)
	Return [NumGet(matrix, 0, "Float"), NumGet(matrix, 4, "Float"), NumGet(matrix, 8, "Float"), NumGet(matrix, 12, "Float"), NumGet(matrix, 16, "Float"), NumGet(matrix, 20, "Float"), NumGet(matrix, 24, "Float"), NumGet(matrix, 28, "Float"), NumGet(matrix, 32, "Float"), NumGet(matrix, 36, "Float"), NumGet(matrix, 40, "Float"), NumGet(matrix, 44, "Float"), NumGet(matrix, 48, "Float"), NumGet(matrix, 52, "Float"), NumGet(matrix, 56, "Float"), NumGet(matrix, 60, "Float")]
}

GetClientState() {
	csgo.read(engine + dwClientState, "uint")
}

GetMaxPlayer() {
	return csgo.read(clientState + dwClientState_MaxPlayer, "uint")
}




if (_ClassMemory.__Class != "_ClassMemory") {
    msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
    ExitApp
}

if !Get_hazedumper_offsets() {
	MsgBox, 48, Error, Failed to get csgo offsets!
    ExitApp
}


;============================ Hack Settings ============================
global blockbot_enable := 0
global blockbot_key := "q"

;============================ Main ============================
global ClosestDistance := 1024
global ClosestEntity := 0
global Finish

global csgo
global client
global engine
global clientState
global vstdlib
;global materialsystem := csgo.getModuleBaseAddress("materialsystem.dll")
global Cvar
global InGame
global LocalPlayer



csgo := new _ClassMemory(game_window)
client := csgo.getModuleBaseAddress("client.dll")
engine := csgo.getModuleBaseAddress("engine.dll")
vstdlib := csgo.getModuleBaseAddress("vstdlib.dll")
clientState := csgo.read(engine + dwClientState, "Uint")


Cvar := new ConvarManager()
global cl_forwardspeed := Cvar.FindFast("cl_forwardspeed")
global cl_sidespeed := Cvar.FindFast("cl_sidespeed")



cl_showpos := Cvar.FindFast("cl_showpos")
cl_showpos.SetInt(1)


;DllCall("QueryPerformanceFrequency", "Int64*", freq)


Loop {
	;DllCall("QueryPerformanceCounter", "Int64*", before)
	InGame := IsInGame()
	,LocalPlayer := new c_Entity(GetLocalPlayer(), 2)
	,GlobalVar := new c_GlobalVars()

	if (LocalPlayer.entity && InGame) {


		autoBhop()
		autoStrafe()

	}
	;DllCall("QueryPerformanceCounter", "Int64*", after)
	;msgbox % LocalPlayer.entity . " " (after-before)/freq*1000
	;sleep, 1
}




on_exit:
cl_forwardspeed.SetFloat(450)
cl_sidespeed.SetFloat(450)
ForceForward(0)
ForceRight(0)
exitApp
return











