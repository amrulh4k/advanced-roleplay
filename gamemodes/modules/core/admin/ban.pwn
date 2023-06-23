/*

Este m�dulo � dedicado ao sistema de banimentos, os comandos est�o no topo e a estrutura��o de m�todos, etc., embora poucos, est�o no final.
O salvamento de tempo � feito por timestamp (segundos desde 1970), e formatado pelo m�dulo utils_time.pwn
Se um jogador tiver o `unbanned_time` como 0, o sistema considerar� que o banimento foi permanente.

*/

#include <YSI_Coding\y_hooks>

CMD:ban(playerid, params[]) {
    new id, reason[128]; 

    // Checar condi��es anormais
    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "us[128]", id, reason)) return SendSyntaxMessage(playerid, "/ban [player] [motivo]");
    if(uInfo[playerid][uAdmin] < uInfo[playerid][uAdmin]) return SendErrorMessage(playerid, "Voc� n�o pode banir este jogador!");
    if(!IsPlayerConnected(id)) return SendNotConnectedMessage(playerid);

    // Inserir o banimento na database
    mysql_format(DBConn, query, sizeof query, "INSERT INTO ban (`banned_id`, `admin_name`, `reason`, \
        `ban_date`, `unban_date`) VALUES ('%d', '%s', '%s', %d, 0)", uInfo[id][uID], uInfo[playerid][uName], reason, _:Now());
    mysql_query(DBConn, query);

    // Printar
    va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s baniu %s (%s) permanentemente. Motivo: %s.", uInfo[playerid][uName], 
    GetPlayerNameEx(id), uInfo[id][uName], reason);
    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� baniu o usu�rio %s com sucesso.", uInfo[id][uName]);
    SendServerMessage(id, "(( Voc� foi banido do servidor ))");
    ShowBannedTextdraws(id);

    format(logString, sizeof(logString), "%s (%s) baniu %s (%s) por %s.", pNome(playerid), GetPlayerUserEx(playerid), pNome(id), GetPlayerUserEx(id), reason);
	logCreate(playerid, logString, 1);

    format(logString, sizeof(logString), "%s (%s) banido por %s (motivo: %s)", pNome(id), GetPlayerUserEx(id), GetPlayerUserEx(playerid), reason);
	logCreate(id, logString, 11);

    KickEx(id);
    return true;
}

CMD:banoff(playerid, params[]) {
    new userName[24], reason[128], adminID, userID;

    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "s[24]s[128]", userName, reason)) return SendSyntaxMessage(playerid, "/banoff [usu�rio] [motivo]");
    
    // Checar se o usu�rio j� est� online em algum dos personagens ou selecionando eles.

    foreach(new i : Player) {
        if(!strcmp(uInfo[i][uName], userName)) { 
            va_SendClientMessage(playerid, COLOR_LIGHTRED, "Este usu�rio j� est� conectado no servidor. (Nick: %s, ID: %d)", GetPlayerNameEx(i), i);
            return SendSyntaxMessage(playerid, "/ban [player] [motivo]");
        }
    }

    // Checar se o usu�rio existe, n�vel de admin, etc.

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM users WHERE `username` = '%s';", userName);
    mysql_query(DBConn, query);

    if(!cache_num_rows()) return SendErrorMessage(playerid, "N�o foi poss�vel encontrar um usu�rio com este nome no banco de dados.");
    
    cache_get_value_name_int(0, "ID", userID);
    cache_get_value_name_int(0, "admin", adminID);
    if(uInfo[playerid][uAdmin] < adminID) return SendErrorMessage(playerid, "Voc� n�o pode banir este jogador!");

    // Checar se o usu�rio j� est� banido.

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d' AND \
        `banned` = 1;", userID, _:Now());
    mysql_query(DBConn, query);

    if(cache_num_rows()) return SendErrorMessage(playerid, "N�o foi poss�vel banir este jogador porque ele j� est� cumprindo um banimento.");

    // Banir, enfim.

    mysql_format(DBConn, query, sizeof query, "INSERT INTO ban (`banned_id`, `admin_name`, `reason`, \
        `ban_date`, `unban_date`) VALUES ('%d', '%s', '%s', %d, 0)", userID, uInfo[playerid][uName], reason, _:Now());
    mysql_query(DBConn, query);

    va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s baniu %s de modo offline e permanentemente. Motivo: %s.", uInfo[playerid][uName], userName, reason);
    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� baniu (offline) o usu�rio %s com sucesso.", userName);

    format(logString, sizeof(logString), "%s (%s) baniu %s off-line por %s.", pNome(playerid), GetPlayerUserEx(playerid), userName, reason);
	logCreate(playerid, logString, 1);

    new string[512];
    format(string, sizeof(string), "%s banido off-line por %s (motivo: %s)", userName, GetPlayerUserEx(playerid), reason);

    mysql_format(DBConn, query, sizeof query, "INSERT INTO serverlogs (`user`, `timestamp`, `log`, `type`) VALUES ('%s', '%d', '%s', '%d')", 
        userName, gettime(), string, 11);
    mysql_query(DBConn, query);

    return true;
}

