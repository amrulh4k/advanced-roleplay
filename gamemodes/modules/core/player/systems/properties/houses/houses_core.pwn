#include <YSI_Coding\y_hooks>

#define MAX_HOUSES          1000
#define MAX_SECOND_ENTRIES  5000

enum E_HOUSE_DATA {
    hID,                // ID da casa no MySQL
    hOwner,             // ID do personagem dono da casa
    hAddress[256],      // Endere�o
    hGarage,            // ID da garagem atrelada a casa CASO EXISTA
    bool:hLocked,       // Trancado 
    hRentable,          // Alugavel
    hRent,              // Pre�o do aluguel
    hPrice,             // Pre�o de venda (pelo servidor)
    hStorageMoney,      // Dinheiro guardado
    Float:hExitPos[4],  // Posi��es (X, Y, Z, A) do interior
    vwExit,             // VW do interior
    interiorExit,       // Interior do interior
    Float:hEntryPos[4], // Posi��es (X, Y, Z, A) do exterior
    vwEntry,            // VW do exterior
    interiorEntry,      // Interior do exterior
};

new hInfo[MAX_HOUSES][E_HOUSE_DATA];

enum E_SECOND_ENTRIES_DATA {
    sID,                // ID da entrada no MySQL
    sHouseID,           // ID da casa que essa entrada pertence
    bool:sLocked,       // Trancado 
    Float:sExitPos[4],  // Posi��es (X, Y, Z, A) do interior
    sExitVW,            // VW do interior
    sExitInterior,      // Interior do interior
    Float:sEntryPos[4], // Posi��es (X, Y, Z, A) do exterior
    sEntryVW,           // VW do exterior
    sEntryInterior,     // Interior do exterior
};

new sInfo[MAX_SECOND_ENTRIES][E_SECOND_ENTRIES_DATA];

// ============================================================================================================================================

hook OnGameModeInit() {
    LoadHouses();
    LoadEntries();
    return 1;
}

hook OnGamemodeExit() {
    SaveHouses();
    SaveEntries();
    return 1;
}

// ============================================================================================================================================
//Carrega todas �s casas.
LoadHouses() {
    new loadedHouses;

    mysql_query(DBConn, "SELECT * FROM `houses`;");

    for(new i; i < cache_num_rows(); i++) {
        new id;
        cache_get_value_name_int(i, "id", id);
        hInfo[id][hID] = id;

        cache_get_value_name_int(i, "character_id", hInfo[id][hOwner]);
        cache_get_value_name(i, "address", hInfo[id][hAddress]);
        cache_get_value_name_int(i, "garage_id", hInfo[id][hGarage]);
        cache_get_value_name_int(i, "locked", hInfo[id][hLocked]);
        cache_get_value_name_int(i, "price", hInfo[id][hPrice]);
        cache_get_value_name_int(i, "storage_money", hInfo[id][hStorageMoney]);
        cache_get_value_name_float(i, "entry_x", hInfo[id][hEntryPos][0]);
        cache_get_value_name_float(i, "entry_y", hInfo[id][hEntryPos][1]);
        cache_get_value_name_float(i, "entry_z", hInfo[id][hEntryPos][2]);
        cache_get_value_name_float(i, "entry_a", hInfo[id][hEntryPos][3]);
        cache_get_value_name_int(i, "vw_entry", hInfo[id][vwEntry]);
        cache_get_value_name_int(i, "interior_entry", hInfo[id][interiorEntry]);
        cache_get_value_name_float(i, "exit_x", hInfo[id][hExitPos][0]);
        cache_get_value_name_float(i, "exit_y", hInfo[id][hExitPos][1]);
        cache_get_value_name_float(i, "exit_z", hInfo[id][hExitPos][2]);
        cache_get_value_name_float(i, "exit_a", hInfo[id][hExitPos][3]);
        cache_get_value_name_int(i, "vw_exit", hInfo[id][vwExit]);
        cache_get_value_name_int(i, "interior_exit", hInfo[id][interiorExit]);

        loadedHouses++;
    }

    printf("[CASAS]: %d casas carregadas com sucesso.", loadedHouses);

    return 1;
}

