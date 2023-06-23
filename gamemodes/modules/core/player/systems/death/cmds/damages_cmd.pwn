CMD:ferimentos(playerid, params[]){
    static userid;
    if (sscanf(params, "u", userid)) return SendSyntaxMessage(playerid, "/ferimentos [playerid/nome]");
    if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);

    if (pInfo[playerid][pAdminDuty]) ShowPlayerDamages(userid, playerid, 1);
    else {
        if(!IsPlayerNearPlayer(playerid, userid, 5.0)) return SendErrorMessage(playerid, "Voc� n�o est� perto deste jogador.");
        ShowPlayerDamages(userid, playerid, 0);
    }
    return true;
}

CMD:investida(playerid, params[]){
	if (!pInfo[playerid][pTackleMode]){
		SendServerMessage(playerid, "Voc� ativou o modo investida. A partir de agora se voc� socar algu�m, haver� chances de derruba-lo.");
		SendServerMessage(playerid, "Se o jogador for derrubado e n�o interpretar corretamente, utilize o /report.");
		pInfo[playerid][pTackleMode] = true;
	}else{
		SendServerMessage(playerid, "Voc� desativou o modo investida.");
		pInfo[playerid][pTackleMode] = false;
		TextDrawHideForPlayer(playerid, TEXTDRAW_TACKLE);
	}
	return true;
}
alias:investida("derrubar", "tackle", "investir")

CMD:aceitarmorte(playerid, params[]){
	if (pInfo[playerid][pDead]) return SendErrorMessage(playerid, "Voc� j� est� morto.");
	if (!pInfo[playerid][pBrutallyWounded]) return SendErrorMessage(playerid, "Voc� n�o est� brutalmente ferido.");
	if (pInfo[playerid][pDeadTime] > 180) return SendErrorMessage(playerid, "Voc� deve aguardar mais %d segundos para aceitar a morte.", pInfo[playerid][pDeadTime]-180);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "(( %s aceitou a morte ))", pNome(playerid));
	SendServerMessage(playerid, "Voc� desistiu e aceitou sua morte.");
	OnPlayerGetDeath(playerid, 999, 999);
	return true;
}

CMD:respawnar(playerid, params[]){
	if (pInfo[playerid][pBrutallyWounded]) return SendErrorMessage(playerid, "Voc� est� brutalmente ferido, digite /aceitarmorte.");
	if (!pInfo[playerid][pDead]) return SendErrorMessage(playerid, "Voc� n�o est� morto.");
	if (pInfo[playerid][pDeadTime] > 0) return SendErrorMessage(playerid, "Voc� deve aguardar mais %d segundos para respawnar.", pInfo[playerid][pDeadTime]-60);

	CreateDeadBody(playerid);
	OnPlayerRevive(playerid);
	SendPlayerHospital(playerid);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "(( %s respawnou ap�s sua morte ))", pNome(playerid));
	SendServerMessage(playerid, "Voc� respawnou e n�o poder� lembrar de nada que ocasionou sua �ltima morte.");
	return true;
}