CMD:bantemp(playerid, params[]) {
    new id, days, reason[128]; 

    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "uds[128]", id, days, reason)) return SendSyntaxMessage(playerid, "/ban [player] [motivo]");
    if(uInfo[playerid][uAdmin] < uInfo[playerid][uAdmin]) return SendErrorMessage(playerid, "Voc� n�o pode banir este jogador!");
    if(!IsPlayerConnected(id)) return SendNotConnectedMessage(playerid);
    if(!days) return SendErrorMessage(playerid, "Um jogador s� pode ser banido temporariamente por, no m�nimo, 1 dia.");

    mysql_format(DBConn, query, sizeof query, "INSERT INTO ban (`banned_id`, `admin_name`, `reason`, \
        `ban_date`, `unban_date`) VALUES ('%d', '%s', '%s', %d, %d)", 
        uInfo[id][uID], uInfo[playerid][uName], reason, _:Now(), _:Now() + (86400 * days));
    mysql_query(DBConn, query);
    
    va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s baniu %s (%s) por %d dias. Motivo: %s.", uInfo[playerid][uName], GetPlayerNameEx(id), uInfo[id][uName], days, reason);
    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� baniu o usu�rio %s com sucesso.", uInfo[id][uName]);
    SendServerMessage(id, "(( Voc� foi banido do servidor ))");
    
    format(logString, sizeof(logString), "%s (%s) baniu %s (%s) [%d dias] por %s.", pNome(playerid), GetPlayerUserEx(playerid), pNome(id), GetPlayerUserEx(id), days, reason);
	logCreate(playerid, logString, 1);

    format(logString, sizeof(logString), "%s (%s) banido temporariamente por %s (dias: %d, motivo: %s)", pNome(id), GetPlayerUserEx(id), GetPlayerUserEx(playerid), days, reason);
	logCreate(id, logString, 11);
    ShowBannedTextdraws(id);
    KickEx(id);
    return true;
}