//Carrega casa espefica.
LoadHouse(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    hInfo[id][hID] = id;
    cache_get_value_name_int(0, "character_id", hInfo[id][hOwner]);
    cache_get_value_name(0, "address", hInfo[id][hAddress]);
    cache_get_value_name_int(0, "garage_id", hInfo[id][hGarage]);
    cache_get_value_name_int(0, "locked", hInfo[id][hLocked]);
    cache_get_value_name_int(0, "price", hInfo[id][hPrice]);
    cache_get_value_name_int(0, "storage_money", hInfo[id][hStorageMoney]);
    cache_get_value_name_float(0, "entry_x", hInfo[id][hEntryPos][0]);
    cache_get_value_name_float(0, "entry_y", hInfo[id][hEntryPos][1]);
    cache_get_value_name_float(0, "entry_z", hInfo[id][hEntryPos][2]);
    cache_get_value_name_float(0, "entry_a", hInfo[id][hEntryPos][3]);
    cache_get_value_name_int(0, "vw_entry", hInfo[id][vwEntry]);
    cache_get_value_name_int(0, "interior_entry", hInfo[id][interiorEntry]);
    cache_get_value_name_float(0, "exit_x", hInfo[id][hExitPos][0]);
    cache_get_value_name_float(0, "exit_y", hInfo[id][hExitPos][1]);
    cache_get_value_name_float(0, "exit_z", hInfo[id][hExitPos][2]);
    cache_get_value_name_float(0, "exit_a", hInfo[id][hExitPos][3]);
    cache_get_value_name_int(0, "vw_exit", hInfo[id][vwExit]);
    cache_get_value_name_int(0, "interior_exit", hInfo[id][interiorExit]);

    return 1;
}

//Salva todas �s casas.
SaveHouses() {
    new savedHouses;

    for(new i; i < MAX_HOUSES; i++) {
        if(!hInfo[i][hID])
            continue;

        mysql_format(DBConn, query, sizeof query, "UPDATE `houses` SET `character_id` = '%d', `address` = '%e', `garage_id` = '%d, `locked` = '%d', `storage_money` = '%d', `price` = '%d', \
            `entry_x` = '%f', `entry_y` = '%f', `entry_z` = '%f', `entry_a` = '%f', `vw_entry` = '%d', `interior_entry` = '%d', \
            `exit_x` = '%f', `exit_y` = '%f', `exit_z` = '%f', `exit_a` = '%f', `vw_exit` = '%d', `interior_exit` = %d WHERE `id` = %d;", hInfo[i][hOwner], hInfo[i][hAddress], hInfo[i][hGarage], hInfo[i][hLocked], hInfo[i][hStorageMoney], hInfo[i][hPrice],
            hInfo[i][hEntryPos][0], hInfo[i][hEntryPos][1], hInfo[i][hEntryPos][2], hInfo[i][hEntryPos][3], hInfo[i][vwEntry], hInfo[i][interiorEntry],
            hInfo[i][hExitPos][0], hInfo[i][hExitPos][1], hInfo[i][hExitPos][2], hInfo[i][hExitPos][3], hInfo[i][vwExit], hInfo[i][interiorExit], i);
        mysql_query(DBConn, query);

        savedHouses++;
    }

    printf("[CASAS]: %d casas salvas com sucesso.", savedHouses);

    return 1;
}

