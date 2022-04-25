global ClassId := {}
ClassId.AK47 := 1
ClassId.BaseAnimating := 2
ClassId.GrenadeProjectile := 9
ClassId.WeaponWorldModel := 23
ClassId.BreachCharge := 28
ClassId.BreachChargeProjectile := 29
ClassId.BumpMine := 32
ClassId.BumpMineProjectile := 33
ClassId.C4 := 34
ClassId.Chicken := 36
ClassId.Player := 40
ClassId.PlayerResource := 41
ClassId.Ragdoll := 42
ClassId.Deagle := 46
ClassId.DecoyGrenade := 47
ClassId.DecoyProjectile := 48
ClassId.Drone := 49
ClassId.Dronegun := 50
ClassId.PropDynamic := 52
ClassId.EconEntity := 53
ClassId.EconWearable := 54
ClassId.Flashbang := 77
ClassId.HEGrenade := 96
ClassId.Hostage := 97
ClassId.Inferno := 100
ClassId.Healthshot := 104
ClassId.Cash := 105
ClassId.Knife := 107
ClassId.KnifeGG := 108
ClassId.MolotovGrenade := 113
ClassId.MolotovProjectile := 114
ClassId.PropPhysicsMultiplayer := 123
ClassId.AmmoBox := 125
ClassId.LootCrate := 126
ClassId.RadarJammer := 127
ClassId.WeaponUpgrade := 128
ClassId.PlantedC4 := 129
ClassId.PropDoorRotating := 143
ClassId.SensorGrenade := 152
ClassId.SensorGrenadeProjectile := 153
ClassId.SmokeGrenade := 156
ClassId.SmokeGrenadeProjectile := 157
ClassId.Snowball := 159
ClassId.SnowballPile := 160
ClassId.SnowballProjectile := 161
ClassId.Tablet := 172
ClassId.Aug := 232
ClassId.Awp := 233
ClassId.Elite := 239
ClassId.FiveSeven := 241
ClassId.G3sg1 := 242
ClassId.Glock := 245
ClassId.P2000 := 246
ClassId.P250 := 258
ClassId.Scar20 := 261
ClassId.Sg553 := 265
ClassId.Ssg08 := 267
ClassId.Tec9 := 269
ClassId.World := 275

;Move types
global MOVETYPE_NONE       := 0
global MOVETYPE_ISOMETRIC  := 1
global MOVETYPE_WALK       := 2
global MOVETYPE_STEP       := 3
global MOVETYPE_FLY        := 4
global MOVETYPE_FLYGRAVITY := 5
global MOVETYPE_VPHYSICS   := 6
global MOVETYPE_PUSH       := 7
global MOVETYPE_NOCLIP     := 8
global MOVETYPE_LADDER     := 9
global MOVETYPE_OBSERVER   := 10

;Flags
global FL_ONGROUND    := (1<<0) ; At rest / on the ground
global FL_DUCKING     := (1<<1) ; Player flag -- Player is fully crouched
global FL_ANIMDUCKING := (1<<2) ; Player flag -- Player is in the process of crouching or uncrouching but could be in transition
; examples:                                   Fully ducked:  FL_DUCKING &  FL_ANIMDUCKING
;           Previously fully ducked, unducking in progress:  FL_DUCKING & !FL_ANIMDUCKING
;                                           Fully unducked: !FL_DUCKING & !FL_ANIMDUCKING
;           Previously fully unducked, ducking in progress: !FL_DUCKING &  FL_ANIMDUCKING
global FL_WATERJUMP   := (1<<3) ; Player jumping out of water
global FL_ONTRAIN     := (1<<4) ; Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
global FL_INRAIN      := (1<<5) ; Indicates the entity is standing in rain
global FL_FROZEN      := (1<<6) ; Player is frozen for 3rd person camera
global FL_ATCONTROLS  := (1<<7) ; Player can't move, but keeps key inputs for controlling another entity
global FL_CLIENT      := (1<<8) ; Is a player
global FL_FAKECLIENT  := (1<<9) ; Fake client, simulated server side; don't send network messages to them
; NON-PLAYER SPECIFIC (i.e., not used by GameMovement or the client .dll ) -- Can still be applied to players, though
global FL_INWATER     := (1<<10) ; In water


class c_Entity {
	__New(index, mode:=1) {
		if (mode=1) {
			this.entity := csgo.read(client + dwEntityList + index * 0x10, "int")
			,this.index := index
		} else if (mode=2) {
			this.entity := index
		}
		
		return this
	}

	vec_origin() {
		csgo.readRaw(this.entity + m_vecOrigin, origin_struct, 0xC)
		return new Vector([NumGet(origin_struct, 0x0, "Float"), NumGet(origin_struct, 0x4, "Float"), NumGet(origin_struct, 0x8, "Float")])
	}

	vec_eyes() {
		csgo.readRaw(this.entity + m_vecOrigin, origin_struct, 0xC)
		csgo.readRaw(this.entity + m_vecViewOffset, view_offsets_struct, 0xC)
		return new Vector([NumGet(origin_struct, 0x0, "Float")+NumGet(view_offsets_struct, 0x0, "Float")
						 , NumGet(origin_struct, 0x4, "Float")+NumGet(view_offsets_struct, 0x4, "Float")
						 , NumGet(origin_struct, 0x8, "Float")+NumGet(view_offsets_struct, 0x8, "Float")])
	}

