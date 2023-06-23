#include <YSI_Coding\y_hooks>

/* =============================== PLAYERS =============================== */
CMD:v(playerid, params[]) {
	new type[128];
	if (sscanf(params, "s[128]", type)) {
 	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /v [a��o]");
		SendClientMessage(playerid, COLOR_BEGE, "[A��es]: lista, estacionar, mudarvaga, stats");
		SendClientMessage(playerid, COLOR_BEGE, "[A��es]: trancar, portamalas, upgrade, placa, removerplaca");
		SendClientMessage(playerid, COLOR_BEGE, "[Deletar]: deletar (n�o recebe nada)");
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return true;
	}
	if (!strcmp(type, "lista", true)) return ShowPlayerVehicles(playerid);
	else if (!strcmp(type, "estacionar", true)) return ParkPlayerVehicle(playerid);
	else if (!strcmp(type, "mudarvaga", true)) return ChangeParkPlayerVehicle(playerid);
	else if (!strcmp(type, "stats", true)) return CheckVehicleStats(playerid);
	else if (!strcmp(type, "trancar", true)) return SetVehicleLock(playerid);

	return true;
}

CMD:placa(playerid, params[]) {
	new vehicleid = VehicleNearest(playerid);
	if(vehicleid == -1) return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo de nenhum veiculo.");
	
	SendClientMessage(playerid, COLOR_GREEN, "|_________ San Andreas Plate _________|");
	if(vInfo[vehicleid][vLegal] == 0 && vInfo[vehicleid][vNamePersonalized]) va_SendClientMessage(playerid, -1, "Ve�culo n�o emplacado (( %s (%s) ))", vInfo[vehicleid][vName], ReturnVehicleModelName(vInfo[vehicleid][vModel]));
	else if(vInfo[vehicleid][vLegal] == 0 && !vInfo[vehicleid][vNamePersonalized]) va_SendClientMessage(playerid, -1, "Ve�culo n�o emplacado (( %s ))", ReturnVehicleModelName(vInfo[vehicleid][vModel]));

	else if(vInfo[vehicleid][vCaravan] != 0) va_SendClientMessage(playerid, -1, "Placa: %s (( %s ))", vInfo[vehicleid][vPlate], vInfo[vehicleid][vName]);
	else if(vInfo[vehicleid][vNamePersonalized]) va_SendClientMessage(playerid, -1, "Placa: %s (( %s (%s) ))", vInfo[vehicleid][vPlate], vInfo[vehicleid][vName], ReturnVehicleModelName(vInfo[vehicleid][vModel]));
	else va_SendClientMessage(playerid, -1, "Placa: %s (( %s ))", vInfo[vehicleid][vPlate], ReturnVehicleModelName(vInfo[vehicleid][vModel]));
	return true;
}

