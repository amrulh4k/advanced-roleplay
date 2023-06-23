Dialog:DIALOG_DMV_ROUTE(playerid, response, listitem, inputtext[]) {
	if(!response) return true;

    if (GetMoney(playerid) < DMV_VEHICLE_VALUE) return SendErrorMessage(playerid, "Voc� n�o tem dinheiro suficiente.");
    if (pLicenses[playerid][license_vehicle] == 1) return SendErrorMessage(playerid, "Voc� j� possui uma licen�a de motorista v�lida.");

	DMVTestType[playerid] = listitem+1;
	StartTestingLicense(playerid);
	return true;
}