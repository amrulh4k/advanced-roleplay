#include <YSI_Coding\y_hooks>

new DCC_Channel:logChannels[26];
forward Discord_StartChannels();
public Discord_StartChannels() {
    logChannels[0] = DCC_FindChannelById("989303818896441345");     // Admin                (1)
    logChannels[1] = DCC_FindChannelById("989304049931268116");     // Login/Logout         (2)
    logChannels[2] = DCC_FindChannelById("990667978792116405");     // Commands Usage       (3)
    logChannels[3] = DCC_FindChannelById("989303613434253333");     // Delete Message       (4)
    logChannels[4] = DCC_FindChannelById("990686226216517642");     // System               (5)
    logChannels[5] = DCC_FindChannelById("991552258015776878");     // Death                (6)
    logChannels[6] = DCC_FindChannelById("991846277329465526");     // Investment           (7)
    logChannels[7] = DCC_FindChannelById("992937921789317221");     // Gerenciamento        (8)
    logChannels[8] = DCC_FindChannelById("993023592004603994");     // Support Chat         (9)
    logChannels[9] = DCC_FindChannelById("993230053959798824");     // Advertisement Log    (10)
    logChannels[10] = DCC_FindChannelById("998664519683407962");    // Punishments          (11)
    logChannels[11] = DCC_FindChannelById("999757221833478154");    // Snookers             (12)
    logChannels[12] = DCC_FindChannelById("1001265336823316490");   // Houses               (13) 
    logChannels[13] = DCC_FindChannelById("1001539492357869700");   // Register             (14) 
    logChannels[14] = DCC_FindChannelById("1001354737972674600");   // Trading              (15)
    logChannels[15] = DCC_FindChannelById("1006281850790092811");   // Vehicles             (16)
    logChannels[16] = DCC_FindChannelById("1008019265284227102");   // Lockpick             (17)
    logChannels[17] = DCC_FindChannelById("1011803785317855372");   // Drop                 (18)
    logChannels[18] = DCC_FindChannelById("1012919634384654346");   // Pets                 (19)
    logChannels[19] = DCC_FindChannelById("1015373086972981398");   // Money                (20)
    logChannels[20] = DCC_FindChannelById("1015475821177208852");   // Anitcheat            (21)
    logChannels[21] = DCC_FindChannelById("1018290520914673675");   // Factions             (22)
    logChannels[22] = DCC_FindChannelById("1021893920923332719");   // Graffity             (23)
    logChannels[23] = DCC_FindChannelById("1046135945436610650");   // Business             (24)
    logChannels[24] = DCC_FindChannelById("1046121172540063825");   // Garages              (25)
    logChannels[25] = DCC_FindChannelById("1069691701230317568");   // Banco                (26)
    return true;
}

forward Discord_PublishLog(log[], type);
public Discord_PublishLog(log[], type) {
    new convertedType = type-1;
    new string[512];
    format(string, 512, "```[%s] %s```", GetFullDate(gettime()), log);
    utf8encode(string, string);
    DCC_SendChannelMessage(logChannels[convertedType], string);
    return true;
}

hook OnGameModeInit() {
    Discord_StartChannels();
    SetTimer("DiscordStatus", 15000, true);
}

forward DiscordStatus();
public DiscordStatus() {
    new string[32];
    format(string, sizeof string, "Closed Beta: %d/%d", Iter_Count(Player), GetMaxPlayers());
    DCC_SetBotActivity(string);
    return true;
}