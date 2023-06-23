#include <YSI_Coding\y_hooks>

// ADMINS
CMD:criarfaccao(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 1)) return SendPermissionMessage(playerid);

	static
	    id = -1,
		type,
		name[32];

	if (sscanf(params, "ds[32]", type, name)) {
	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	    SendClientMessage(playerid, COLOR_BEGE, "USE: /criarfaccao [tipo] [nome]");
	    SendClientMessage(playerid, COLOR_BEGE, "TIPOS: 1: Policial | 2: Midi�tica | 3: M�dica | 4: Prefeitura | 5: Governamental | 6: Civil | 7: Criminal");
	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return true;
	}

	if (type < 1 || type > 7) return SendErrorMessage(playerid, "O tipo especificado � inv�lido. Os tipos v�o de 1 at� 7.");

	id = CreateFaction(name, type);
	if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de fac��es.");
	SendServerMessage(playerid, "Voc� criou a fac��o %s (%d).", name, id);

	format(logString, sizeof(logString), "%s (%s) criou a fac��o %s (%d)", pNome(playerid), GetPlayerUserEx(playerid), name, id);
	logCreate(playerid, logString, 1);

	return true;
}

CMD:deletarfaccao(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 1)) return SendPermissionMessage(playerid);

	static
	    id = 0;

	if (sscanf(params, "d", id)) return SendSyntaxMessage(playerid, "/deletarfaccao [ID da fac��o]");

	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists]) return SendErrorMessage(playerid, "Voc� especificou um ID de fac��o inv�lido.");

	SendServerMessage(playerid, "Voc� deletou a fac��o %s (%d).", FactionData[id][factionName], id);
	format(logString, sizeof(logString), "%s (%s) deletou a fac��o %s (%d)", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], id);
	logCreate(playerid, logString, 1);

	DeleteFaction(id);
	return true;
}

CMD:editarfaccao(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 1)) return SendPermissionMessage(playerid);

	static
	    id,
	    type[24],
	    string[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string)) {
 	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarfaccao [id] [op��o]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: nome, cor, tipo, armario, cargos, maxcargos, sal�rio, status, skins");
	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return true;
	} if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists]) return SendErrorMessage(playerid, "Voc� especificou um ID de fac��o inv�lido.");

	if (!strcmp(type, "nome", true)) {
	    new name[32];

	    if (sscanf(string, "s[32]", name)) return SendSyntaxMessage(playerid, "/editarfaccao [id] [nome] [novo nome]");

		SendServerMessage(playerid, "Voc� alterou o nome da fac��o %s (%d) para %s.", FactionData[id][factionName], id, name);

		format(logString, sizeof(logString), "%s (%s) alterou o nome da fac��o %s (%d) para %s", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], id, name);
		logCreate(playerid, logString, 1);

		format(FactionData[id][factionName], 32, name);
		SaveFaction(id);
	} else if (!strcmp(type, "cor", true)) {
	    new color;

	    if (sscanf(string, "h", color))
	        return SendSyntaxMessage(playerid, "/editarfaccao [id] [cor] [cor(em hex)]");

		SendServerMessage(playerid, "Voc� alterou a {%06x}cor{36A717} da fac��o %s (%d).", color >>> 8, FactionData[id][factionName], id);

		format(logString, sizeof(logString), "%s (%s) alterou a cor da fac��o %s (%d) para %d", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], id, color);
		logCreate(playerid, logString, 1);

		FactionData[id][factionColor] = color;
		SaveFaction(id);
		UpdateFaction(id);

	} else if (!strcmp(type, "tipo", true)) {
	    new typeint;

	    if (sscanf(string, "d", typeint))
     	{
     	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarfaccao [id] [tipo] [tipo da fac��o]");
            SendClientMessage(playerid, COLOR_BEGE, "TIPOS: 1: Policial | 2: Midi�tica | 3: M�dica | 4: Prefeitura | 5: Governamental | 6: Civil | 7: Criminal");
            SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
            return 1;
		}
		if (typeint < 1 || typeint > 7) return SendErrorMessage(playerid, "O tipo especificado � inv�lido. Os tipos v�o de 1 at� 7.");

		SendServerMessage(playerid, "Voc� alterou o tipo da fac��o %s (%d) de %s para %s.", FactionData[id][factionName], id, GetFactionTypeID(FactionData[id][factionType]), GetFactionTypeID(typeint));

		format(logString, sizeof(logString), "%s (%s) alterou o tipo da fac��o %s (%d) de %s para %s", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], id, GetFactionTypeID(FactionData[id][factionType]), GetFactionTypeID(typeint));
		logCreate(playerid, logString, 1);

	    FactionData[id][factionType] = typeint;
		SaveFaction(id);

	} else if (!strcmp(type, "armario", true)) {
	    FactionConfigLocker(playerid, id);
	} else if (!strcmp(type, "cargos", true)) {
		FactionShowRanks(playerid, id);
	} else if (!strcmp(type, "maxcargos", true)) {
	    new ranks;

	    if (sscanf(string, "d", ranks))
	        return SendSyntaxMessage(playerid, "/editarfaccao [id] [maxcargos] [m�ximo de cargos]");

		if (ranks < 1 || ranks > 30)
		    return SendErrorMessage(playerid, "O m�ximo de cargos n�o pode ser menor que 1 ou maior que 30.");

		SendServerMessage(playerid, "Voc� alterou o m�ximo de cargos da fac��o %s (%d) de %d para %d.", FactionData[id][factionName], id, FactionData[id][factionRanks], ranks);

		format(logString, sizeof(logString), "%s (%s) alterou o m�ximo de cargos da fac��o %s (%d) de %d para %d", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], id, FactionData[id][factionRanks], ranks);
		logCreate(playerid, logString, 1);

		FactionData[id][factionRanks] = ranks;
		SaveFaction(id);
	} else if (!strcmp(type, "salario", true) || !strcmp(type, "sal�rio", true)) {
		FactionPaycheck(playerid, id);
	} else if (!strcmp(type, "skins", true)) {
		FactionSetSkins(playerid, id);
	}


	else SendErrorMessage(playerid, "Voc� especificou um tipo inv�lido.");

	return true;
}

