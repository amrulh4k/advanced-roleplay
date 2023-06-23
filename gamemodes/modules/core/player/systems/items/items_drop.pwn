PlayerDropItem(playerid, slotid) {
    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid)) 
        return SendErrorMessage(playerid, "Voc� n�o pode dropar itens neste momento.");

    if (pInfo[playerid][pInventoryItem] == 999) {
        if(GetMoney(playerid) < 1) return SendErrorMessage(playerid, "Voc� n�o possui dinheiro em m�os.");
        new money = GetMoney(playerid);

        Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "Dinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));
    } else if (pInfo[playerid][iAmount][slotid] == 1) DropPlayerItem(playerid, slotid);
	else Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Item", "Item: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);

    return true;
} 

Dialog:DropItem(playerid, response, listitem, inputtext[]) {
	new slotid = pInfo[playerid][pInventoryItem];

	if (response) {
        if(slotid == 999) {
            new money = GetMoney(playerid);
            if (isnull(inputtext))
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "Dinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));

            if (strval(inputtext) < 1 || strval(inputtext) > money)
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "ERRO: O valor especificado � inv�lido.\n\nDinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));
                
            DropPlayerItem(playerid, slotid, strval(inputtext));
        } else {
            if (isnull(inputtext))
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Item", "Item: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);
                
            if (strval(inputtext) < 1 || strval(inputtext) > pInfo[playerid][iAmount][slotid])
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Item", "ERRO: A quantidade especificada � inv�lida.\n\nItem: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);
                
            DropPlayerItem(playerid, slotid, strval(inputtext));
        }
	}
	return 1;
}

DropPlayerItem(playerid, slotid, quantity = 1) {
    static
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		interior,
        world;

    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
    world = GetPlayerVirtualWorld(playerid);
    interior = GetPlayerInterior(playerid);

    if(slotid == 999){
        va_SendClientMessage(playerid, 0xFF00FFFF, "INFO: Este item desaparecer� no pr�ximo shutdown di�rio.");

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s dropou US$ %s.", pNome(playerid), FormatNumber(quantity));

        format(logString, sizeof(logString), "%s (%s) dropou US$ %s em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), FormatNumber(quantity), GetPlayerLocation(playerid), x, y, z);
        logCreate(playerid, logString, 18);

        DropItem(playerid, -1, -6000, quantity, x, y, z, interior, world);
        GiveMoney(playerid, -quantity);
    } else {
        if(GetPlayerVirtualWorld(playerid) == 0) va_SendClientMessage(playerid, 0xFF00FFFF, "INFO: Este item desaparecer� no pr�ximo shutdown di�rio, apenas itens dropados em interiores n�o somem ap�s o shutdown.");

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s dropou um(a) %s.", pNome(playerid), diInfo[pInfo[playerid][iItem][slotid]][diName]);

        DropItem(playerid, diInfo[pInfo[playerid][iItem][slotid]][diID], diInfo[pInfo[playerid][iItem][slotid]][diModel], quantity, x, y, z, interior, world);

        format(logString, sizeof(logString), "%s (%s) dropou um(a) %s (%d) em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), diInfo[pInfo[playerid][iItem][slotid]][diName], quantity, GetPlayerLocation(playerid), x, y, z);
        logCreate(playerid, logString, 18);

        Inventory_Remove(playerid, slotid, quantity);
    }
    return true;
}

PlayerDropItemWithEdit(playerid, slotid) {

    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid)) 
        return SendErrorMessage(playerid, "Voc� n�o pode dropar itens neste momento.");

    if (pInfo[playerid][pInventoryItem] == 999) {
        if(GetMoney(playerid) < 1) return SendErrorMessage(playerid, "Voc� n�o possui dinheiro em m�os.");
        new money = GetMoney(playerid);

        Dialog_Show(playerid, DropItemWithEdit, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "Dinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));
    } else if (pInfo[playerid][iAmount][slotid] == 1) DropPlayerItemWithEdit(playerid, slotid);
	else Dialog_Show(playerid, DropItemWithEdit, DIALOG_STYLE_INPUT, "Dropar Item", "Item: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);	
	return 1;
}

Dialog:DropItemWithEdit(playerid, response, listitem, inputtext[]) {
	new slotid = pInfo[playerid][pInventoryItem];

	if (response) {
        if(slotid == 999) {
            new money = GetMoney(playerid);
            if (isnull(inputtext))
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "Dinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));

            if (strval(inputtext) < 1 || strval(inputtext) > money)
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Dinheiro", "ERRO: O valor especificado � inv�lido.\n\nDinheiro em m�os: US$ %s\n\nPor favor, especifique quantos d�lares voc� deseja dropar:", "Dropar", "Cancelar", FormatNumber(money));
                
            DropPlayerItemWithEdit(playerid, slotid, strval(inputtext));
        } else {
            if (isnull(inputtext))
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Item", "Item: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);
                
            if (strval(inputtext) < 1 || strval(inputtext) > pInfo[playerid][iAmount][slotid])
                return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, "Dropar Item", "ERRO: A quantidade especificada � inv�lida.\n\nItem: %s - Quantidade: %d\n\nPor favor, especifique a quantidade que voc� deseja dropar deste item:", "Dropar", "Cancelar", diInfo[pInfo[playerid][iItem][slotid]][diName], pInfo[playerid][iAmount][slotid]);
                
            DropPlayerItemWithEdit(playerid, slotid, strval(inputtext));
        }
	}
	return 1;
}