CMD:motor(playerid, params[]) {
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "Voc� deve ser o motorista do ve�culo para usar esse comando.");

	new string[64], vehicleid = GetPlayerVehicleID(playerid);
	new id = VehicleGetID(vehicleid), model = GetVehicleModel(vehicleid);

	if(model == 481 || model == 509 || model == 510) {
		SendErrorMessage(playerid, "Este veiculo n�o possui motor.");
		SetEngineStatus(vehicleid, true);
		return true;
	}

	if (GetEngineStatus(vehicleid)){
	    SetEngineStatus(vehicleid, false);
		format(string, sizeof(string), "~r~MOTOR DESLIGADO");
	    GameTextForPlayer(playerid, string, 2500, 4);
		if(vInfo[id][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s desliga o ve�culo %s.", pNome(playerid), vInfo[id][vName]);
		else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s desliga o ve�culo.", pNome(playerid));
	    return true;
	} 
	
	if (vInfo[id][vFuel] < 1.0) return SendErrorMessage(playerid, "O tanque de combust�vel est� vazio.");
	if (ReturnVehicleHealth(vehicleid) <= 300) return SendErrorMessage(playerid, "Este ve�culo est� danificado e n�o pode ser ligado.");

	if (VehicleIsOwner(playerid, id)) {
		if (vInfo[id][vFaction] != 0 || vInfo[id][vJob] != 0) vInfo[id][vBattery] = 100.000;
		if (vInfo[id][vBattery] > 5.000) {
			if (!GetEngineStatus(vehicleid)) {
				SetEngineStatus(vehicleid, true);
				if(vInfo[id][vBattery] > 0.001) vInfo[id][vBattery] -= 0.001;

				format(string, sizeof(string), "~g~MOTOR LIGADO");
				GameTextForPlayer(playerid, string, 2400, 4);

				if(vInfo[id][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo %s.", pNome(playerid), vInfo[id][vName]);
				else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo.", pNome(playerid));
			}
		} else {
			new randomex;
			randomex = random(6);
			switch(randomex) {
				case 1: {
	    	    	SetEngineStatus(vehicleid, true);
					if(vInfo[id][vBattery] > 0.001) vInfo[id][vBattery] -= 0.001;

	        		format(string, sizeof(string), "~g~MOTOR LIGADO");
	        		GameTextForPlayer(playerid, string, 2500, 4);
				
					if(vInfo[id][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo %s.", pNome(playerid), vInfo[id][vName]);
					else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo.", pNome(playerid));
				} default: {
					if(vInfo[id][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s insere a chave na igni��o e tenta ligar o motor, por�m sem sucesso.", pNome(playerid));
					else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s insere a chave na igni��o e tenta ligar o motor, por�m sem sucesso.", pNome(playerid));
				}
			}
		}
	} else SendErrorMessage(playerid, "Voc� n�o possui as chaves deste ve�culo.");
	return true;
}

CMD:luzes(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "Voc� deve ser o motorista do ve�culo para usar esse comando.");
	if (!IsEngineVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� n�o est� em nenhum ve�culo.");

	switch (GetLightStatus(vehicleid)) {
	    case false: {
	        SetLightStatus(vehicleid, true);
         	GameTextForPlayer(playerid, "Luzes Ligadas", 2400, 4);
		} case true: {
		    SetLightStatus(vehicleid, false);
		    GameTextForPlayer(playerid, "Luzes Desligadas", 2400, 4);
		}
	}
	return true;
}

CMD:capo(playerid, params[]) {
	for (new i = 1; i != MAX_VEHICLES+1; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i)) {
	    if (!IsDoorVehicle(i))  return SendErrorMessage(playerid, "Este ve�culo n�o possui cap�.");

	    if (!GetHoodStatus(i)) {
	        SetHoodStatus(i, true);
	        GameTextForPlayer(playerid, "Capo Aberto", 2400, 4);
		} else {
			SetHoodStatus(i, false);
	        GameTextForPlayer(playerid, "Capo Fechado", 2400, 4);
		}
	    return true;
	}
	return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo de nenhum ve�culo.");
}

CMD:janela(playerid, params[]) {
    if(!IsPlayerInAnyVehicle(playerid))
        return SendErrorMessage(playerid, "Voc� n�o est� dentro de um ve�culo.");
    if(!IsDoorVehicle(GetPlayerVehicleID(playerid)))
        return SendErrorMessage(playerid, "Este ve�culo n�o possui janelas.");

    new
        windowOption[20],
        vehicleid = GetPlayerVehicleID(playerid),
        seat = GetPlayerVehicleSeat(playerid),
        bool:driver,
        bool:passenger,
        bool:backleft,
        bool:backright;

    if(sscanf(params, "S(mine)[20]", windowOption)){
        return 1;
    }

    GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);

    if(!strcmp(windowOption, "mine", true)){
        switch(seat){
            case 0:{ //Motorista
                if(driver != false){
                    SetVehicleParamsCarWindows(vehicleid, false, passenger, backleft, backright);
                    vInfo[vehicleid][vWindowsDown] = true;
                    PC_EmulateCommand(playerid, "/ame abaixa a sua janela.");

                    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	 				SendClientMessage(playerid, COLOR_BEGE, "USE: /janela [op��o]");
	 				SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: todas, frenteesquerda(fe), frentedireita(fd), trasesquerda(te), trasdireita(td)");
                    SendClientMessage(playerid, COLOR_BEGE, "* O motorista do ve�culo pode utilizar par�metros extras para controlar todas as janelas do ve�culo.");
                    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		        } else {
                    SetVehicleParamsCarWindows(vehicleid, true, passenger, backleft, backright);
					vInfo[vehicleid][vWindowsDown] = false;
                    PC_EmulateCommand(playerid, "/ame levanta a sua janela.");
                }
            }
            case 1:{ //Passageiro
                if(passenger != false){
                    SetVehicleParamsCarWindows(vehicleid, driver, false, backleft, backright);
                    vInfo[vehicleid][vWindowsDown] = true;
                    PC_EmulateCommand(playerid, "/ame abaixa a sua janela.");
                } else {
                    SetVehicleParamsCarWindows(vehicleid, driver, true, backleft, backright);
                    vInfo[vehicleid][vWindowsDown] = false;
                    PC_EmulateCommand(playerid, "/ame levanta a sua janela.");
                }
            }
            case 2:{ //Traseiro Esquerdo
                if(backleft != false){
                    SetVehicleParamsCarWindows(vehicleid, driver, passenger, false, backright);
                    vInfo[vehicleid][vWindowsDown] = true;
                    PC_EmulateCommand(playerid, "/ame abaixa a sua janela.");
                } else {
                    SetVehicleParamsCarWindows(vehicleid, driver, passenger, true, backright);
                    vInfo[vehicleid][vWindowsDown] = false;
                    PC_EmulateCommand(playerid, "/ame levanta a sua janela.");
                }
            }
            case 3:{ //Traseiro Direito
                if(backright != false){
                    SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, false);
                    vInfo[vehicleid][vWindowsDown] = true;
                    PC_EmulateCommand(playerid, "/ame abaixa a sua janela.");
                } else {
                    SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, true);
					vInfo[vehicleid][vWindowsDown] = false;
                    PC_EmulateCommand(playerid, "/ame levanta a sua janela.");
                }
            }
            default:{
                SendErrorMessage(playerid, "Voc� n�o pode abrir esta janela.");
            }
        }
    } else if(!strcmp(windowOption, "frenteesquerda", true) || !strcmp(windowOption, "fe", true)){
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendErrorMessage(playerid, "Apenas o motorista pode utilizar par�metros adicionais.");

        if(driver != false){
            SetVehicleParamsCarWindows(vehicleid, false, passenger, backleft, backright);
            vInfo[vehicleid][vWindowsDown] = true;
            PC_EmulateCommand(playerid, "/ame abaixa a janela dianteira esquerda.");
        } else {
            SetVehicleParamsCarWindows(vehicleid, true, passenger, backleft, backright);
			vInfo[vehicleid][vWindowsDown] = false;
            PC_EmulateCommand(playerid, "/ame levanta a janela dianteira esquerda.");
        }
    } else if(!strcmp(windowOption, "frentedireita", true) || !strcmp(windowOption, "fd", true)){
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendErrorMessage(playerid, "Apenas o motorista pode utilizar par�metros adicionais.");

        if(passenger != false){
            SetVehicleParamsCarWindows(vehicleid, driver, false, backleft, backright);
            vInfo[vehicleid][vWindowsDown] = true;
            PC_EmulateCommand(playerid, "/ame abaixa a janela dianteira direita.");
        } else {
            SetVehicleParamsCarWindows(vehicleid, driver, true, backleft, backright);
			vInfo[vehicleid][vWindowsDown] = false;
            PC_EmulateCommand(playerid, "/ame levanta a janela dianteira direita.");
        }
    } else if(!strcmp(windowOption, "trasesquerda", true) || !strcmp(windowOption, "te", true)){
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendErrorMessage(playerid, "Apenas o motorista pode utilizar par�metros adicionais.");

        if(backleft != false){
            SetVehicleParamsCarWindows(vehicleid, driver, passenger, false, backright);
            vInfo[vehicleid][vWindowsDown] = true;
            PC_EmulateCommand(playerid, "/ame abaixa a janela traseira esquerda.");
        } else {
            SetVehicleParamsCarWindows(vehicleid, driver, passenger, true, backright);
            vInfo[vehicleid][vWindowsDown] = false;
            PC_EmulateCommand(playerid, "/ame levanta a janela traseira esquerda.");
        }
    } else if(!strcmp(windowOption, "trasdireita", true) || !strcmp(windowOption, "td", true)){
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendErrorMessage(playerid, "Apenas o motorista pode utilizar par�metros adicionais.");

        if(backright != false){
            SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, false);
            vInfo[vehicleid][vWindowsDown] = true;
            PC_EmulateCommand(playerid, "/ame abaixa a janela traseira direita.");
        } else {
            SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, true);
            vInfo[vehicleid][vWindowsDown] = false;
            PC_EmulateCommand(playerid, "/ame levanta a janela traseira direita.");
        }
    } else if(!strcmp(windowOption, "todas", true)){
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendErrorMessage(playerid, "Apenas o motorista pode utilizar par�metros adicionais.");

        if(driver != false || passenger != false || backleft != false || backright != false){
            SetVehicleParamsCarWindows(vehicleid, false, false, false, false);
            vInfo[vehicleid][vWindowsDown] = true;
            PC_EmulateCommand(playerid, "/ame abaixa todas as janelas.");
        } else {
            SetVehicleParamsCarWindows(vehicleid, true, true, true, true);
			vInfo[vehicleid][vWindowsDown] = false;
            PC_EmulateCommand(playerid, "/ame levanta todas as janelas.");
        }
    } else SendErrorMessage(playerid, "Voc� digitou um par�metro inv�lido.");
    

    return true;
}

/* =============================== ADMINS =============================== */
// >= 5
CMD:darveiculo(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 5) return SendPermissionMessage(playerid);

	static userid, model[32], legal;
	if (sscanf(params, "us[32]d", userid, model, legal)) return SendSyntaxMessage(playerid, "/darveiculo [id/nome] [id do modelo/nome] [legalizado? (1 sim, 2 n�o)]");
	if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);
    if ((model[0] = GetVehicleModelByName(model)) == 0) return SendErrorMessage(playerid, "O modelo especificado � inv�lido.");

	static Float:x, Float:y, Float:z, Float:a, id = -1;
    GetPlayerPos(userid, x, y, z);
	GetPlayerFacingAngle(userid, a);
	if(legal == 1) SetPlateFree(playerid);
	else if(legal == 2) format(pInfo[playerid][pBuyingPlate], 120, "Invalid");

    id = VehicleCreate(pInfo[userid][pID], model[0], x, y + 2, z + 1, a, random(127), random(127), pInfo[playerid][pBuyingPlate]);

	pInfo[playerid][pBuyingPlate][0] = EOS;

	if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de ve�culos din�micos.");

	SendServerMessage(playerid, "Voc� criou um %s para %s.", ReturnVehicleModelName(model[0]), pNome(userid));

	format(logString, sizeof(logString), "%s (%s) criou um %s para %s", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(model[0]), pNome(userid));
	logCreate(playerid, logString, 1);
	return true;
}

