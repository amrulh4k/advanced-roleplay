CMD:usardroga(playerid, params[]) {
	if(PlayerDrugData[playerid][DrugsCooldown] > gettime()) return SendErrorMessage(playerid, "Voc� n�o pode usar drogas agora.");

	new amount, drug[64];
	if(sscanf(params, "is[64]", amount, drug)) return SendSyntaxMessage(playerid, "/usardroga [gramas] [nome da droga]");

    new item_id = GetItemID(drug);

    if(!IsDrugItemByID(item_id))
		return SendErrorMessage(playerid, "%s n�o � uma droga v�lida. Veja as drogas dispon�veis no seu invent�rio. O nome da droga deve ser igual ao exibido no invent�rio, incluindo a acentua��o.", drug);

	if(!(0 < amount <= 10)) return SendErrorMessage(playerid, "Voc� n�o pode usar menos de 1g ou mais de 10g por vez.");
    
    if(Inventory_Drug_Count(playerid, drug) < amount)
		return SendErrorMessage(playerid, "Voc� n�o possui %dg de %s.", amount, drug);

	PlayerDrugData[playerid][DrugsCooldown] = gettime() + (60 * amount);
	PlayerDrugData[playerid][Drugs] -= amount;
	PlayerDrugData[playerid][TotalUsed] += amount;

    Inventory_Remove(playerid, Inventory_Drug_Slot(playerid, drug), amount);

	SetPlayerWeather(playerid, 234);
	RegenTimer[playerid] = SetTimerEx("RegenHealth", 500, false, "ii", playerid, (5 * amount));
	EffectTimer[playerid] = SetTimerEx("RemoveEffects", (10 * amount) * 1000, false, "i", playerid);
	
    va_SendClientMessage(playerid, COLOR_YELLOW, "DROGAS: Voc� usou %dg de %s.", amount, drug);
	return true;
}