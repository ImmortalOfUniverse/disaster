global ConvarList := {}

class ConvarManager {
	__New() {
		m_pICVar := csgo.read(vstdlib + interface_engine_cvar, "int")
		,shortCuts := csgo.read(m_pICVar + 0x34, "int")
		,hashMapEntry := csgo.read(shortCuts, "int")
		while (hashMapEntry != 0) {
		    pConVar := csgo.read(hashMapEntry + 0x4, "int")
		    pConVarName := csgo.readString(pConVar + 0xC, 128, "UTF-8", 0x0)

		    if (StrLen(pConVarName) > 0) {
		    	;msgbox % "name: " . pConVarName . "`naddress: " . pConVar
		    	ConvarList[pConVarName] := pConVar
		    }

		    hashMapEntry := csgo.read(hashMapEntry + 0x4, "int")
		}
	}

	FindFast(str) {
		StringLower, str, str
		if (str) {
			;msgbox % ConvarList[str]
			return new ConVar(ConvarList[str])
		}
		return 0
	}

	Find(str) {
		StringLower, str, str
		m_pICVar := csgo.read(vstdlib + interface_engine_cvar, "int")
		,shortCuts := csgo.read(m_pICVar + 0x34, "int")
		,hashMapEntry := csgo.read(shortCuts, "int")
		while (hashMapEntry != 0) {
		    pConVar := csgo.read(hashMapEntry + 0x4, "int")
		    pConVarName := csgo.readString(pConVar + 0xC, 128, "UTF-8", 0x0)
		    StringLower, pConVarName, pConVarName
		    if (pConVarName = str) {
		    	return pConVar
		    }

		    hashMapEntry := csgo.read(hashMapEntry + 0x4, "int")
		}
		return 0
	}

}


class ConVar {
	__New(ptr) {
		this.address := ptr
	}

	GetPointer() {
        return this.address
    }

    GetNext() {
    	return new ConVar(csgo.read(this.address + 0x4, "int"))
    }

    IsRegistered() {
    	return csgo.read(this.address + 0x8, "char")
    }

    GetName() {
    	return csgo.readString(this.address + 0xC, 128, "UTF-8", 0x0)
    }

    GetDescription() {
    	return csgo.readString(this.address + 0x10, 128, "UTF-8", 0x0)
    }

    GetFlags() {
    	return csgo.read(this.address + 0x14, "int")
    }

    GetParent() {
    	return new ConVar(csgo.read(this.address + 0x1C, "int"))
    }

    GetDefaultValue() {
    	return csgo.readString(this.address + 0x20, 128, "UTF-8", 0x0)
    }

    GetString() {
    	return csgo.readString(this.address + 0x24, 128, "UTF-8", 0x0)
    }

    GetSize() {
    	return csgo.read(this.address + 0x28, "int")
    }

    GetFloat() {
    	value := csgo.read(this.address + 0x2C, "int")
		VarSetCapacity(f, 0x4)
		NumPut(value ^ this.address, f, 0, "int")
		return NumGet(f, 0, "Float")
    }

    GetInt() {
    	value := csgo.read(this.address + 0x30, "int")
		return Format("{:u}", value ^ this.address)
    }

    HasMin() {
    	return csgo.read(this.address + 0x34, "char")
    }

    GetMinValue() {
    	return csgo.read(this.address + 0x38, "float")
    }

    HasMax() {
    	return csgo.read(this.address + 0x3C, "char")
    }

    GetMaxValue() {
    	return  csgo.read(this.address + 0x40, "float")
    }

    SetString(str) {
    	csgo.writeString(this.address + 0x24, str, "UTF-8", 0x0)
    }

    SetFloat(value) {
		VarSetCapacity(v, 0x4)
		NumPut(value, v, 0, "float")
		xored := NumGet(v, 0, "int") ^ this.address
		csgo.write(this.address + 0x2C, xored, "int")
	}

	SetInt(value) {
		xored := value ^ this.address
		csgo.write(this.address + 0x30, xored, "int")
	}

}