DropPlayerItemWithEdit(playerid, slotid, quantity = 1) {
    static
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		interior,
        world;

    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
    world = GetPlayerVirtualWorld(playerid);
    interior = GetPlayerInterior(playerid);

    if(slotid == 999){
        va_SendClientMessage(playerid, 0xFF00FFFF, "INFO: Este item desaparecer� no pr�ximo shutdown di�rio.");

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s dropou US$ %s.", pNome(playerid), FormatNumber(quantity));

        format(logString, sizeof(logString), "%s (%s) dropou US$ %s em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), FormatNumber(quantity), GetPlayerLocation(playerid), x, y, z);
        logCreate(playerid, logString, 18);

        pInfo[playerid][pEditDropped] = DropItem(playerid, -1, -6000, quantity, x, y, z, interior, world);
        GiveMoney(playerid, -quantity);

        SetTimerEx("EditDynObject", 1000, false, "ii", playerid, DroppedItems[pInfo[playerid][pEditDropped]][droppedObject]);
    } else {
        if(GetPlayerVirtualWorld(playerid) == 0) va_SendClientMessage(playerid, 0xFF00FFFF, "INFO: Este item desaparecer� no pr�ximo shutdown di�rio, apenas itens dropados em interiores n�o somem ap�s o shutdown.");

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s dropou um(a) %s.", pNome(playerid), diInfo[pInfo[playerid][iItem][slotid]][diName]);

        format(logString, sizeof(logString), "%s (%s) dropou um(a) %s (%d) em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), diInfo[pInfo[playerid][iItem][slotid]][diName], quantity, GetPlayerLocation(playerid), x, y, z);
        logCreate(playerid, logString, 18);

        pInfo[playerid][pEditDropped] = DropItem(playerid, diInfo[pInfo[playerid][iItem][slotid]][diID], diInfo[pInfo[playerid][iItem][slotid]][diModel], quantity, x, y, z, interior, world);

        Inventory_Remove(playerid, slotid, quantity);

        SetTimerEx("EditDynObject", 1000, false, "ii", playerid, DroppedItems[pInfo[playerid][pEditDropped]][droppedObject]);
    }
    return true;
}

DropItem(playerid, item, model, quantity, Float:x, Float:y, Float:z, interior, world, weaponid = 0, ammo = 0) {
    for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (!DroppedItems[i][droppedModel]) {
        z = z-1.0;

	    DroppedItems[i][droppedPlayer] = playerid;
		DroppedItems[i][droppedModel] = model;
        DroppedItems[i][droppedItem] = item;
		DroppedItems[i][droppedQuantity] = quantity;
		DroppedItems[i][droppedWeapon] = weaponid;
  		DroppedItems[i][droppedAmmo] = ammo;
		DroppedItems[i][droppedPos][0] = x;
		DroppedItems[i][droppedPos][1] = y;
		DroppedItems[i][droppedPos][2] = z;
		DroppedItems[i][droppedPos][3] = 0.0;
		DroppedItems[i][droppedPos][4] = 0.0;
		DroppedItems[i][droppedPos][5] = 0.0;
        DroppedItems[i][droppedInt] = interior;
		DroppedItems[i][droppedWorld] = world;
        if (IsWeaponModel(model)) {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 93.7, 120.0, 120.0, world, interior);
			DroppedItems[i][droppedPos][3] = 93.7;
			DroppedItems[i][droppedPos][4] = 120.0;
			DroppedItems[i][droppedPos][5] = 120.0;
		} else DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0, world, interior, -1);

        mysql_format(DBConn, query, sizeof query, "INSERT INTO `items_dropped` (\
        `item_id`, \
        `item_player`, \
        `item_model`, \
        `item_quantity`, \
        `item_weapon`, \
        `item_ammo`, \
        `item_int`, \
        `item_world`, \
        `item_positionX`, \
        `item_positionY`, \
        `item_positionZ`) VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%.4f', '%.4f', '%.4f');", item, pInfo[playerid][pID], model, quantity, weaponid, ammo, interior, world, x, y, z);
        new Cache:result = mysql_query(DBConn, query);
        cache_delete(result);
        return i;
    }
    return -1;
}

