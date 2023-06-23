#include <YSI_Coding\y_hooks>
//Comando para criar empresa.
CMD:criarempresa(playerid, params[]) {
    new 
        type,
        price,
        address[256];

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

	if (sscanf(params, "dds[256]", type, price, address))
    {
        SendSyntaxMessage(playerid, "/criarempresa [tipo] [pre�o] [endere�o �nico]");
        SendSyntaxMessage(playerid, "[TIPOS] 1: 24/7 | 2: Ammunation | 3: Loja de roupas | 4: Fast Food | 5: Concession�ria | 6: Posto de gasolina | 7: Firma");
        return 1;
    }
    
    if (type < 1 || type > 7)
        return SendErrorMessage(playerid, "Tipo inv�lido. Tipos de 1 � 7.");

    if(price < 1000)
        return SendErrorMessage(playerid, "O pre�o da empresa deve ser maior do que $1000.");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `business` WHERE `address` = '%e';", address);
    mysql_query(DBConn, query);

    if(cache_num_rows())
        return SendErrorMessage(playerid, "Este endere�o j� est� registrado em outra empresa!");

    if(!CreateBusiness(playerid, type, price, address))
    {
        SendErrorMessage(playerid, "Bx001 - Encaminhe este c�digo para um desenvolvedor.");
        format(logString, sizeof(logString), "%s (%s) teve um erro no MySQL ao criar a empresa (cod: Bx001)", pNome(playerid), GetPlayerUserEx(playerid));
	    logCreate(playerid, logString, 13);
    }

    return 1;
}

//Comanda para deletar empresa.
CMD:deletarempresa(playerid, params[]) {
    new id;

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

	if (sscanf(params, "d", id))
        return SendSyntaxMessage(playerid, "/deletarempreasa [id]");

    if(!IsValidBusiness(id))
        return SendErrorMessage(playerid, "Esse ID de empresa n�o existe.");

    if(!DeleteBusiness(playerid, id))
    {
        SendErrorMessage(playerid, "Bx010 - Encaminhe este c�digo para um desenvolvedor.");
        format(logString, sizeof(logString), "%s (%s) teve um erro no MySQL ao excluir a empresa (cod: Bx010)", pNome(playerid), GetPlayerUserEx(playerid));
	    logCreate(playerid, logString, 13);
    }
    return 1;
} 

CMD:editarempresa(playerid, params[]) {
    new 
        businessID,
        option[64],
        value[64]; 

    if(GetPlayerAdmin(playerid) < 2 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

	if(sscanf(params, "ds[64]S()[64]", businessID, option, value)) {
        SendSyntaxMessage(playerid, "/editarempresa [id] [op��o]");
        return SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: nome, entrada, interior, pre�o, tipo");
    }
    
    if(!IsValidBusiness(businessID))
        return SendErrorMessage(playerid, "Esse ID de empresa n�o existe.");
    
    // Editar o nome da empresa
    if(!strcmp(option, "nome", true) || !strcmp(option, "nome", true)) {
        new newName = strval(value);
        
        if(!newName)
            return SendErrorMessage(playerid, "Voc� precisa especificar um nome. (/editarempresa [id] [op��o] [novo nome])");

        //Fun��o para editar o nome da empresa.
        EditNameBusiness(businessID, newName);

        SendServerMessage(playerid, "Voc� editou o nome da empresa de ID %d para $%s.", businessID, newName);
        format(logString, sizeof(logString), "%s (%s) editou o nome da empresa de ID %d para $%s.", pNome(playerid), GetPlayerUserEx(playerid), businessID, newName);
	    logCreate(playerid, logString, 13);
        return 1;
    }      

    //Edita a entrada da empresa
    if(!strcmp(option, "entrada", true) || !strcmp(option, "entrada", true)) {
        //Fun��o para editar o nome da empresa.
        EditEntryBusiness(playerid, businessID);

        SendServerMessage(playerid, "Voc� editou a entrada da empresa de ID %d.", businessID);
        format(logString, sizeof(logString), "%s (%s) editou a entrada da empresa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), businessID);
	    logCreate(playerid, logString, 13);
        return 1;
    }   
    //Edita a entrada da empresa
    if(!strcmp(option, "interior", true) || !strcmp(option, "interior", true)) {
        //Fun��o para editar o nome da empresa.
        EditExitBusiness(playerid, businessID);

        SendServerMessage(playerid, "Voc� editou o interior da empresa de ID %d.", businessID);
        format(logString, sizeof(logString), "%s (%s) editou o interior da empresa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), businessID);
	    logCreate(playerid, logString, 13);
        return 1;
    }   
     // Editar o pre�o da empresa
    if(!strcmp(option, "pre�o", true) || !strcmp(option, "pre�o", true)) {
        new newPrice = strval(value);

        if(newPrice < 1000)
            return SendErrorMessage(playerid, "O pre�o da empresa deve ser maior do que $1000.");
        //Fun��o para editar o pre�o da empresa.
        EditPriceBusiness(businessID, newPrice);

        SendServerMessage(playerid, "Voc� editou o pre�o da empresa de ID %d para $%s.", businessID, newPrice);
        format(logString, sizeof(logString), "%s (%s) editou o pre�o da empresa de ID %d para $%s.", pNome(playerid), GetPlayerUserEx(playerid), businessID, newPrice);
	    logCreate(playerid, logString, 13);
        return 1;
    }  

     // Editar o tipo da empresa
    if(!strcmp(option, "tipo", true) || !strcmp(option, "tipo", true)) {
        new newType = strval(value);

        if (newType < 1 || newType > 7) {
            SendErrorMessage(playerid, "Tipo inv�lido. Tipos de 1 � 7. (/editarempresa [id] [op��o] [tipo]).");
            SendErrorMessage(playerid, "[TIPOS] 1: 24/7 | 2: Ammunation | 3: Loja de roupas | 4: Fast Food | 5: Concession�ria | 6: Posto de gasolina | 7: Firma");
            return 1;
        }
        //Fun��o para editar o tipo da empresa.
        EditTypeBusiness(businessID, newType);

        SendServerMessage(playerid, "Voc� editou o tipo da empresa de ID %d para $%s.", businessID, newType);
        format(logString, sizeof(logString), "%s (%s) editou o tipo da empresa de ID %d para $%s.", pNome(playerid), GetPlayerUserEx(playerid), businessID, newType);
	    logCreate(playerid, logString, 13);
        return 1;
    }
    return 1;
}
// ============================================================================================================================================

CMD:empresa(playerid, params[]) {
    if(!ManagerBusiness(playerid))
        return SendErrorMessage(playerid, "Voc� n�o est� dentro de uma empresa.");

    return 1;
}

CMD:irempresa(playerid, params[]) {
    new id;

    if(GetPlayerAdmin(playerid) < 2)
        return SendPermissionMessage(playerid);

    if(sscanf(params, "d", id))
        return SendSyntaxMessage(playerid, "/irempresa [id]");

    TeleportBusiness(playerid, id);

    return 1;
}

CMD:mundo(playerid, params[]) {
    new worldID = GetPlayerVirtualWorld(playerid);
    SendClientMessage(playerid, COLOR_RED, "Mundo atual %d.", worldID);
}
// ============================================================================================================================================