CMD:bantempoff(playerid, params[]) {
    new userName[24], reason[128], days, adminID, userID;

    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "s[24]ds[128]", userName, days, reason)) return SendSyntaxMessage(playerid, "/bantempoff [usu�rio] [dias] [motivo]");
    if(!days) return SendErrorMessage(playerid, "Um jogador s� pode ser banido temporariamente por, no m�nimo, 1 dia.");

    // Checar se o usu�rio j� est� online em algum dos personagens ou selecionando eles.

    foreach(new i : Player) {
        if(!strcmp(uInfo[i][uName], userName)) { 
            va_SendClientMessage(playerid, COLOR_LIGHTRED, "Este usu�rio j� est� conectado no servidor. (Nick: %s, ID: %d)", GetPlayerNameEx(i), i);
            return SendSyntaxMessage(playerid, "/bantemp [player] [dias] [motivo]");
        }
    }

    // Checar se o usu�rio existe, n�vel de admin, etc.

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM users WHERE `username` = '%s';", userName);
    mysql_query(DBConn, query);

    if(!cache_num_rows()) return SendErrorMessage(playerid, "N�o foi poss�vel encontrar um usu�rio com este nome no banco de dados.");
    
    cache_get_value_name_int(0, "ID", userID);
    cache_get_value_name_int(0, "admin", adminID);
    if(uInfo[playerid][uAdmin] < adminID) return SendErrorMessage(playerid, "Voc� n�o pode banir este jogador!");

    // Checar se o usu�rio j� est� banido.

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d' AND \
        `banned` = 1;", userID);
    mysql_query(DBConn, query);

    if(cache_num_rows()) return SendErrorMessage(playerid, "N�o foi poss�vel banir este jogador porque ele j� est� cumprindo um banimento.");

    // Banir, enfim.

    mysql_format(DBConn, query, sizeof query, "INSERT INTO ban (`banned_id`, `admin_name`, `reason`, \
        `ban_date`, `unban_date`) VALUES ('%d', '%s', '%s', %d, %d)", 
        userID, uInfo[playerid][uName], reason, _:Now(), _:Now() + (86400 * days));
    mysql_query(DBConn, query);

    va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s baniu %s de modo offline por %d dias. Motivo: %s.", uInfo[playerid][uName], userName, days, reason);
    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� baniu (offline) o usu�rio %s com sucesso.", userName);

    format(logString, sizeof(logString), "%s (%s) baniu %s [%d dias] por %s.", pNome(playerid), GetPlayerUserEx(playerid), userName, days, reason);
	logCreate(playerid, logString, 1);

    new string[512];
    format(string, sizeof(string), "%s banido off-line temporariamente por %s (dias: %d, motivo: %s)", userName, GetPlayerUserEx(playerid), days, reason);

    mysql_format(DBConn, query, sizeof query, "INSERT INTO serverlogs (`user`, `timestamp`, `log`, `type`) VALUES ('%s', '%d', '%s', '%d')", 
        userName, gettime(), string, 11);
    mysql_query(DBConn, query);

    new ls[512];
    format(ls, 512, "```[%s] %s```", GetFullDate(gettime()), string);
    utf8encode(ls, ls);
    DCC_SendChannelMessage(logChannels[10], ls);
    return true;
}

CMD:desban(playerid, params[]) {
    new userName[24], userID;

    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "s[24]", userName)) return SendSyntaxMessage(playerid, "/desban [usuario]");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM users WHERE `username` = '%s'", userName);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "Esse usu�rio n�o existe.");
    cache_get_value_name_int(0, "ID", userID);

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d' AND `banned` = 1;", userID);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "N�o foi poss�vel encontrar nenhum usu�rio banido com este nome.");

    mysql_format(DBConn, query, sizeof query, "UPDATE ban SET `banned` = 0, `unban_date` = '%d', `unban_admin` = '%s' WHERE `banned_id` = '%d' AND `banned` = 1", _:Now(), uInfo[playerid][uName], userID);
    mysql_query(DBConn, query);

    va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s desbaniu %s.", uInfo[playerid][uName], userName);
    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� desbaniu o usu�rio %s com sucesso.", userName);

    format(logString, sizeof(logString), "%s (%s) desbaniu %s.", pNome(playerid), GetPlayerUserEx(playerid), userName);
	logCreate(playerid, logString, 1);

    new string[512];
    format(string, sizeof(string), "%s desbanido por %s", userName, GetPlayerUserEx(playerid));

    mysql_format(DBConn, query, sizeof query, "INSERT INTO serverlogs (`user`, `timestamp`, `log`, `type`) VALUES ('%s', '%d', '%s', '%d')", 
        userName, gettime(), string, 11);
    mysql_query(DBConn, query);

    new ls[512];
    format(ls, 512, "```[%s] %s```", GetFullDate(gettime()), string);
    utf8encode(ls, ls);
    DCC_SendChannelMessage(logChannels[10], ls);
    return true;
}

