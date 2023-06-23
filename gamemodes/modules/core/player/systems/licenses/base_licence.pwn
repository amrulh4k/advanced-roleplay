/*

Modulo destinado a compor todo o sistema de Licen�as.

Legenda:
STATUS da Licen�a

NENHUM - O
ATIVA - 1
SUSPENSA - 2
REVOGADA - 3


Observa��o de Funcionamento: As licen�as n�o v�o resetar, apenas mudar de STATUS conforme disposto acima.
A licen�a ser� gerada quando o jogador escolher qual teste ir� fazer primeiro (Moto, Carro, Caminh�o) e
ir� sofrer um "UPGRADE" sempre que o jogador for tirar a pr�xima.

*/
hook OnGameModeInit() {
	CreateDMVIcon();
    return true;
}

CMD:criarlicenca(playerid, params[]){
	CreateNewLicense(playerid);
	return true;
}

CMD:mostrarlicenca(playerid, params[]) {
	if(pInfo[playerid][pLicense] == 0) return SendErrorMessage(playerid,"Voc� n�o tem uma licen�a de motorista.");
	
	for(new i; i < MAX_DRIVERLICENCE; i++) if(pLicenses[i][license_owner] == pInfo[playerid][pID]) {
		new status[20],
			status_car[20],
			status_medical[20],
			status_plane[20],
			status_gun[20];

		switch(pLicenses[i][license_status]){
			case 0: status = "NENHUM";
			case 1: status = "ATIVA";
			case 2: status = "SUSPENSA";
			case 3: status = "REVOGADA";
		}
		switch(pLicenses[i][license_vehicle]){
			case 0: status_car = "N�o";
			case 1: status_car = "Sim";
		}
		switch(pLicenses[i][license_medical]){
			case 0: status_medical = "N�o";
			case 1: status_medical = "Sim";
		}
		switch(pLicenses[i][license_plane]){
			case 0: status_plane = "N�o";
			case 1: status_plane = "Sim";
		}
		switch(pLicenses[i][license_gun]){
			case 0: status_gun = "N�o";
			case 1: status_gun = "Sim";
		}
		new avisos = CountLicenseWarnings(i);

		new targetid;
		if(sscanf(params, "u", targetid)){
			va_SendClientMessage(playerid, COLOR_GREEN,"|_______________Licen�as_____________|");
			va_SendClientMessage(playerid, COLOR_GREY, "Nome: %s", GetPlayerNameEx(playerid));
			va_SendClientMessage(playerid, COLOR_GREY, "N�mero: %d", pLicenses[i][license_number]);
			va_SendClientMessage(playerid, COLOR_GREY, "Status: %s", status);
			va_SendClientMessage(playerid, COLOR_GREY, "Tipos: (Ve�culos: %s) | (Avi�es: %s) | (M�dica: %s) | (Armas: %s)", status_car, status_plane, status_medical, status_gun);
			va_SendClientMessage(playerid, COLOR_GREY, "Advert�ncias: (%d/3)", avisos);
			va_SendClientMessage(playerid, COLOR_GREEN,"(Licen�a Motorista):{FFFFFF} Voc� pode mostrar sua licen�a para outro jogador. Use '/licencamotorista playerID'.");
		}else{
			if(!pInfo[targetid][pLogged]) return SendErrorMessage(playerid, "Este jogador n�o est� logado.");
			if (!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendErrorMessage(playerid, "Voc� n�o est� perto deste player.");
			if (playerid == targetid) return SendErrorMessage(playerid, "Voc� n�o pode mostrar sua licen�a para voc� mesmo.");

			va_SendClientMessage(targetid, COLOR_GREY,"|_______________Licen�as_____________|");
			va_SendClientMessage(targetid, COLOR_GREY, "Nome: %s", GetPlayerNameEx(playerid));
			va_SendClientMessage(targetid, COLOR_GREY, "N�mero: %d", pLicenses[i][license_number]);
			va_SendClientMessage(targetid, COLOR_GREY, "Status: %s", status);
			va_SendClientMessage(playerid, COLOR_GREY, "Tipos: (Ve�culos: %s) | (Avi�es: %s) | (M�dica: %s) | (Armas: %s)", status_car, status_plane, status_medical, status_gun);
			va_SendClientMessage(targetid, COLOR_GREY, "Advert�ncias: (%d/3)", avisos);
		}
	}
	return true;
}

//Lembrar de Adicionar a fun��o de apenas fac policial poder usar
CMD:removeravisoslicenca(playerid, params[]) {
    new targetid; 

    if(sscanf(params, "u", targetid)) return SendSyntaxMessage(playerid, "/removeravisoslicenca [playerID/Nome]");
	
	if(!pInfo[targetid][pLogged]) return SendErrorMessage(playerid, "Este jogador n�o est� logado.");
	if (!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendErrorMessage(playerid, "Voc� n�o est� perto deste player.");
	if (playerid == targetid) return SendErrorMessage(playerid, "Voc� n�o pode remover os avisos da sua licen�a.");
  
    va_SendClientMessage(playerid, COLOR_GREEN, "(Licen�a):{FFFFFF} Voc� limpou os avisos da licen�a de %s.", GetPlayerNameEx(targetid));
	va_SendClientMessage(targetid, COLOR_GREEN, "(Licen�a):{FFFFFF} O oficial %s limpou os avisos na sua licen�a.", GetPlayerNameEx(playerid));
    ResetLicenseWarnings(targetid);
	return true;
}

CreateDMVIcon(){
	new string[24];
	CreatePickup(1239, 1, 1490.3473, 1306.2144, 1093.2964, 0);
	format(string, sizeof(string), "/iniciarteste");
	Create3DTextLabel(string, COLOR_WHITE, 1490.3473, 1306.2144, 1093.2964, 20.0, 0);
}