PickupItem(playerid, itemid) {
	if (itemid != -1 && DroppedItems[itemid][droppedModel]) {
		new id = -1;
        id = Inventory_Add(playerid, DroppedItems[itemid][droppedItem], DroppedItems[itemid][droppedQuantity]);
        if (id == -1) return SendErrorMessage(playerid, "Voc� n�o possui nenhum slot dispon�vel no invent�rio.");
	}
	return true;
}

Dialog:PickupItems(playerid, response, listitem, inputtext[]) {
	if (response) {
	    new id = NearestItems[playerid][listitem];
		if (id != -1) {
		    if (DroppedItems[id][droppedWeapon] != 0) {
  				if (pInfo[playerid][pScore] < 2) return SendErrorMessage(playerid, "Voc� deve possuir ao menos level dois.");
				if (uInfo[playerid][uNewbie] == 1337) return SendErrorMessage(playerid, "Voc� n�o pode ter armas pois � novato.");

                GiveWeaponToPlayer(playerid, DroppedItems[id][droppedWeapon], DroppedItems[id][droppedAmmo]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s pega uma %s do ch�o.", pNome(playerid), ReturnWeaponName(DroppedItems[id][droppedWeapon]));

				format(logString, sizeof(logString), "%s (%s) pegou um(a) %s (%d) [SQL: %d] em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), ReturnWeaponName(DroppedItems[id][droppedWeapon]), DroppedItems[id][droppedAmmo], DroppedItems[id][droppedID], GetPlayerLocation(playerid), DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2]);
        		logCreate(playerid, logString, 18);

				Item_Delete(id);
			} else if(DroppedItems[id][droppedModel] == -6000){
				new quantity = DroppedItems[id][droppedQuantity];

				SendServerMessage(playerid, "Voc� pegou US$ %s do ch�o.", FormatNumber(quantity));

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s pegou US$ %s do ch�o.", pNome(playerid), FormatNumber(quantity));

				format(logString, sizeof(logString), "%s (%s) pegou US$ %s [SQL: %d] em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), FormatNumber(quantity), DroppedItems[id][droppedID], GetPlayerLocation(playerid), DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2]);
        		logCreate(playerid, logString, 18);
				GiveMoney(playerid, quantity);
				Item_Delete(id);
			} else if (PickupItem(playerid, id)) {
				new itemid = DroppedItems[id][droppedItem], quantity = DroppedItems[id][droppedQuantity];
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s pega um(a) %s.", pNome(playerid), diInfo[itemid][diName]);
				SendServerMessage(playerid, "O item foi adicionado ao seu invent�rio.");

                format(logString, sizeof(logString), "%s (%s) pegou um(a) %s (%d) [SQL: %d] em %s (%.4f, %.4f, %.4f)", pNome(playerid), GetPlayerUserEx(playerid), diInfo[itemid][diName], quantity, DroppedItems[id][droppedID], GetPlayerLocation(playerid), DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2]);
        		logCreate(playerid, logString, 18);
				Item_Delete(id);
			} else SendErrorMessage(playerid, "Voc� n�o possui nenhum slot dispon�vel no invent�rio.");

            for (new i = 0; i < MAX_LISTED_ITEMS; i ++) 
                NearestItems[playerid][i] = -1;

		} else SendErrorMessage(playerid, "Este item j� foi pego.");
	} else for (new i = 0; i < MAX_LISTED_ITEMS; i ++) NearestItems[playerid][i] = -1;
	return true;
}