CMD:lider(playerid, params[]) {
	static
		userid,
		id;

   	if (GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 1)) return SendPermissionMessage(playerid);
	if (sscanf(params, "ud", userid, id)) return SendSyntaxMessage(playerid, "/lider [id/nome] [ID da fac��o] (Utilize -1 para remover um l�der)");
	if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);
    if ((id < -1 || id >= MAX_FACTIONS) || (id != -1 && !FactionData[id][factionExists])) return SendErrorMessage(playerid, "Voc� especificou um ID de fac��o inv�lido.");

	if (id == -1) {
	    ResetFaction(userid);

		SendServerMessage(playerid, "Voc� removeu %s da lideran�a da fac��o.", pNome(userid));
		SendServerMessage(userid, "%s removeu voc� da lideren�a da fac��o.", GetPlayerUserEx(playerid));

		format(logString, sizeof(logString), "%s (%s) removeu a lideran�a da fac��o de %s (%s)", pNome(playerid), GetPlayerUserEx(playerid), pNome(userid), GetPlayerUserEx(userid));
	} else {
		SetFaction(userid, id);
		pInfo[userid][pFactionRank] = FactionData[id][factionRanks];

		SendServerMessage(playerid, "Voc� deu a lideran�a da fac��o %s para %s.", FactionData[id][factionName], pNome(userid));
		SendServerMessage(userid, "%s lhe deu a lideran�a da fac��o %s.", GetPlayerUserEx(playerid), FactionData[id][factionName]);

		format(logString, sizeof(logString), "%s (%s) deu a lideran�a da fac��o %s para %s (%s)", pNome(playerid), GetPlayerUserEx(playerid), FactionData[id][factionName], pNome(userid), GetPlayerUserEx(userid));
		logCreate(playerid, logString, 1);
	}
    return true;
}

CMD:listafaccoes(playerid, params[]) {
	new count = 0;
	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionExists]) {
	    va_SendClientMessage(playerid, COLOR_WHITE, "[ID: %d] {%06x}%s", i, FactionData[i][factionColor] >>> 8, FactionData[i][factionName]);
		count++;
	}

	if(count == 0) SendErrorMessage(playerid, "N�o existe nenhuma fac��o criada no servidor.");
	return true;
}