// >= 4
CMD:criarveiculo(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 4) return SendPermissionMessage(playerid);
	static type[32], model[32], color1, color2, id = -1, value = 0, string[256];
	if (sscanf(params, "s[32]S()[256]", type, string)) return SendSyntaxMessage(playerid, "/criarveiculo [tipo] (fac��o/empresa/emprego)");
	if (!strcmp(type, "fac��o", true) || !strcmp(type, "faccao", true)) {
		if (sscanf(string, "ds[32]dd", value, model, color1, color2)) return SendSyntaxMessage(playerid, "/criarveiculo fac��o [id fac��o] [modelo] [cor 1] [cor 2]");

		if ((model[0] = GetVehicleModelByName(model)) == 0) return SendErrorMessage(playerid, "O modelo especificado � inv�lido.");
		if (color1 < 0 || color1 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (color2 < 0 || color2 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (value < 0) return SendErrorMessage(playerid, "O ID do tipo � referente ao ID da categoria. Esse valor n�o pode ser menor que 0.");

		static Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetPlateFree(playerid);

		id = VehicleCreate(0, model[0], x, y + 2, z + 1, a, color1, color2, pInfo[playerid][pBuyingPlate], 0, 0, 0, value, 0, 0);
		pInfo[playerid][pBuyingPlate][0] = EOS;

		if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de ve�culos din�micos.");

		format(logString, sizeof(logString), "%s (%s) criou um %s para a fac��o ID %d", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(model[0]), value);
		logCreate(playerid, logString, 1);
		return true;
	} else if (!strcmp(type, "empresa", true)) {
		if (sscanf(string, "ds[32]dd", value, model, color1, color2)) return SendSyntaxMessage(playerid, "/criarveiculo empresa [id empresa] [modelo] [cor 1] [cor 2]");

		if ((model[0] = GetVehicleModelByName(model)) == 0) return SendErrorMessage(playerid, "O modelo especificado � inv�lido.");
		if (color1 < 0 || color1 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (color2 < 0 || color2 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (value < 0) return SendErrorMessage(playerid, "O ID do tipo � referente ao ID da categoria. Esse valor n�o pode ser menor que 0.");

		static Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetPlateFree(playerid);

		id = VehicleCreate(0, model[0], x, y + 2, z + 1, a, color1, color2, pInfo[playerid][pBuyingPlate], 0, 0, 0, 0, value, 0);
		pInfo[playerid][pBuyingPlate][0] = EOS;

		if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de ve�culos din�micos.");

		format(logString, sizeof(logString), "%s (%s) criou um %s para a empresa ID %d", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(model[0]), value);
		logCreate(playerid, logString, 1);
		return true;
	} else if (!strcmp(type, "emprego", true)) {
		if (sscanf(string, "ds[32]dd", value, model, color1, color2)) return SendSyntaxMessage(playerid, "/criarveiculo emprego [id emprego] [modelo] [cor 1] [cor 2]");

		if ((model[0] = GetVehicleModelByName(model)) == 0) return SendErrorMessage(playerid, "O modelo especificado � inv�lido.");
		if (color1 < 0 || color1 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (color2 < 0 || color2 > 255) return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");
		if (value < 0) return SendErrorMessage(playerid, "O ID do tipo � referente ao ID da categoria. Esse valor n�o pode ser menor que 0.");

		static Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		SetPlateFree(playerid);

		id = VehicleCreate(0, model[0], x, y + 2, z + 1, a, color1, color2, pInfo[playerid][pBuyingPlate], 0, 0, 0, 0, 0, value);
		pInfo[playerid][pBuyingPlate][0] = EOS;

		if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de ve�culos din�micos.");
		
		format(logString, sizeof(logString), "%s (%s) criou um %s para o emprego ID %d", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(model[0]), value);
		logCreate(playerid, logString, 1);
		return true;
	}
	return true;
}

CMD:editarveiculo(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 4) return SendPermissionMessage(playerid);

	static id, type[24], string[128];
	if (sscanf(params, "ds[24]S()[128]", id, type, string)){
	 	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		SendClientMessage(playerid, COLOR_BEGE, "USE: /editarveiculo [id] [op��o]");
		SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: dono, localiza��o, fac��o, empresa, cor, modelo, nome");
		SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: seguro, sunpass, alarme, combustivel, bateria, motor, milhas");
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return true;
	}

	if (!IsValidVehicle(id) || VehicleGetID(id) == -1) return SendErrorMessage(playerid, "Voc� especificou um ve�culo inv�lido.");
	id = VehicleGetID(id);

	if (!strcmp(type, "dono", true) || !strcmp(type, "proprietario", true)){
		new userid;
		if (sscanf(string, "u", userid)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [dono] [novo dono]");

		SendServerMessage(playerid, "Voc� alterou de %s para %s como novo dono do %s (ID: %d).", pNome(vInfo[id][vOwner]), pNome(userid), ReturnVehicleModelName(vInfo[id][vModel]), vInfo[id][vVehicle]);

		SendServerMessage(userid, "%s setou voc� como dono do ve�culo %s (%d).", GetPlayerUserEx(playerid), ReturnVehicleModelName(vInfo[id][vModel]), vInfo[id][vVehicle]);

		format(logString, sizeof(logString), "%s (%s) alterou de %s para %s como novo dono do %s (ID: %d/SQL: %d)", pNome(playerid), GetPlayerUserEx(playerid), pNome(vInfo[id][vOwner]), pNome(userid), ReturnVehicleModelName(vInfo[id][vModel]), vInfo[id][vVehicle], vInfo[id][vID]);
		logCreate(playerid, logString, 1);

		vInfo[id][vOwner] = pInfo[userid][pID];
		SaveVehicle(id);
	}
	else if (!strcmp(type, "localizacao", true) || !strcmp(type, "localiza��o", true)){
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			GetVehiclePos(GetPlayerVehicleID(playerid), vInfo[id][vPos][0], vInfo[id][vPos][1], vInfo[id][vPos][2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), vInfo[id][vPos][3]);
		} else {
	 		GetPlayerPos(playerid, vInfo[id][vPos][0], vInfo[id][vPos][1], vInfo[id][vPos][2]);
			GetPlayerFacingAngle(playerid, vInfo[id][vPos][3]);
		}

		vInfo[id][vVW] = GetPlayerVirtualWorld(playerid);
		vInfo[id][vInterior] = GetPlayerInterior(playerid);

		SaveVehicle(id); SpawnVehicle(id);

		SetPlayerPos(playerid, vInfo[id][vPos][0], vInfo[id][vPos][1], vInfo[id][vPos][2] + 2.0);

		SendServerMessage(playerid, "Voc� ajustou a localiza��o do ve�culo ID %d.", vInfo[id][vVehicle]);

		format(logString, sizeof(logString), "%s (%s) ajustou a localiza��o do ve�culo ID %d (SQL: %d)", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
		logCreate(playerid, logString, 1);
	}
	else if (!strcmp(type, "faccao", true) || !strcmp(type, "fac��o", true)){
		new factionid;
		if (sscanf(string, "d", factionid)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [fac��o] [id fac��o] (0 remove de fac��o)");

		if(factionid == 0){
			SendServerMessage(playerid, "Voc� removeu o status faccional do ve�culo ID %d.", vInfo[id][vVehicle]);

			format(logString, sizeof(logString), "%s (%s) removeu o status faccional do ve�culo %d (SQL: %d)", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
			logCreate(playerid, logString, 1);
		} else {
			SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d na fac��o ID %d.", vInfo[id][vVehicle], factionid);

			format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)na fac��o ID %d", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], factionid);
			logCreate(playerid, logString, 1);
		}

		vInfo[id][vFaction] = factionid;
		SaveVehicle(id);
	}
	else if (!strcmp(type, "empresa", true)){
		new bizid;
		if (sscanf(string, "d", bizid)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [empresa] [id empresa] (0 remove de empresa)");

		if(bizid == 0){
			SendServerMessage(playerid, "Voc� removeu o status empresarial do ve�culo ID %d.", vInfo[id][vVehicle]);

			format(logString, sizeof(logString), "%s (%s) removeu o status empresarial do ve�culo %d (SQL: %d)", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
			logCreate(playerid, logString, 1);
		} else {
			SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d na empresa ID %d.", vInfo[id][vVehicle], bizid);

			format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)na empresa ID %d", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], bizid);
			logCreate(playerid, logString, 1);
		}

		vInfo[id][vBusiness] = bizid;
		SaveVehicle(id);
	}
	else if (!strcmp(type, "cor", true)){
		new color1, color2;
		if (sscanf(string, "dd", color1, color2)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [cor] [cor 1] [cor 2]");

		if (color1 < 0 || color1 > 255)
			return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");

		if (color2 < 0 || color2 > 255)
			return SendErrorMessage(playerid, "As cores devem estar entre 0 e 255.");

		//vInfo[id][vColor1] = color1;
		//vInfo[id][vColor2] = color2;
		SetVehicleColor(id, color1, color2);
		//SaveVehicle(id);
		SendServerMessage(playerid, "Voc� definiu as cores do ve�culo %d como %d e %d.", vInfo[id][vVehicle], color1, color2);

		format(logString, sizeof(logString), "%s (%s) definiu as cores do ve�culo ID %d (SQL: %d) como %d e %d", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], color1, color2);
		logCreate(playerid, logString, 1);
	}
	else if (!strcmp(type, "modelo", true)){
		new model[32];
		if (sscanf(string, "s[32]", model)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [modelo] [novo modelo]");
		if ((model[0] = GetVehicleModelByName(model)) == 0) return SendErrorMessage(playerid, "O modelo especificado � inv�lido.");

		
		SendServerMessage(playerid, "Voc� alterou o modelo do ve�culo %d de %d para %d.", vInfo[id][vVehicle], vInfo[id][vModel], model);

		format(logString, sizeof(logString), "%s (%s) alterou o modelo do ve�culo %d (SQLID: %d) de %d para %d.", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], vInfo[id][vModel], model);
		logCreate(playerid, logString, 1);

		vInfo[id][vModel] = model[0];
		SaveVehicle(id); SpawnVehicle(id);
	}
	else if (!strcmp(type, "nome", true)){
		new name[64];
		if (sscanf(string, "s[64]", name)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [nome] [nome do ve�culo] ('nenhum' para retirar)");

		if(strlen(name) > 32) return SendErrorMessage(playerid, "O nome do ve�culo n�o pode passar de 32 caracteres.");

		if(!strcmp(params, "nenhum", true)){
			vInfo[id][vNamePersonalized] = 0;
			format(vInfo[id][vName], 64, " ");
			SaveVehicle(id);
			SendServerMessage(playerid, "Voc� removeu o nome do ve�culo ID %d.", vInfo[id][vVehicle]);

			format(logString, sizeof(logString), "%s (%s) removeu o nome do ve�culo ID %d (SQLID: %d)", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
			logCreate(playerid, logString, 1);
			return true;
		} else {
			vInfo[id][vNamePersonalized] = 1;
			format(vInfo[id][vName], 64, name);
			SaveVehicle(id);
			SendServerMessage(playerid, "Voc� definiu o nome do ve�culo ID %d como %s.", vInfo[id][vVehicle], name);

			format(logString, sizeof(logString), "%s (%s) definiu o nome do ve�culo ID %d (SQLID: %d) como %s.", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], name);
			logCreate(playerid, logString, 1);
			return true;
		}
	}
	else if (!strcmp(type, "seguro", true)){
		new insurance;
		if (sscanf(string, "d", insurance)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [seguro] [n�vel do seguro]");

		if(insurance < 0 || insurance > 3) return SendErrorMessage(playerid, "Voc� especificou um n�vel de seguro inv�lido.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com seguro n�vel %d.", vInfo[id][vVehicle], insurance);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com seguro n�vel %d", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], insurance);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vInsurance] = insurance;
		SaveVehicle(id);
	}
	else if (!strcmp(type, "sunpass", true)){
		new sunpass;
		if (sscanf(string, "d", sunpass)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [sunpass] [(1 ativa e 0 desativa)]");

		if(sunpass == 0){
			SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d como sem sunpass.", vInfo[id][vVehicle]);

			format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d) como sem sunpass", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
			logCreate(playerid, logString, 1);

			vInfo[id][vSunpass] = sunpass;
			SaveVehicle(id);
			return true;
		} else if(sunpass == 1) {
			SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com sunpass.", vInfo[id][vVehicle]);

			format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d) com sunpass", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID]);
			logCreate(playerid, logString, 1);
			vInfo[id][vSunpass] = sunpass;
			SaveVehicle(id);
			return true;
		} else return SendErrorMessage(playerid, "Voc� definiu um valor inv�lido.");
	}
	else if (!strcmp(type, "alarme", true)){
		new alarm;
		if (sscanf(string, "d", alarm)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [seguro] [n�vel do alarme]");

		if(alarm < 0 || alarm > 3) return SendErrorMessage(playerid, "Voc� especificou um n�vel de alarme inv�lido.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com alarme n�vel %d.", vInfo[id][vVehicle], alarm);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com alarme n�vel %d", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], alarm);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vAlarm] = alarm;
		SaveVehicle(id);
	} 
	else if (!strcmp(type, "combust�vel", true) || !strcmp(type, "combustivel", true)){
		new Float:fuel;
		if (sscanf(string, "f", fuel)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [combust�vel] [n�vel do combust�vel]");

		if(fuel < 1.0 || fuel > 100.0) return SendErrorMessage(playerid, "Voc� deve informar uma quantidade entre 1.0 e 100.0.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com combust�vel em %.2f%%.", vInfo[id][vVehicle], fuel);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com combust�vel em %.2f%%", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], fuel);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vFuel] = fuel;
		SaveVehicle(id);
	} 
	else if (!strcmp(type, "bateria", true)){
		new Float:battery;
		if (sscanf(string, "f", battery)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [bateria] [n�vel da bateria]");

		if(battery < 1.0 || battery > 100.0) return SendErrorMessage(playerid, "Voc� deve informar uma quantidade entre 1.0 e 100.0.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com bateria em %.2f%%.", vInfo[id][vVehicle], battery);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com bateria em %.2f%%", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], battery);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vBattery] = battery;
		SaveVehicle(id);
	} 
	else if (!strcmp(type, "motor", true)){
		new Float:engine;
		if (sscanf(string, "f", engine)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [seguro] [n�vel do enginee]");

		if(engine < 1.0 || engine > 100.0) return SendErrorMessage(playerid, "Voc� deve informar uma quantidade entre 1.0 e 100.0.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com motor em %.2f%%.", vInfo[id][vVehicle], engine);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com motor em %.2f%%", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], engine);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vEngine] = engine;
		SaveVehicle(id);
	} 
	else if (!strcmp(type, "milhas", true)){
		new Float:miles;
		if (sscanf(string, "f", miles)) return SendSyntaxMessage(playerid, "/editarveiculo [id] [milhas] [quantidade de milhas]");

		if(miles < 0.0) return SendErrorMessage(playerid, "Voc� n�o pode definir um valor menor que 0.00.");

		SendServerMessage(playerid, "Voc� definiu o ve�culo ID %d com milhas em %.2f.", vInfo[id][vVehicle], miles);

		format(logString, sizeof(logString), "%s (%s) definiu o ve�culo ID %d (SQL: %d)com milhas em %.2f", pNome(playerid), GetPlayerUserEx(playerid), vInfo[id][vVehicle], vInfo[id][vID], miles);
		logCreate(playerid, logString, 1);
		
		vInfo[id][vMiles] = miles;
		SaveVehicle(id);
	} else return SendErrorMessage(playerid, "Voc� espec�ficou um par�metro inv�lido.");
	return true;
}

CMD:deletarveiculo(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 4) return SendPermissionMessage(playerid);

	static 
		id = 0;

	if (sscanf(params, "d", id)) {
		if (IsPlayerInAnyVehicle(playerid)) id = GetPlayerVehicleID(playerid);
		else return SendSyntaxMessage(playerid, "/deletarveiculo [id]");
	}
	
	if (!IsValidVehicle(id) || VehicleGetID(id) == -1) return SendErrorMessage(playerid, "Voc� especificou um ve�culo inv�lido.");

	new owner = vInfo[VehicleGetID(id)][vOwner];

	for(new i = 0; i < MAX_PLAYERS; i++) if(pInfo[i][pID] == owner) va_SendClientMessage(i, COLOR_LIGHTRED, "Seu ve�culo %s [%d] foi deletado por um administrador.", ReturnVehicleModelName(vInfo[VehicleGetID(id)][vModel]), id);

	SendServerMessage(playerid, "Voc� destruiu o ve�culo ID: %d.", id);
	format(logString, sizeof(logString), "%s (%s) destruiu o ve�culo %s [%d/SQL: %d]", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(vInfo[VehicleGetID(id)][vModel]), id, VehicleGetID(id));
	logCreate(playerid, logString, 1);
	
	ResetVehicleObjects(id);
	ResetVehicle(VehicleGetID(id));
	DeleteVehicle(VehicleGetID(id));
	return true;
}

CMD:amotor(playerid, params[]) {
	if (GetPlayerAdmin(playerid) < 4) return SendPermissionMessage(playerid);
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "Voc� deve ser o motorista do ve�culo para usar esse comando.");

	new string[64];
	new vehicleid = GetPlayerVehicleID(playerid);
	new id = VehicleGetID(vehicleid);

	if (vInfo[id][vFuel] < 1.0) return SendErrorMessage(playerid, "O tanque de combust�vel est� vazio.");

	if (ReturnVehicleHealth(vehicleid) <= 300) return SendErrorMessage(playerid, "Este ve�culo est� danificado e n�o pode ser ligado.");

	switch (GetEngineStatus(vehicleid)) {
	    case false: {
	        SetEngineStatus(vehicleid, true);
			SetLightStatus(vehicleid, true);
			format(string, sizeof(string), "~g~MOTOR LIGADO");
			GameTextForPlayer(playerid, string, 2400, 4);
			if(vInfo[VehicleGetID(vehicleid)][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo %s.", pNome(playerid), vInfo[VehicleGetID(vehicleid)][vName]);
			else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s liga o ve�culo.", pNome(playerid));
		} case true: {
		    SetEngineStatus(vehicleid, false);
   			SetLightStatus(vehicleid, false);
   			format(string, sizeof(string), "~r~MOTOR DESLIGADO");
			GameTextForPlayer(playerid, string, 2400, 4);
			if(vInfo[VehicleGetID(vehicleid)][vNamePersonalized]) SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s desliga o ve�culo %s.", pNome(playerid), vInfo[VehicleGetID(vehicleid)][vName]);
			else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s desliga o ve�culo.", pNome(playerid));
		}
	}

	format(logString, sizeof(logString), "%s (%s) usou o /amotor %s [%d/SQL: %d]", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(vInfo[id][vModel]), vehicleid, id);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:areparar(playerid, params[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerAdmin(playerid) < 4) return SendPermissionMessage(playerid);
	if (vehicleid > 0 && isnull(params)) {
		RepairVehicle(vehicleid);
		new id = VehicleGetID(vehicleid);

		if(id != -1)
			vInfo[id][vHealthRepair] = 1000.0;
		
		SendServerMessage(playerid, "Voc� reparou seu atual ve�culo.");
  		SendAdminAlert(COLOR_LIGHTRED, "AdmCmd: %s reparou o veiculo %d.", GetPlayerUserEx(playerid), vehicleid);
	} else {
		if (sscanf(params, "d", vehicleid))
	    	return SendSyntaxMessage(playerid, "/areparar [ID do ve�culo]");

		else if (!IsValidVehicle(vehicleid))
	    	return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");

		RepairVehicle(vehicleid);
		new id = VehicleGetID(vehicleid);
		
		if(id != -1) {
			vInfo[id][vHealthRepair] = 1000.0;

			vInfo[id][vDamage][1] = 0;//9mm
			vInfo[id][vDamage][2] = 0;//.44
			vInfo[id][vDamage][3] = 0;//12 Gauge
			vInfo[id][vDamage][4] = 0;//9x19mm
			vInfo[id][vDamage][5] = 0;//7.62mm
			vInfo[id][vDamage][6] = 0;//5.56x45mm
			vInfo[id][vDamage][7] = 0;//.40 LR
			vInfo[id][vDamage][8] = 0;//.50 LR

			GetVehicleDamageStatus(vInfo[id][vVehicle], vInfo[id][vPanelsStatus], vInfo[id][vDoorsStatus], vInfo[id][vLightsStatus], vInfo[id][vTiresStatus]);
		}

		SendServerMessage(playerid, "Voc� reparou o ve�culo ID: %d.", vehicleid);
		SendAdminAlert(COLOR_LIGHTRED, "AdmCmd: %s reparou o veiculo %d.", GetPlayerUserEx(playerid), vehicleid);

		if(id != -1) format(logString, sizeof(logString), "%s (%s) reparou o ve�culo %d/%d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid, id);
		else format(logString, sizeof(logString), "%s (%s) reparou o ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
		logCreate(playerid, logString, 1);
	}
	return true;
}

// >= 3
CMD:entrarveiculo(playerid, params[]) {
	new vehicleid, seatid;

    if (GetPlayerAdmin(playerid) < 3) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/irveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");

	seatid = GetAvailableSeat(vehicleid, 0);

	if (seatid == -1)
	    return SendErrorMessage(playerid, "N�o h� nenhum assento dispon�vel.");

	PutPlayerInVehicle(playerid, vehicleid, seatid);
	format(logString, sizeof(logString), "%s (%s) entrou no ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

// >= 2
CMD:irveiculo(playerid, params[]) {
	new vehicleid;

	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/irveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");

	static Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(vehicleid));
	SetPlayerInterior(playerid, VehicleInterior[vehicleid]);
	SetPlayerPos(playerid, x, y - 2, z + 2);

	format(logString, sizeof(logString), "%s (%s) foi at� o ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:trazerveiculo(playerid, params[]) {
	new vehicleid;

	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/trazerveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");

	static Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 2, y - 2, z);

	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	format(logString, sizeof(logString), "%s (%s) levou o ve�culo %d at� ele", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:respawnarveiculo(playerid, params[]) {
	new vehicleid, id;

	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/respawnarveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");

	id = VehicleGetID(id);
	SaveVehicle(id);
    ResetVehicleObjects(id);
    ResetVehicle(id);
	LoadVehicle(id);

	SendServerMessage(playerid, "Voc� respawnou o ve�culo ID: %d.", vehicleid);
    SendAdminAlert(COLOR_LIGHTRED, "AdmCmd: %s respawnou o ve�culo %d.", GetPlayerUserEx(playerid), vehicleid);

	format(logString, sizeof(logString), "%s (%s) respawnou o ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:rtc(playerid, params[]) {
	new vehicleid;

	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/respawnarveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");
	new id = VehicleGetID(vehicleid);
	if (vInfo[id][vFaction] != 0 || vInfo[id][vBusiness] != 0 || vInfo[id][vJob] != 0) return SendErrorMessage(playerid, "Voc� n�o pode dar respawn total em um ve�culo fixo.");
	
	SaveVehicle(id);
    ResetVehicleObjects(id);
    ResetVehicle(id);
    vInfo[id][vVehicle] = 0;
    vInfo[id][vExists] = 0;
	SendServerMessage(playerid, "Voc� respawnou o ve�culo ID: %d.", vehicleid);
    SendAdminAlert(COLOR_LIGHTRED, "AdmCmd: %s respawnou o ve�culo %d.", GetPlayerUserEx(playerid), vehicleid);

	format(logString, sizeof(logString), "%s (%s) respawnou o ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:aremovercallsign(playerid, params[]) {
	new vehicleid;
	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", vehicleid)) return SendSyntaxMessage(playerid, "/respawnarveiculo [ve�culo]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid)) return SendErrorMessage(playerid, "Voc� especificou o ID de ve�culo inv�lido.");
	
	SendServerMessage(playerid, "Voc� removeu a callsign do ve�culo %d", vehicleid);

	Delete3DTextLabel(v3DText[vehicleid]);
	vCallsign[vehicleid] = 0;

	format(logString, sizeof(logString), "%s (%s) removeu a callsign do ve�culo %d", pNome(playerid), GetPlayerUserEx(playerid), vehicleid);
	logCreate(playerid, logString, 1);
	return true;
}

CMD:checarveiculos(playerid, params[]) {
	new userid;
	if (GetPlayerAdmin(playerid) < 2) return SendPermissionMessage(playerid);
	if (sscanf(params, "d", userid)) return SendSyntaxMessage(playerid, "/respawnarveiculo [ve�culo]");
	if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);

	mysql_format(DBConn, query, sizeof query, "SELECT * FROM vehicles WHERE `character_id` = '%d'", pInfo[userid][pID]);
    new Cache:result = mysql_query(DBConn, query);
    new veh_id, veh_model, veh_pname, veh_name[64], veh_impounded;

	printf("SELECT * FROM vehicles WHERE `character_id` = '%d'", pInfo[userid][pID]);
	
	format(logString, sizeof(logString), "%s (%s) checou os ve�culos de %s", pNome(playerid), GetPlayerUserEx(playerid), pNome(userid));
	logCreate(playerid, logString, 1);

	printf("cache_num_rows() %d", cache_num_rows());
    if(!cache_num_rows()) return SendErrorMessage(playerid, "Este jogador n�o possui nenhum ve�culo.");


	va_SendClientMessage(playerid, COLOR_GREEN, "Veiculos de %s (ID: %d):", pNome(userid), userid);
    for(new i; i < cache_num_rows(); i++){
        cache_get_value_name_int(i, "ID", veh_id);
		cache_get_value_name_int(i, "model", veh_model);
		cache_get_value_name_int(i, "personalized_name", veh_pname);
		cache_get_value_name(i, "name", veh_name);
        cache_get_value_name_int(i, "impounded", veh_impounded);
        
		if(!vInfo[veh_id][vVehicle] && veh_pname != 0 && veh_impounded != 0) va_SendClientMessage(playerid, COLOR_GREY, "(%d) %s (( %s )) [APREENDIDO]", veh_id, veh_name, ReturnVehicleModelName(veh_model));
		else if(vInfo[veh_id][vVehicle] && veh_pname != 0) va_SendClientMessage(playerid, COLOR_GREY, "(%d/%d) %s (( %s )) ** Spawnado", vInfo[veh_id][vVehicle], veh_id, veh_name, ReturnVehicleModelName(veh_model));
		else if(!vInfo[veh_id][vVehicle] && veh_pname != 0) va_SendClientMessage(playerid, COLOR_GREY, "(%d) %s (( %s )) ", veh_id, veh_name, ReturnVehicleModelName(veh_model));
		else if(vInfo[veh_id][vVehicle]) va_SendClientMessage(playerid, COLOR_GREY, "(%d/%d) %s ** Spawnado", vInfo[veh_id][vVehicle], veh_id, ReturnVehicleModelName(veh_model));
		else va_SendClientMessage(playerid, COLOR_GREY, "(%d) %s", veh_id, ReturnVehicleModelName(veh_model));
    }
    cache_delete(result);
	return true;
}