//Sava casa especifica.
SaveHouse(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    mysql_format(DBConn, query, sizeof query, "UPDATE `houses` SET `character_id` = '%d', `address` = '%e', `garage_id` = '%d', `locked` = '%d', `storage_money` = '%d', `price` = '%d', \
        `entry_x` = '%f', `entry_y` = '%f', `entry_z` = '%f', `entry_a` = '%f', `vw_entry` = '%d', `interior_entry` = '%d', \
        `exit_x` = '%f', `exit_y` = '%f', `exit_z` = '%f', `exit_a` = '%f', `vw_exit` = '%d', `interior_exit` = %d WHERE `id` = %d;", hInfo[id][hOwner], hInfo[id][hAddress], hInfo[id][hGarage], hInfo[id][hLocked], hInfo[id][hStorageMoney], hInfo[id][hPrice],
        hInfo[id][hEntryPos][0], hInfo[id][hEntryPos][1], hInfo[id][hEntryPos][2], hInfo[id][hEntryPos][3], hInfo[id][vwEntry], hInfo[id][interiorEntry],
        hInfo[id][hExitPos][0], hInfo[id][hExitPos][1], hInfo[id][hExitPos][2], hInfo[id][hExitPos][3], hInfo[id][vwExit], hInfo[id][interiorExit], id);
    mysql_query(DBConn, query);

    return 1;
}

//Verifica a existencia da casa (caso n�o existe � false)
IsValidHouse(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    return 1;
}

// Verifica o dono da casa.
HouseHasOwner(id) {
    return IsValidHouse(id) && (hInfo[id][hOwner]);
}

// Procura por alguma entrada de casa
GetNearestHouseEntry(playerid, Float:distance = 1.0) {
    new secondEntry;
    for(new i; i < MAX_HOUSES; i++) {
        if(!hInfo[i][hID])
            continue;

        if(!IsPlayerInRangeOfPoint(playerid, distance, hInfo[i][hEntryPos][0], hInfo[i][hEntryPos][1], hInfo[i][hEntryPos][2]))
            continue;

        if(GetPlayerVirtualWorld(playerid) != hInfo[i][vwEntry] || GetPlayerInterior(playerid) != hInfo[i][interiorEntry])
            continue;

        return i;
    }

    secondEntry = GetNearestHouseSecondEntry(playerid);

    if(secondEntry)
        return secondEntry;

    return -1;
}

// Procura por alguma sa�da de casa
GetNearestHouseExit(playerid, Float:distance = 1.0) {
    new secondExit;

    for(new i; i < MAX_HOUSES; i++) {
        if(!hInfo[i][hID])
            continue;
        
        if(GetPlayerVirtualWorld(playerid) != hInfo[i][vwExit] || GetPlayerInterior(playerid) != hInfo[i][interiorExit])
            continue;

        if(!IsPlayerInRangeOfPoint(playerid, distance, hInfo[i][hExitPos][0], hInfo[i][hExitPos][1], hInfo[i][hExitPos][2]))
            continue;

        return i;
    }

    secondExit = GetNearestHouseSecondExit(playerid);

    if(secondExit)
        return secondExit;

    return 0;
}

// ============================================================================================================================================
//Carrega �s entradas (segundarias) das casas.
LoadEntries() {
    new loadedEntries;

    mysql_query(DBConn, "SELECT * FROM `houses_other_entries`;");

    for(new i; i < cache_num_rows(); i++) {
        new id;
        cache_get_value_name_int(i, "id", id);
        sInfo[id][sID] = id;

        cache_get_value_name_int(i, "house_id", sInfo[id][sHouseID]);
        cache_get_value_name_int(i, "locked", sInfo[id][sLocked]);
        cache_get_value_name_float(i, "entry_x", sInfo[id][sEntryPos][0]);
        cache_get_value_name_float(i, "entry_y", sInfo[id][sEntryPos][1]);
        cache_get_value_name_float(i, "entry_z", sInfo[id][sEntryPos][2]);
        cache_get_value_name_float(i, "entry_a", sInfo[id][sEntryPos][3]);
        cache_get_value_name_int(i, "vw_entry", sInfo[id][sEntryVW]);
        cache_get_value_name_int(i, "interior_entry", sInfo[id][sEntryInterior]);
        cache_get_value_name_float(i, "exit_x", sInfo[id][sExitPos][0]);
        cache_get_value_name_float(i, "exit_y", sInfo[id][sExitPos][1]);
        cache_get_value_name_float(i, "exit_z", sInfo[id][sExitPos][2]);
        cache_get_value_name_float(i, "exit_a", sInfo[id][sExitPos][3]);
        cache_get_value_name_int(i, "vw_exit", sInfo[id][sExitVW]);
        cache_get_value_name_int(i, "interior_exit", sInfo[id][sExitInterior]);

        loadedEntries++;
    }

    printf("[CASAS]: %d entradas secund�rias carregadas com sucesso.", loadedEntries);

    return 1;
}

