CMD:id(playerid, params[])
{
    if (isnull(params))
        return SendSyntaxMessage(playerid, "/id [id/nome]");

    if(IsNumeric(params)){
        new userid = strval(params);

        if(userid < 0 || userid >= MAX_PLAYERS)
            return SendErrorMessage(playerid, "Escolha um playerid v�lido.");
        if(userid == INVALID_PLAYER_ID || !pInfo[userid][pLogged])
            return SendErrorMessage(playerid, "Este jogador n�o est� conectado.");
        va_SendClientMessage(playerid, COLOR_GREY, "%s [%d] (level %d)", pNome(userid), userid, pInfo[userid][pScore]);
    } else {
        new count;

        foreach (new i : Player) {
            if (strfind(pNome(i), params, true) != -1) {
                va_SendClientMessage(playerid, COLOR_GREY, "%s [%d] (level %d)", pNome(i), i, pInfo[i][pScore]);
                count++;
            }
        }
        if (!count)
            return SendErrorMessage(playerid, "Nenhum resultado foi encontrado com os crit�rios: \"%s\".", params);
    }

    return true;
}