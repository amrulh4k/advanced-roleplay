#include <YSI_Coding\y_hooks>

CMD:investimentos(playerid, params[]){
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM tradings_owners WHERE `character_id` = '%d';", GetPlayerSQLID(playerid));
    new Cache:result = mysql_query(DBConn, query);
    if(cache_num_rows()) return Dialog_Show(playerid, tradingInit, DIALOG_STYLE_LIST, "Central de Investimentos", "A��es\nCripto\nCommodities\n \n{36A717}Gerenciar investimentos", "Selecionar", "Fechar");
    cache_delete(result);

    Dialog_Show(playerid, tradingInit, DIALOG_STYLE_LIST, "Central de Investimentos", "A��es\nCripto\nCommodities", "Selecionar", "Fechar");
    return true;
} 

CMD:criarinvestimento(playerid, params[]){
    if(GetPlayerAdmin(playerid) < 3 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);
	
    static
	    type,
	    name[64];

	if (sscanf(params, "ds[64]", type, name)) return SendSyntaxMessage(playerid, "/criarinvestimento [tipo] [nome]");
    if(type < 1 || type > 3) return SendErrorMessage(playerid, "O tipo deve veriar entre um e tr�s.");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM tradings WHERE `name` = '%s';", name);
    new Cache:result = mysql_query(DBConn, query);
    if(cache_num_rows()) return SendErrorMessage(playerid, "J� existe um investimento com esse nome.");
    cache_delete(result);

	InvestmentCreate(playerid, type, name);
	return true;
}