//Carrega entrada (segundaria) de uma casa em esp�cifico 
LoadEntry(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses_other_entries` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    sInfo[id][sID] = id;

    cache_get_value_name_int(0, "house_id", sInfo[id][sHouseID]);
    cache_get_value_name_int(0, "locked", sInfo[id][sLocked]);
    cache_get_value_name_float(0, "entry_x", sInfo[id][sEntryPos][0]);
    cache_get_value_name_float(0, "entry_y", sInfo[id][sEntryPos][1]);
    cache_get_value_name_float(0, "entry_z", sInfo[id][sEntryPos][2]);
    cache_get_value_name_float(0, "entry_a", sInfo[id][sEntryPos][3]);
    cache_get_value_name_int(0, "vw_entry", sInfo[id][sEntryVW]);
    cache_get_value_name_int(0, "interior_entry", sInfo[id][sEntryInterior]);
    cache_get_value_name_float(0, "exit_x", sInfo[id][sExitPos][0]);
    cache_get_value_name_float(0, "exit_y", sInfo[id][sExitPos][1]);
    cache_get_value_name_float(0, "exit_z", sInfo[id][sExitPos][2]);
    cache_get_value_name_float(0, "exit_a", sInfo[id][sExitPos][3]);
    cache_get_value_name_int(0, "vw_exit", sInfo[id][sExitVW]);
    cache_get_value_name_int(0, "interior_exit", sInfo[id][sExitInterior]);

    return 1;
}

//Carrega �s entradas (segundarias) das casas.
SaveEntries() {
    new savedEntries;

    for(new i; i < MAX_SECOND_ENTRIES; i++) {
        if(!hInfo[i][hID])
            continue;

        mysql_format(DBConn, query, sizeof query, "UPDATE `houses_other_entries` SET `house_id` = '%d', `locked` = '%d', \
            `entry_x` = '%f', `entry_y` = '%f', `entry_z` = '%f', `entry_a` = '%f', `vw_entry` = '%d', `interior_entry` = '%d', \
            `exit_x` = '%f', `exit_y` = '%f', `exit_z` = '%f', `exit_a` = '%f', `vw_exit` = '%d', `interior_exit` = %d WHERE `id` = %d;", sInfo[i][sHouseID], sInfo[i][sLocked],
            sInfo[i][sEntryPos][0], sInfo[i][sEntryPos][1], sInfo[i][sEntryPos][2], sInfo[i][sEntryPos][3], sInfo[i][sEntryVW], sInfo[i][sEntryInterior],
            sInfo[i][sExitPos][0], sInfo[i][sExitPos][1], sInfo[i][sExitPos][2], sInfo[i][sExitPos][3], sInfo[i][sExitVW], sInfo[i][sExitInterior], i);
        mysql_query(DBConn, query);

        savedEntries++;
    }

    printf("[CASAS]: %d entradas secund�rias salvas com sucesso.", savedEntries);

    return 1;
}

//Salva entrada (segundaria) de uma casa em esp�cifico 
SaveEntry(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses_other_entries` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    mysql_format(DBConn, query, sizeof query, "UPDATE `houses_other_entries` SET `house_id` = '%d', `locked` = '%d', \
        `entry_x` = '%f', `entry_y` = '%f', `entry_z` = '%f', `entry_a` = '%f', `vw_entry` = '%d', `interior_entry` = '%d', \
        `exit_x` = '%f', `exit_y` = '%f', `exit_z` = '%f', `exit_a` = '%f', `vw_exit` = '%d', `interior_exit` = %d WHERE `id` = %d;", sInfo[id][sHouseID], sInfo[id][sLocked],
        sInfo[id][sEntryPos][0], sInfo[id][sEntryPos][1], sInfo[id][sEntryPos][2], sInfo[id][sEntryPos][3], sInfo[id][sEntryVW], sInfo[id][sEntryInterior],
        sInfo[id][sExitPos][0], sInfo[id][sExitPos][1], sInfo[id][sExitPos][2], sInfo[id][sExitPos][3], sInfo[id][sExitVW], sInfo[id][sExitInterior], id);
    mysql_query(DBConn, query);

    return 1;
}

