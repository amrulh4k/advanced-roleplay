#include <YSI_Coding\y_hooks>

CMD:criargaragem(playerid, params[]) {
    new price, address[256], Float:pos[4];

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

	if (sscanf(params, "ds[256]", price, address))
        return SendSyntaxMessage(playerid, "/criargaragem [pre�o] [endere�o �nico]");
    
    if(price < 1000)
        return SendErrorMessage(playerid, "O pre�o da garagem deve ser maior do que $1000.");
    
    CreateGarage(playerid, price, address, pos);

    return 1;
}

CMD:editargaragem(playerid, params[]) {
    new id, option[64], value[64];

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

	if(sscanf(params, "ds[64]S()[64]", id, option, value)) {
        SendSyntaxMessage(playerid, "/editargaragem [id] [op��o]");
        return SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: entrada, interior, preco, endereco");
    }

    if(!IsValidHouse(id))
        return SendErrorMessage(playerid, "Esse ID de garagem n�o existe.");

    // Editar a entrada (localiza��o)
    if(!strcmp(option, "entrada", true)) {
        ChangeGarageEntry(playerid, id);
    }

    // Editar o interior (lado de dentro)
    if(!strcmp(option, "interior", true)) {
        ChangeGarageInterior(playerid, id);
    }

    return 1;
}

CMD:setargaragemcasa(playerid, params[]) {
    new garageId;
    new houseId = GetNearestHouseEntry(playerid);

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

    if (sscanf(params, "d", garageId))
        return SendSyntaxMessage(playerid, "/setargaragemcasa [id da garagem]");
    
    if (!houseId)
        return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo � nenhuma casa.");
    
    if (hInfo[houseId][hGarage])
        return SendErrorMessage(playerid, "Essa casa j� possui uma garagem.");
    
    AttachGarageToHouse(playerid, houseId, garageId);

    return 1;
}

CMD:irgaragem(playerid, params[]) {
    new id;

    if(GetPlayerAdmin(playerid) < 2)
        return SendPermissionMessage(playerid);

    if(sscanf(params, "d", id))
        return SendSyntaxMessage(playerid, "/irgaragem [id]");

    SendPlayerGarage(playerid, id);

    return 1;
}