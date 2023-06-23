#include <YSI_Coding\y_hooks>

CMD:config(playerid, params[]){
    Dialog_Show(playerid, PLAYER_CONFIG, DIALOG_STYLE_LIST, "Gerenciamento do Usu�rio", "Help Center\nAvisos Administrativos\nNametag\nRenderiza��o de Objetos\nVeloc�metro\nHUD", "Selecionar", "Fechar");
    return true;
}
 
Dialog:PLAYER_CONFIG(playerid, response, listitem, inputtext[]){
    if(response){
        new string[512], title[128];
        switch(listitem){
            case 0: { // Help Center
                if (uInfo[playerid][uNewbie] == 1337) return pInfo[playerid][pTogNewbie] = 0, SendErrorMessage(playerid, "Voc� est� marcado como novato e por isso n�o pode desativar o Help Center.");

                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Help Center");
                switch(pInfo[playerid][pTogNewbie]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Help Center ativado\nHelp Center desativado");
                    case 1: format(string, sizeof(string), "Help Center ativado\n{BBBBBB}>>> {FFFFFF}Help Center desativado");
                }
                pInfo[playerid][pSetting] = 1;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 1: { // Admin
                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Avisos Administrativos");
                switch(pInfo[playerid][pTogAdmin]) {
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Mensagens administrativas ativadas\nMensagens administrativas desativadas");
                    case 1: format(string, sizeof(string), "Mensagens administrativas ativadas\n{BBBBBB}>>> {FFFFFF}Mensagens administrativas desativadas");
                }
                pInfo[playerid][pSetting] = 2;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 2: { // Nametag
                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Nametag");
                switch(pInfo[playerid][pNametagType]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Nome, ID, vida e colete\nApenas nome\nDesligado");
                    case 1: format(string, sizeof(string), "Nome, ID, vida e colete\n{BBBBBB}>>> {FFFFFF}Apenas nome\nDesligado");
                    case 2: format(string, sizeof(string), "Nome, ID, vida e colete\nApenas nome\n{BBBBBB}>>> {FFFFFF}Desligado");
                }
                pInfo[playerid][pSetting] = 3;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 3: { // Objects
                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Renderiza��o de Objetos");
                switch(pInfo[playerid][pRenderObjects]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                    case 1: format(string, sizeof(string), "Baixa (0.5)\n{BBBBBB}>>> {FFFFFF}Padr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                    case 2: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\n{BBBBBB}>>> {FFFFFF}M�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                    case 3: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\n{BBBBBB}>>> {FFFFFF}Alta (3.0)\nUltra (5.0)");
                    case 4: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\n{BBBBBB}>>> {FFFFFF}Ultra (5.0)");
                    default: format(string, sizeof(string), "Baixa (0.5)\n{BBBBBB}>>> {FFFFFF}Padr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                }
                pInfo[playerid][pSetting] = 4;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            } 
            case 4: { // Veloc�metro
                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Veloc�metro");
                switch(pInfo[playerid][pHudSpeedo]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Desativado\nModelo cl�ssico\nModelo b�sico");
                    case 1: format(string, sizeof(string), "Desativado\n{BBBBBB}>>> {FFFFFF}Modelo cl�ssico\nModelo b�sico");
                    case 2: format(string, sizeof(string), "Desativado\nModelo cl�ssico\n{BBBBBB}>>> {FFFFFF}Modelo b�sico");
                }
                pInfo[playerid][pSetting] = 5;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 5: { // HUD
                format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - HUD");
                switch(pInfo[playerid][pHudStyle]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Ativado\nDesativado");
                    case 1: format(string, sizeof(string), "Ativado\n{BBBBBB}>>> {FFFFFF}Desativado");
                }
                pInfo[playerid][pSetting] = 6;
                Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
        } 
    }
    return true;
}

Dialog:PLAYER_CONFIG_OPTIONS(playerid, response, listitem, inputtext[]){
    if(response) {
        new string[512], title[128];
        if (pInfo[playerid][pSetting] == 1) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Help Center");
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Help Center ativado\nHelp Center desativado");
                case 1: format(string, sizeof(string), "Help Center ativado\n{BBBBBB}>>> {FFFFFF}Help Center desativado");
            }
            pInfo[playerid][pTogNewbie] = listitem;
            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
        else if (pInfo[playerid][pSetting] == 2) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Avisos Administrativos");
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Mensagens administrativas ativadas\nMensagens administrativas desativadas");
                case 1: format(string, sizeof(string), "Mensagens administrativas ativadas\n{BBBBBB}>>> {FFFFFF}Mensagens administrativas desativadas");
            }

            pInfo[playerid][pTogAdmin] = listitem;
            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
        else if (pInfo[playerid][pSetting] == 3) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Nametag");
            switch(listitem){
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Nome, ID, vida e colete\nApenas nome\nDesligado");
                case 1: format(string, sizeof(string), "Nome, ID, vida e colete\n{BBBBBB}>>> {FFFFFF}Apenas nome\nDesligado");
                case 2: format(string, sizeof(string), "Nome, ID, vida e colete\nApenas nome\n{BBBBBB}>>> {FFFFFF}Desligado");
            }

            pInfo[playerid][pNametagType] = listitem;
            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
        else if (pInfo[playerid][pSetting] == 4) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Renderiza��o de Objetos");
            switch(listitem){
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                case 1: format(string, sizeof(string), "Baixa (0.5)\n{BBBBBB}>>> {FFFFFF}Padr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                case 2: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\n{BBBBBB}>>> {FFFFFF}M�dia (1.5)\nAlta (3.0)\nUltra (5.0)");
                case 3: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\n{BBBBBB}>>> {FFFFFF}Alta (3.0)\nUltra (5.0)");
                case 4: format(string, sizeof(string), "Baixa (0.5)\nPadr�o (1.0)\nM�dia (1.5)\nAlta (3.0)\n{BBBBBB}>>> {FFFFFF}Ultra (5.0)");
            }

            pInfo[playerid][pRenderObjects] = listitem;
            Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, RenderingObjectsValue(playerid), playerid);
            Streamer_SetRadiusMultiplier(STREAMER_TYPE_OBJECT, RenderingObjectsRadius(playerid), playerid);
            Streamer_Update(playerid);

            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
        else if (pInfo[playerid][pSetting] == 5) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - Veloc�metro");
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Desativado\nModelo cl�ssico\nModelo b�sico");
                case 1: format(string, sizeof(string), "Desativado\n{BBBBBB}>>> {FFFFFF}Modelo cl�ssico\nModelo b�sico");
                case 2: format(string, sizeof(string), "Desativado\nModelo cl�ssico\n{BBBBBB}>>> {FFFFFF}Modelo b�sico");
            }
            
            ClosePlayerSpeedo(playerid);
            pInfo[playerid][pHudSpeedo] = listitem;
            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
        else if (pInfo[playerid][pSetting] == 6) {
            format(title, sizeof(title), "{FFFFFF}Gerenciamento do Usu�rio - HUD");
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Ativado\nDesativado");
                case 1: format(string, sizeof(string), "Ativado\n{BBBBBB}>>> {FFFFFF}Desativado");
            }

            pInfo[playerid][pHudStyle] = listitem;
            Dialog_Show(playerid, PLAYER_CONFIG_OPTIONS, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
        }
    } else {
        Dialog_Show(playerid, PLAYER_CONFIG, DIALOG_STYLE_LIST, "Gerenciamento do Usu�rio", "Help Center\nAvisos Administrativos\nNametag\nRenderiza��o de Objetos\nVeloc�metro\nHUD", "Selecionar", "Fechar");
    }
    return true;
}