CMD:editarinvestimento(playerid, params[]){
    if(GetPlayerAdmin(playerid) < 3 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

    static
	    id,
	    type[24],
	    string[128];

    if (sscanf(params, "ds[24]S()[128]", id, type, string)) {
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarinvestimento [id] [op��o]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: nome, s�mbolo, descri��o, tipo, capital");
        SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: valorcompra, maxslots");
		return true;
	}

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM tradings WHERE `ID` = '%d'", id);
    new Cache:resultid = mysql_query(DBConn, query);

    if(!cache_num_rows()) return SendErrorMessage(playerid, "Investimento inexistente.");
    cache_delete(resultid);

    if (!strcmp(type, "nome", true)) {
	    new name[64];

	    if (sscanf(string, "s[64]", name))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [nome] [novo nome]");

        mysql_format(DBConn, query, sizeof query, "SELECT * FROM tradings WHERE `name` = '%s';", name);
        new Cache:result = mysql_query(DBConn, query);
        if(cache_num_rows()) return SendErrorMessage(playerid, "J� existe um investimento com esse nome.");
        cache_delete(result);

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `name` = '%s' WHERE `id` = '%d';", name, id);
        mysql_query(DBConn, query);
    
        SendServerMessage(playerid, "Voc� alterou o nome do investimento ID %d para %s.", id, name);

        format(logString, sizeof(logString), "%s (%s) alterou o nome do investimento ID %d para %s", pNome(playerid), GetPlayerUserEx(playerid), id, name);
	    logCreate(playerid, logString, 1);
	}
	else if (!strcmp(type, "s�mbolo", true) || !strcmp(type, "simbolo", true)) {
	    new symbol[16];

	    if (sscanf(string, "s[16]", symbol))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [s�mbolo] [novo s�mbolo]");

        mysql_format(DBConn, query, sizeof query, "SELECT * FROM tradings WHERE `symbol` = '%s';", symbol);
        new Cache:result = mysql_query(DBConn, query);
        if(cache_num_rows()) return SendErrorMessage(playerid, "J� existe um investimento com esse s�mbolo.");
        cache_delete(result);

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `symbol` = '%s' WHERE `id` = '%d';", symbol, id);
        mysql_query(DBConn, query);
    
        SendServerMessage(playerid, "Voc� alterou o s�mbolo do investimento ID %d para %s.", id, symbol);

        format(logString, sizeof(logString), "%s (%s) alterou o s�mbolo do investimento ID %d para %s", pNome(playerid), GetPlayerUserEx(playerid), id, symbol);
	    logCreate(playerid, logString, 1);
	}
    else if (!strcmp(type, "descricao", true) || !strcmp(type, "descri��o", true)) {
	    new description[124];

	    if (sscanf(string, "s[124]", description))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [descri��o] [nova descri��o]");

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `description` = '%s' WHERE `id` = '%d';", description, id);
        mysql_query(DBConn, query);
    
        SendServerMessage(playerid, "Voc� alterou a descri��o do investimento ID %d.", id);

        format(logString, sizeof(logString), "%s (%s) alterou a descri��o do investimento ID %d para %s", pNome(playerid), GetPlayerUserEx(playerid), id, description);
	    logCreate(playerid, logString, 1);
	}
    else if (!strcmp(type, "tipo", true)) {
	    new type2, string2[64];

	    if (sscanf(string, "d", type2))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [tipo] [novo tipo]");

        if(type2 < 1 || type2 > 3) return SendErrorMessage(playerid, "O tipo deve veriar entre um e tr�s.");

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `type` = '%d' WHERE `id` = '%d';", type2, id);
        mysql_query(DBConn, query);

        switch(type2) {
            case 1: format(string2, sizeof(string2), "a��o");
            case 2: format(string2, sizeof(string2), "cripto");
            case 3: format(string2, sizeof(string2), "commodity");
        }

        SendServerMessage(playerid, "Voc� alterou o tipo do investimento ID %d para %s.", id, string2);

        format(logString, sizeof(logString), "%s (%s) alterou o tipo do investimento ID %d para %s", pNome(playerid), GetPlayerUserEx(playerid), id, string2);
	    logCreate(playerid, logString, 1);
	}
    else if (!strcmp(type, "capital", true)) {
	    new Float:capital;

	    if (sscanf(string, "f", capital))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [capital] [nova capital]");

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `capital` = '%f' WHERE `id` = '%d';", capital, id);
        mysql_query(DBConn, query);

        SendServerMessage(playerid, "Voc� alterou a capital do investimento ID %d para US$ %s.", id, FormatFloat(capital));

        format(logString, sizeof(logString), "%s (%s) alterou a capital do investimento ID %d para US$ %s", pNome(playerid), GetPlayerUserEx(playerid), id, FormatFloat(capital));
	    logCreate(playerid, logString, 1);
	}
    else if (!strcmp(type, "valorcompra", true)) {
	    new Float:buy_value;

	    if (sscanf(string, "f", buy_value))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [valorcompra] [novo valor de compra]");

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `buy_value` = '%f', `sell_value` = '%f' WHERE `id` = '%d';", buy_value, buy_value, id);
        mysql_query(DBConn, query);

        SendServerMessage(playerid, "Voc� alterou o valor de compra do investimento ID %d para US$ %s.", id, FormatFloat(buy_value));

        format(logString, sizeof(logString), "%s (%s) alterou o valor de compra do investimento ID %d para US$ %s", pNome(playerid), GetPlayerUserEx(playerid), id, FormatFloat(buy_value));
	    logCreate(playerid, logString, 1);
	}
    else if (!strcmp(type, "maxslots", true)) {
	    new maxslots;

	    if (sscanf(string, "d", maxslots))
	        return SendSyntaxMessage(playerid, "/editarinvestimento [id] [maxslots] [novo m�ximo de slots]");

        mysql_format(DBConn, query, sizeof query, "UPDATE `tradings` SET `max_slots` = '%d' WHERE `id` = '%d';", maxslots, id);
        mysql_query(DBConn, query);

        SendServerMessage(playerid, "Voc� alterou o m�ximo de slots do investimento ID %d para %d.", id, maxslots);

        format(logString, sizeof(logString), "%s (%s) alterou o m�ximo de slots do investimento ID %d para %d", pNome(playerid), GetPlayerUserEx(playerid), id, maxslots);
	    logCreate(playerid, logString, 1);
	}
    return true;
}

CMD:deletarinvestimento(playerid, params[]){
    new id;
    if(GetPlayerAdmin(playerid) < 5 || !GetUserTeam(playerid, 2)) return SendPermissionMessage(playerid);

    if (sscanf(params, "d", id)) return SendSyntaxMessage(playerid, "/deletarinvestimento [id]");
    if(!IsValidInvestment(id))  return SendErrorMessage(playerid, "Esse ID de investimento n�o existe.");

    mysql_format(DBConn, query, sizeof query, "DELETE FROM `tradings` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    SendServerMessage(playerid, "Voc� deletou o investimento ID %d.", id);

    format(logString, sizeof(logString), "%s (%s) deletou o investimento ID %d", pNome(playerid), GetPlayerUserEx(playerid), id);
	logCreate(playerid, logString, 1);
    return true;
}

CMD:atualizarinvestimentos(playerid, params[]){
    if(GetPlayerAdmin(playerid) < 1337) return SendPermissionMessage(playerid);

    InvestmentUpdate();
    
    SendServerMessage(playerid, "Voc� for�ou a atualiza��o de todos os investimentos.");
    format(logString, sizeof(logString), "%s (%s) for�ou a atualiza��o de todos os investimentos.", pNome(playerid), GetPlayerUserEx(playerid));
	logCreate(playerid, logString, 1);
    return true;
}