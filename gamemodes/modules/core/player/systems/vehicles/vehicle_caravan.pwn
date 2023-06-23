#include <YSI_Coding\y_hooks>

CMD:darcaravana(playerid, params[]) {
	if(GetPlayerAdmin(playerid) < 5) return SendPermissionMessage(playerid);

	static userid, type;
	if (sscanf(params, "ud", userid, type)) return SendSyntaxMessage(playerid, "/darcaravana [id/nome] [tipo]");
	if (userid == INVALID_PLAYER_ID) return SendNotConnectedMessage(playerid);
    if (type < 1 || type > 3) return SendErrorMessage(playerid, "Voc� especificou um tipo de caravana inv�lido. Os tipos variam entre um e tr�s.");
    
	static Float:x, Float:y, Float:z, Float:a, id = -1;
    GetPlayerPos(userid, x, y, z);
	GetPlayerFacingAngle(userid, a);
	SetPlateFree(playerid);

    id = VehicleCreate(pInfo[userid][pID], 697, x, y + 2, z + 1, a, 0, 0, pInfo[playerid][pBuyingPlate], 0, 0, 0, 0, 0, 0, 1, type);
	pInfo[playerid][pBuyingPlate][0] = EOS;

	if (id == -1) return SendErrorMessage(playerid, "O servidor chegou ao limite m�ximo de ve�culos din�micos.");

	SendServerMessage(playerid, "Voc� criou uma caravana para %s.", pNome(userid));

	format(logString, sizeof(logString), "%s (%s) criou uma caravana para %s", pNome(playerid), GetPlayerUserEx(playerid), pNome(userid));
	logCreate(playerid, logString, 1);
	return true;
}

CMD:trailer(playerid, params[]) {

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Voc� n�o � o motorista.");

    new vehicleid = GetVehicleFromBehind(GetPlayerVehicleID(playerid));
	if (vehicleid == INVALID_VEHICLE_ID) return SendErrorMessage(playerid, "N�o tem nenhum veiculo pr�ximo.");
    LinkVehicleToInterior(vehicleid, 1);
    AttachTrailerToVehicle(vehicleid, GetPlayerVehicleID(playerid));
	return true;
}

CMD:trailerex(playerid, params[]) {

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Voc� n�o � o motorista.");

    new vehicleid = GetVehicleFromBehind(GetPlayerVehicleID(playerid));
	if (vehicleid == INVALID_VEHICLE_ID) return SendErrorMessage(playerid, "N�o tem nenhum veiculo pr�ximo.");

    DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	return true;
}