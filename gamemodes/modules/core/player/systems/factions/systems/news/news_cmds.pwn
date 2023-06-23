CMD:transmissao(playerid, params[]){
	if (GetFactionType(playerid) != FACTION_NEWS) return SendPermissionMessage(playerid);
    if (IsPlayerWatchingCamera(playerid) == true) return SendErrorMessage(playerid, "Voc� n�o pode iniciar uma transmiss�o enquanto assiste outra.");
    if (IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "Voc� n�o pode iniciar uma transmiss�o ao vivo de dentro de um ve�culo.");
    
    new factionid = pInfo[playerid][pFaction];
    if (!pInfo[playerid][pRecording]){
        GivePlayerCamera(playerid);
        va_SendClientMessageToAll(COLOR_YELLOW, "%s iniciou uma transmiss�o ao vivo, para assistir digite /assistir %d.", FactionGetName(pInfo[playerid][pFaction]), playerid);
        SendFactionMessage(factionid, COLOR_FACTION, "[Fac��o]: %s %s iniciou uma transmiss�o ao vivo.", Faction_GetRank(playerid), pNome(playerid));
        format(logString, sizeof(logString), "[%s] %s (%s) iniciou uma transmiss�o ao vivo em %s", FactionData[factionid][factionName], pNome(playerid), GetPlayerUserEx(playerid), GetPlayerLocation(playerid));
	    logCreate(playerid, logString, 22);
    } else {
        RemovePlayerCamera(playerid);
        va_SendClientMessageToAll(COLOR_YELLOW, "%s encerrou a transmiss�o ao vivo.", FactionGetName(pInfo[playerid][pFaction]));
        SendFactionMessage(factionid, COLOR_FACTION, "[Fac��o]: %s %s encerrou uma transmiss�o ao vivo.", Faction_GetRank(playerid), pNome(playerid));
        format(logString, sizeof(logString), "[%s] %s (%s) encerrou uma transmiss�o ao vivo em %s", FactionData[factionid][factionName], pNome(playerid), GetPlayerUserEx(playerid), GetPlayerLocation(playerid));
	    logCreate(playerid, logString, 22);
    }
    return true;
}

CMD:assistir(playerid, params[]){
    if (pInfo[playerid][pWatching]) return StopPlayerWatchingCamera(playerid);

    static userid;
	if (sscanf(params, "u", userid)) return SendSyntaxMessage(playerid, "/assistir [playerid/nome]");
	if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);
    if (IsPlayerRecording(playerid) == true) return SendErrorMessage(playerid, "Voc� n�o pode assistir sua pr�pria transmiss�o.");
    if (pInfo[userid][pRecording] == false) return SendErrorMessage(playerid, "Esse jogador n�o est� com uma transmiss�o aberta.");

    if (!pInfo[playerid][pWatching]){
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s come�a a assistir a transmiss�o ao vivo.", pNome(playerid));
        va_SendClientMessage(playerid, COLOR_GREEN, "Voc� agora est� assistindo uma transmiss�o ao vivo, para parar basta digitar /assistir.");
        StartPlayerWatchingCamera(playerid, userid);	
    }
	return true;
}