CMD:checarban(playerid, params[]) {
    new userName[24], userID;

    if(uInfo[playerid][uAdmin] < 2) return SendPermissionMessage(playerid);
    if(sscanf(params, "s[24]", userName)) return SendSyntaxMessage(playerid, "/checarban [usuario]");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM users WHERE `username` = '%s';", userName);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "Esse usu�rio n�o existe.");
    cache_get_value_name_int(0, "ID", userID);

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d';", userID);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "O usu�rio especificado n�o tem nenhum banimento registrado.");

    // Pegar informa��es dos banimentos em vari�veis e usar de um loop pra informar tudo

    new adminName[24], reason[128], ban_date, unban_date, unban_admin[24], banned;

    va_SendClientMessage(playerid, COLOR_GREEN, "Banimentos de %s:", userName);
    for(new i; i < cache_num_rows(); i++) {
        cache_get_value_name(i, "admin_name", adminName);
        cache_get_value_name(i, "reason", reason);
        cache_get_value_name_int(i, "ban_date", ban_date);
        cache_get_value_name_int(i, "unban_date", unban_date);
        cache_get_value_name(i, "unban_admin", unban_admin);
        cache_get_value_name_int(i, "banned", banned);

        va_SendClientMessage(playerid, banned > 0 ? (COLOR_LIGHTRED) : (COLOR_GREY), " Banido por %s | Motivo: %s | Data do banimento: %s | \
            Data do desbanimento: %s | %s", adminName, reason, GetFullDate(ban_date), 
            unban_date > 0 ? (GetFullDate(unban_date)) : ("Permanente"), banned > 0 ? ("**Cumprindo**") : ("Desbanido por %s", unban_admin));
    }
    return true;
}
alias:checarban("checarbans")

CMD:limparhistoricobans(playerid, params[]) {
    new userName[24], userID;

    if(uInfo[playerid][uAdmin] < 5) return SendPermissionMessage(playerid);
    if(sscanf(params, "s[24]", userName)) return SendSyntaxMessage(playerid, "/limparhistoricobans [usuario]");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM users WHERE `username` = '%s'", userName);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "Esse usu�rio n�o existe.");
    cache_get_value_name_int(0, "ID", userID);

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d';", userID);
    mysql_query(DBConn, query);
    if(!cache_num_rows()) return SendErrorMessage(playerid, "O usu�rio especificado n�o tem nenhum banimento registrado.");

    va_SendClientMessage(playerid, COLOR_GREEN, "Voc� apagou %d banimentos do usu�rio %s.", cache_num_rows(), userName);

    mysql_format(DBConn, query, sizeof query, "DELETE FROM ban WHERE `banned_id` = '%d';", userID);
    mysql_query(DBConn, query);  

    format(logString, sizeof(logString), "%s (%s) apagou %d banimentos do usu�rio %s.", pNome(playerid), GetPlayerUserEx(playerid), cache_num_rows(), userName);
	logCreate(playerid, logString, 1);  
    return true;
}
alias:limparhistoricobans("limparhistoricoban")

// Checar se o usu�rio est� banido.
CheckUserBan(playerid) {
    new adminName[24], reason[128], ban_date, unban_date,
        bigString[1024];

    UpdateUnbannedUsers();

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM ban WHERE `banned_id` = '%d' AND `banned` = 1;", GetUserSQLID(playerid));
    mysql_query(DBConn, query);
    if(!cache_num_rows())
        return true;

    HideLoginTextdraws(playerid);
    HideCharacterTextdraws(playerid);

    // Armazenar informa��es do banimento em vari�veis
    cache_get_value_name(0, "admin_name", adminName);
    cache_get_value_name(0, "reason", reason);
    cache_get_value_name_int(0, "ban_date", ban_date);
    cache_get_value_name_int(0, "unban_date", unban_date);

    // Formatar a string com as informa��es anteriores
    format(bigString, sizeof bigString, "{FFFFFF}Voc� foi banido %sdo servidor.\n\nUsu�rio: %s\nData de banimento: %s\nData de desbanimento: %s\nBanido por: %s\n\
    Motivo: %s\n \nSe voc� acha que isso foi um engano, recorra a um apelo no f�rum.", 
        unban_date > 0 ? ("temporariamente ") : (""), GetPlayerUserEx(playerid), GetFullDate(ban_date), 
        unban_date > 0 ? (GetFullDate(unban_date)) : ("Banimento permanente"), adminName, reason);

    Dialog_Show(playerid, DialogBan, DIALOG_STYLE_MSGBOX, " ", bigString, "Entendi", "");

    ShowBannedTextdraws(playerid);
    ClearPlayerChat(playerid);
    KickEx(playerid);
    return true;
}

void:UpdateUnbannedUsers() {
    mysql_format(DBConn, query, sizeof query, "UPDATE ban SET `banned` = 0 WHERE `banned` = 1 AND `unban_date` <> 0 AND `unban_date` <= %d;", 
        _:Now());
    mysql_query(DBConn, query);
}