//Criar casa
CreateHouse(playerid, price, address[256]) {
    new Float:pos[4];

    if(price < 1000)
        return SendErrorMessage(playerid, "O pre�o da casa deve ser maior do que $1000.");

    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses` WHERE `address` = '%e';", address);
    mysql_query(DBConn, query);

    if(cache_num_rows())
        return SendErrorMessage(playerid, "Este endere�o j� est� registrado em outra casa!");

    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    mysql_format(DBConn, query, sizeof query, "INSERT INTO `houses` (`address`, `price`, `entry_x`, `entry_y`, `entry_z`, `entry_a`, `vw_entry`, `interior_entry`) \
        VALUES ('%s', %d, %f, %f, %f, %f, %d, %d);", address, price, pos[0], pos[1], pos[2], pos[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    mysql_query(DBConn, query);

    new id = cache_insert_id();

    mysql_format(DBConn, query, sizeof query, "UPDATE `houses` SET `vw_exit` = %d WHERE `id` = %d;", id + 10000, id);
    mysql_query(DBConn, query);

    LoadHouse(id);

    SendServerMessage(playerid, "Voc� criou a casa de ID %d no endere�o: '%s'. ($%s)", id, address, FormatNumber(price));
    format(logString, sizeof(logString), "%s (%s) criou a casa de ID %d no endere�o: '%s'. ($%s)", pNome(playerid), GetPlayerUserEx(playerid), id, address,  FormatNumber(price));
	logCreate(playerid, logString, 13);
    return 1;
}

//Cria entrada segundaria para determinada casa
CreateHouseSecondEntry(playerid, houseID) {
    new Float:pos[4];

    if(!IsValidHouse(houseID))
        return SendErrorMessage(playerid, "Este ID de casa n�o existe.");

    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    mysql_format(DBConn, query, sizeof query, "INSERT INTO `houses_other_entries` (`house_id`, `entry_x`, `entry_y`, `entry_z`, `entry_a`, `vw_entry`, `interior_entry`) \
        VALUES (%d, %f, %f, %f, %f, %d, %d);", houseID, pos[0], pos[1], pos[2], pos[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    mysql_query(DBConn, query);

    new id = cache_insert_id();

    mysql_format(DBConn, query, sizeof query, "UPDATE `houses_other_entries` SET `exit_x` = %f, `exit_y` = %f, `exit_z` = %f, `exit_a` = %f, `vw_exit` = %d, `interior_exit` = %d WHERE `id` = %d;",
        hInfo[houseID][hExitPos][0], hInfo[houseID][hExitPos][1], hInfo[houseID][hExitPos][2], hInfo[houseID][hExitPos][3], hInfo[houseID][vwExit], hInfo[houseID][interiorExit], id);
    mysql_query(DBConn, query);

    LoadEntry(id);

    SendServerMessage(playerid, "Voc� criou a entrada secund�ria de ID %d para a casa de ID %d.", id, houseID);

    format(logString, sizeof(logString), "%s (%s) criou a entrada secund�ria de ID %d para a casa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), id, houseID);
	logCreate(playerid, logString, 14);
    return 1;
}

//Excluir casa
DeleteHouse(playerid, id) {
    if(!IsValidHouse(id))
        return SendErrorMessage(playerid, "Esse ID de casa n�o existe.");

    mysql_format(DBConn, query, sizeof query, "DELETE FROM `houses` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    SendServerMessage(playerid, "Voc� deletou a casa de ID %d.", id);

    format(logString, sizeof(logString), "%s (%s) deletou a casa de ID %d. (%s)", pNome(playerid), GetPlayerUserEx(playerid), id, hInfo[id][hAddress]);
	logCreate(playerid, logString, 13);

    new dummyReset[E_HOUSE_DATA];
    hInfo[id] = dummyReset;
    return 1;
}

//Teleporta o player para determinada casa (via o ID > Onde est� localizada a entrada)
TeleportHouse(playerid, id) {
    if(!hInfo[id][hID])
        return SendErrorMessage(playerid, "Esse ID de casa n�o existe.");

    SetPlayerVirtualWorld(playerid, hInfo[id][vwEntry]);
    SetPlayerInterior(playerid, hInfo[id][interiorEntry]);
    SetPlayerPos(playerid, hInfo[id][hEntryPos][0], hInfo[id][hEntryPos][1], hInfo[id][hEntryPos][2]);
    SetPlayerFacingAngle(playerid, hInfo[id][hEntryPos][3]);

    SendServerMessage(playerid, "Voc� teleportou at� a casa de ID %d.", id);
    return 1;
}

//Teleporta o player para determinada entrad (segundaria) (via o ID > Onde est� localizada a entrada)
TeleportSecondEntry(playerid, id) {
    if(!IsValidEntry(id))
        return SendErrorMessage(playerid, "Esse ID de entrada n�o existe.");

    SetPlayerVirtualWorld(playerid, sInfo[id][sEntryVW]);
    SetPlayerInterior(playerid, sInfo[id][sEntryInterior]);
    SetPlayerPos(playerid, sInfo[id][sEntryPos][0], sInfo[id][sEntryPos][1], sInfo[id][sEntryPos][2]);
    SetPlayerFacingAngle(playerid, sInfo[id][sEntryPos][3]);

    SendServerMessage(playerid, "Voc� teleportou at� a entrada de ID %d.", id);
    return 1;
}

//Verifica a existencia da entrada (retorna false caso n�o exista.)
IsValidEntry(id) {
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM `houses_other_entries` WHERE `id` = %d;", id);
    mysql_query(DBConn, query);

    if(!cache_num_rows())
        return 0;

    return 1;
}

// Procura por alguma entrada secund�ria de casa
GetNearestHouseSecondEntry(playerid, Float:distance = 1.0) {
    for(new i; i < MAX_SECOND_ENTRIES; i++) {
        if(!sInfo[i][sHouseID])
            continue;

        if(!IsPlayerInRangeOfPoint(playerid, distance, sInfo[i][sEntryPos][0], sInfo[i][sEntryPos][1], sInfo[i][sEntryPos][2]))
            continue;

        if(GetPlayerVirtualWorld(playerid) != sInfo[i][sEntryVW] || GetPlayerInterior(playerid) != sInfo[i][sEntryInterior])
            continue;

        return i;
    }

    return 0;
}

// Procura por alguma sa�da secund�ria de casa
GetNearestHouseSecondExit(playerid, Float:distance = 1.0) {
    for(new i; i < MAX_SECOND_ENTRIES; i++) {
        if(!sInfo[i][sHouseID])
            continue;
        
        if(GetPlayerVirtualWorld(playerid) != sInfo[i][sExitVW] || GetPlayerInterior(playerid) != sInfo[i][sExitInterior])
            continue;

        if(!IsPlayerInRangeOfPoint(playerid, distance, sInfo[i][sExitPos][0], sInfo[i][sExitPos][1], sInfo[i][sExitPos][2]))
            continue;

        return i;
    }

    return 0;
}

//Verifica se a casa � v�lida + o endere�o da casa.
GetHouseAddress(id) {
    IsValidHouse(id);

    new address[256];
    format(address, sizeof(address), "%s", hInfo[id][hAddress]);

    return address;
}

// ============================================================================================================================================
//Seta se a casa est� "alugando" ou n�o.
RentableHouse(id, playerid, rentable) {
    if(rentable != 1)
        rentable = 0;

    hInfo[id][hRentable] = rentable;
    hInfo[id][hRent] = 1;
    SaveHouse(id);

    format(logString, sizeof(logString), "%s (%s) deixou a casa ID %d %s.", pNome(playerid), GetPlayerUserEx(playerid), id, (rentable ? "alug�vel" : "n�o alug�vel"));
	logCreate(playerid, logString, 13);

    return 1;
}

//Seta o pre�o do aluguel da casa.
SetRentPrice(id, playerid, value) {
    hInfo[id][hRent] = value;
    SaveHouse(id);

    format(logString, sizeof(logString), "%s (%s) alterou o pre�o de aluguel da sua casa ID %d para $%s.", pNome(playerid), GetPlayerUserEx(playerid), id, FormatNumber(value));
	logCreate(playerid, logString, 13);

    return 1;
}

//Seta nova entrada da casa
SetEntryHouse(playerid, id) {
    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    hInfo[id][hEntryPos][0] = pos[0];
    hInfo[id][hEntryPos][1] = pos[1];
    hInfo[id][hEntryPos][2] = pos[2];
    hInfo[id][hEntryPos][3] = pos[3];
    hInfo[id][vwEntry] = GetPlayerVirtualWorld(playerid);
    hInfo[id][interiorEntry] = GetPlayerInterior(playerid);

    SaveHouse(id);

    SendServerMessage(playerid, "Voc� editou a entrada da casa de ID %d.", id);

    format(logString, sizeof(logString), "%s (%s) editou a entrada da casa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), id);
    logCreate(playerid, logString, 13);
    return 1;
}

//Seta novo interior da casa
SetInteriorHouse(playerid, id) {
    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    hInfo[id][hExitPos][0] = pos[0];
    hInfo[id][hExitPos][1] = pos[1];
    hInfo[id][hExitPos][2] = pos[2];
    hInfo[id][hExitPos][3] = pos[3];
    hInfo[id][interiorExit] = GetPlayerInterior(playerid);

    SaveHouse(id);

    SendServerMessage(playerid, "Voc� editou o interior da casa de ID %d.", id);

    format(logString, sizeof(logString), "%s (%s) editou o interior da casa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), id);
    logCreate(playerid, logString, 13);
    return 1;
}

//Seta pre�o da casa
SetPriceHouse(playerid, id, houseValue) {
    if(!houseValue || houseValue < 0)
        return SendErrorMessage(playerid, "Voc� precisa especificar um valor que seja maior do que zero para ser o pre�o da casa.");

    hInfo[id][hPrice] = houseValue;
    SaveHouse(id);

    SendServerMessage(playerid, "Voc� editou o pre�o da casa de ID %d para $%s.", id, FormatNumber(houseValue));

    format(logString, sizeof(logString), "%s (%s) editou o pre�o da casa de ID %d para $%s.", pNome(playerid), GetPlayerUserEx(playerid), id, FormatNumber(houseValue));
    logCreate(playerid, logString, 13);
    return 1;
}

//Seta novo endere�o da casa.
SetAddressHouse(playerid, id, value[64]) {
    if(!strlen(value))
        return SendErrorMessage(playerid, "Voc� precisa especificar um endere�o para setar.");

    format(hInfo[id][hAddress], 256, "%s", value);
    SaveHouse(id);

    SendServerMessage(playerid, "Voc� setou o endere�o da casa de ID %d como '%s'.", id, value);

    format(logString, sizeof(logString), "%s (%s) setou o endere�o da casa de ID %d como '%s'.", pNome(playerid), GetPlayerUserEx(playerid), id, value);
    logCreate(playerid, logString, 13);
    return 1;
}

//Setar local da entrada
SetSecondEntry(playerid, id) {
    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    sInfo[id][sEntryPos][0] = pos[0];
    sInfo[id][sEntryPos][1] = pos[1];
    sInfo[id][sEntryPos][2] = pos[2];
    sInfo[id][sEntryPos][3] = pos[3];
    sInfo[id][sEntryVW] = GetPlayerVirtualWorld(playerid);
    sInfo[id][sEntryVW] = GetPlayerInterior(playerid);

    SaveEntry(id);

    SendServerMessage(playerid, "Voc� editou a entrada secund�ria de ID %d da casa de ID %d.", id, sInfo[id][sHouseID]);

    format(logString, sizeof(logString), "%s (%s) editou a entrada secund�ria de ID %d da casa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), id, sInfo[id][sHouseID]);
    logCreate(playerid, logString, 14);
    return 1;
}

//Setar interior de determinada entrada.
SetInteriorSecondEntry(playerid, id) {
    new Float:pos[4];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetPlayerFacingAngle(playerid, pos[3]);

    sInfo[id][sExitPos][0] = pos[0];
    sInfo[id][sExitPos][1] = pos[1];
    sInfo[id][sExitPos][2] = pos[2];
    sInfo[id][sExitPos][3] = pos[3];
    sInfo[id][sExitInterior] = GetPlayerInterior(playerid);

    SaveEntry(id);

    SendServerMessage(playerid, "Voc� editou o interior da entrada secund�ria de ID %d (casa de ID %d).", id, sInfo[id][sHouseID]);

    format(logString, sizeof(logString), "%s (%s) editou o interior da entrada secund�ria de ID %d (casa de ID %d).", pNome(playerid), GetPlayerUserEx(playerid), id, sInfo[id][sHouseID]);
    logCreate(playerid, logString, 14);
    return 1;
}

//Linkar entrada em outra casa.
SetEntryNewHouse(playerid, id, houseID) {
    if(!IsValidHouse(houseID))
        return SendErrorMessage(playerid, "Este ID de casa n�o existe.");

    sInfo[id][sHouseID] = houseID;
    sInfo[id][sExitVW] = hInfo[houseID][vwExit];
    SaveEntry(id);

    SendServerMessage(playerid, "Voc� vinculou a entrada de ID %d � casa de ID %d.", id, houseID);

    format(logString, sizeof(logString), "%s (%s) vinculou a entrada de ID %d � casa de ID %d.", pNome(playerid), GetPlayerUserEx(playerid), id, houseID);
    logCreate(playerid, logString, 14);
    return 1;
}

SetRentableHouse(playerid, houseID) {
    if(hInfo[houseID][hOwner] != pInfo[playerid][pID])
        return SendErrorMessage(playerid, "Essa casa n�o � sua.");
    
    switch(hInfo[houseID][hRentable]) {
        case 0: {
            RentableHouse(houseID, playerid, 1);
            va_SendClientMessage(playerid, COLOR_YELLOW, "Sua casa agora est� alug�vel.");
        }
        default: {
            RentableHouse(houseID, playerid, 0);
            va_SendClientMessage(playerid, COLOR_YELLOW, "Sua casa n�o est� mais alug�vel.");
        }
    }
    return 1;
}

//Verifica se (playerid) est� dentro de uma casa.
IsHouseInside(playerid)
{
    for (new i = 0; i != MAX_HOUSES; i ++) if (GetPlayerInterior(playerid) == hInfo[i][interiorExit] && GetPlayerVirtualWorld(playerid) == hInfo[i][vwExit]) {
	        return i;
	} 
    return -1;
}