	flags() {
		return csgo.read(this.entity + m_fFlags, "int")
	}

	moveType() {
		return csgo.read(this.entity + m_MoveType, "int")
	}

	is_alive() {
		static mode := 2
		if (mode=1) {
			h := csgo.read(this.entity + m_iHealth, "int")
			return (h>0 && h<=100)
		} else if (mode=2) {
			l := csgo.read(this.entity + m_lifeState, "int")
			return (l=0)
		}
	}

	health() {
		return Format("{:d}", csgo.read(this.entity + m_iHealth, "int"))
	}

	team() {
		return csgo.read(this.entity + m_iTeamNum, "int")
	}

	crosshair_id() {
		return csgo.read(this.entity + m_iCrosshairId, "int")
	}

	glow_index() {
		return csgo.read(this.entity + m_iGlowIndex, "int")
	}

	active_weapon() {
		handle := csgo.read(this.entity + m_hActiveWeapon, "int")
		return csgo.read(client + dwEntityList + ((handle & 0xFFF) - 1) * 0x10, "int")
	}

	scoped() {
		return csgo.read(this.entity + m_bIsScoped, "int")
	}

	dormant() {
		return csgo.read(this.entity + m_bDormant, "int")
	}

	immunity() {
		return csgo.read(this.entity + m_bGunGameImmunity, "uchar")
	}

	spotted() {
		return csgo.read(this.entity + m_bSpotted, "uchar")
	}

	set_spotted() {
		csgo.write(this.entity + m_bSpotted, 2, "char")
	}

	spotted_by_mask() {
		return csgo.read(this.entity + m_bSpottedByMask, "int64")
	}

	last_place_name() {
		return csgo.readString(this.entity + m_szLastPlaceName, 128, "UTF-8")
	}

	shots_fired() {
		return csgo.read(this.entity + m_iShotsFired, "int")
	}

	view_model() {
		handle := csgo.read(this.entity + m_hViewModel, "int")
		return csgo.read(client + dwEntityList + ((handle & 0xFFF) - 1) * 0x10, "int")
	}

	vec_mins() {
		static m_vecMins := 0x8
		csgo.readRaw(this.entity + m_Collision + m_vecMins, mins_struct, 0xC)
		Return new Vector([NumGet(mins_struct, 0x0, "Float"), NumGet(mins_struct, 0x4, "Float"), NumGet(mins_struct, 0x8, "Float")])
	}

	vec_maxs()  {
		static m_vecMaxs := 0x14
		csgo.readRaw(this.entity + m_Collision + m_vecMaxs, maxs_struct, 0xC)
		Return new Vector([NumGet(maxs_struct, 0x0, "Float"), NumGet(maxs_struct, 0x4, "Float"), NumGet(maxs_struct, 0x8, "Float")])
	}

	trans() {
	csgo.readRaw(this.entity + m_rgflCoordinateFrame, trans_struct, 0x30)
	return new Vector([NumGet(trans_struct, 0x0,  "Float"), NumGet(trans_struct, 0x4,  "Float"), NumGet(trans_struct, 0x8,  "Float"), NumGet(trans_struct, 0xC,  "Float")
					 , NumGet(trans_struct, 0x10, "Float"), NumGet(trans_struct, 0x14, "Float"), NumGet(trans_struct, 0x18, "Float"), NumGet(trans_struct, 0x1C, "Float")
					 , NumGet(trans_struct, 0x20, "Float"), NumGet(trans_struct, 0x24, "Float"), NumGet(trans_struct, 0x28, "Float"), NumGet(trans_struct, 0x2C, "Float")])
	}

	name() {
		userInfoTable := csgo.read(clientState + dwClientState_PlayerInfo, "Uint")
		,items := csgo.read(userInfoTable + 0x40, "Uint", 0xC)
		return csgo.readString(items + 0x28 + ((this.index - 0) * 0x34), 128, "UTF-8", 0x10)
	}

	vec_bone(index) {
		return new Vector([csgo.read(this.entity + m_dwBoneMatrix, "Float", 0x30*index + 0x0C)
			  			 , csgo.read(this.entity + m_dwBoneMatrix, "Float", 0x30*index + 0x1C)
			  			 , csgo.read(this.entity + m_dwBoneMatrix, "Float", 0x30*index + 0x2C)])
	}

	classid() {
		return csgo.read(this.entity + 0x8, "int", 0x8, 0x1, 0x14)
	}

	vec_view_angles() {
		csgo.readRaw(clientState + dwClientState_ViewAngles, ViewAngles, 0xC)
		return new Vector([NumGet(ViewAngles, 0x0, "Float"), NumGet(ViewAngles, 0x4, "Float"), NumGet(ViewAngles, 0x8, "Float")])
	}

	vec_punch_angles() {
		csgo.readRaw(this.entity + m_aimPunchAngle, PunchAngles, 0xC)
		return new Vector([NumGet(PunchAngles, 0x0, "Float"), NumGet(PunchAngles, 0x4, "Float"), NumGet(PunchAngles, 0x8, "Float")])
	}

	vec_velocity() {
		csgo.readRaw(this.entity + m_vecVelocity, velocities, 0xC)
		return new Vector([NumGet(velocities, 0x0, "Float"), NumGet(velocities, 0x4, "Float"), NumGet(velocities, 0x8, "Float")])
	}
}
