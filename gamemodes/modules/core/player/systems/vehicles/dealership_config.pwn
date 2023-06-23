DealershipConfigMain(playerid) {
    if(GetPlayerAdmin(playerid) < 5) return SendPermissionMessage(playerid); 
    ResetDealershipMenuVars(playerid);
    mysql_format(DBConn, query, sizeof query, "SELECT * FROM vehicles_dealer WHERE `ID` > 0 ORDER BY `ID` DESC");
    new Cache:result = mysql_query(DBConn, query);

    new string[2048], model_id, id;
    format(string, sizeof(string), "19132(0.0, 0.0, -80.0, 1.0)\t~g~Adicionar\n");
    for(new i; i < cache_num_rows(); i++) {
        cache_get_value_name_int(i, "model_id", model_id);
        cache_get_value_name_int(i, "ID", id);

        format(string, sizeof(string), "%s%d(0.0, 0.0, 50.0, 0.95, 1, 1)\t~w~%s (%d)~n~~n~~n~~n~~g~EDITAR\n", string, model_id, ReturnVehicleModelName(model_id), id);
    }
    cache_delete(result);
    new title[128];
    format(title, 128, "Gerenciar_Concession�ria");
    AdjustTextDrawString(title);

    Dialog_Show(playerid, DealershipConfig, DIALOG_STYLE_PREVIEW_MODEL, title, string, "Selecionar", "Fechar");
    return true;
}

Dialog:DealershipConfig(playerid, response, listitem, inputtext[]){
    if(response) {
        new title[128], string[1024];
        new model_id = strval(inputtext), price, premium, sqlid, category;
        if(model_id == 19132){
            Dialog_Show(playerid, DealershipAdd, DIALOG_STYLE_INPUT, "{FFFFFF}Adicionar ve�culo � concession�ria", "Digite o ID do ve�culo a ser adicionado:", "Adicionar", "<<");
        } else {
            mysql_format(DBConn, query, sizeof query, "SELECT * FROM `vehicles_dealer` WHERE `model_id` = '%d'", model_id);
            new Cache:result = mysql_query(DBConn, query);
            if(!cache_num_rows()) return SendErrorMessage(playerid, "DCx001 - Ocorreu um erro, reporte a um desenvolvedor.");
            cache_get_value_name_int(0, "ID", sqlid);
            cache_get_value_name_int(0, "category", category);
            cache_get_value_name_int(0, "price", price);
            cache_get_value_name_int(0, "premium", premium);
            cache_delete(result);

            format(title, sizeof(title), "{FFFFFF}Gerenciar %s {AFAFAF}(SQL: %d)", ReturnVehicleModelName(model_id), sqlid);

            format(string, sizeof(string), 
                "{AFAFAF}Categoria\t{FFFFFF}%s\n\
                {AFAFAF}Premium\t{FFFFFF}%s\n\
                {AFAFAF}Valor\t{FFFFFF}US$ %s\n\t\n\
                {FF0000}Deletar ve�culo", DealershipCategory(category), PremiumType(premium),FormatNumber(price)
            );

            pInfo[playerid][dEditingSQL] = sqlid;
            pInfo[playerid][dEditingModel] = model_id;
            pInfo[playerid][dEditingPremium] = premium;
            pInfo[playerid][dEditingCategory] = category;
            pInfo[playerid][dEditingPrice] = price;
            Dialog_Show(playerid, DealershipEdit, DIALOG_STYLE_TABLIST, title, string, "Selecionar", "<<");
        }
    } else {
        ResetDealershipMenuVars(playerid);
    }
    return true;
}

Dialog:DealershipAdd(playerid, response, listitem, inputtext[]){
    if(response){
        static model[32];
        format(model, 32, "%s", inputtext);

        if (isnull(inputtext)) return Dialog_Show(playerid, DealershipAdd, DIALOG_STYLE_INPUT, "{FFFFFF}Adicionar ve�culo � concession�ria", "Voc� n�o especificou nenhum modelo.\nDigite o ID do ve�culo a ser adicionado:", "Adicionar", "<<");

        if ((model[0] = GetVehicleModelByName(model)) == 0) return Dialog_Show(playerid, DealershipAdd, DIALOG_STYLE_INPUT, "{FFFFFF}Adicionar ve�culo � concession�ria", "O modelo especificado � inv�lido.\nDigite o ID do ve�culo a ser adicionado:", "Adicionar", "<<");

        mysql_format(DBConn, query, sizeof query, "SELECT * FROM `vehicles_dealer` WHERE `model_id` = '%d';", model[0]);
        new Cache:result = mysql_query(DBConn, query);
        if(cache_num_rows()) return SendErrorMessage(playerid, "J� existe um ve�culo com este modelo."), cache_delete(result);
        

        mysql_format(DBConn, query, sizeof query, "INSERT INTO `vehicles_dealer` (`model_id`, `category`, `price`) VALUES ('%d', '1', '999999999');", model[0]);
        result = mysql_query(DBConn, query);
        cache_delete(result);

        SendServerMessage(playerid, "Voc� adicionou o ve�culo %s na concession�ria. Agora edite-o no painel.", ReturnVehicleModelName(model[0]));

        format(logString, sizeof(logString), "%s (%s) adicionou o ve�culo %s na concession�ria.", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(model[0]));
	    logCreate(playerid, logString, 1);
        // VOLTANDO AO MENU
        DealershipConfigMain(playerid);
    } else {
        DealershipConfigMain(playerid);
    }
    return true;
}

Dialog:DealershipEdit(playerid, response, listitem, inputtext[]){
    if(response) {
        new string[512], title[128];
        format(title, sizeof(title), "{FFFFFF}Gerenciar %s {AFAFAF}(SQL: %d)", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL]);
        switch(listitem) {
            case 0: {
                switch(pInfo[playerid][dEditingCategory]){
                    case 1: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 2: format(string, sizeof(string), "Avi�es\n{BBBBBB}>>> {FFFFFF}Barcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 3: format(string, sizeof(string), "Avi�es\nBarcos\n{BBBBBB}>>> {FFFFFF}Bicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 4: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\n{BBBBBB}>>> {FFFFFF}Motos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 5: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\n{BBBBBB}>>> {FFFFFF}Sedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 6: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\n{BBBBBB}>>> {FFFFFF}SUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 7: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\n{BBBBBB}>>> {FFFFFF}Lowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 8: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\n{BBBBBB}>>> {FFFFFF}Esportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 9: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\n{BBBBBB}>>> {FFFFFF}Industriais\nCaminhonetes\n�nicos\nTrailers industriais");
                    case 10: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\n{BBBBBB}>>> {FFFFFF}Caminhonetes\n�nicos\nTrailers industriais");
                    case 11: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n{BBBBBB}>>> {FFFFFF}�nicos\nTrailers industriais");
                    case 12: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\n{BBBBBB}>>> {FFFFFF}Trailers industriais");
                }
                pInfo[playerid][dEditingMenu] = 1;
                Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 1: {
                switch(pInfo[playerid][dEditingPremium]){
                    case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Comum\nPremium Bronze\nPremium Prata\nPremium Ouro");
                    case 1: format(string, sizeof(string), "Comum\n{BBBBBB}>>> {FFFFFF}Premium Bronze\nPremium Prata\nPremium Ouro");
                    case 2: format(string, sizeof(string), "Comum\nPremium Bronze\n{BBBBBB}>>> {FFFFFF}Premium Prata\nPremium Ouro");
                    case 3: format(string, sizeof(string), "Comum\nPremium Bronze\nPremium Prata\n{BBBBBB}>>> {FFFFFF}Premium Ouro");

                }
                pInfo[playerid][dEditingMenu] = 2;
                Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            }
            case 2: {
                pInfo[playerid][dEditingMenu] = 3;
                format(string, sizeof(string), "Digite o novo valor do ve�culo:\n\nValor anterior: US$ %s", FormatNumber(pInfo[playerid][dEditingPrice]));
                Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_INPUT, title, string, "Editar", "<<");
            }
            case 4: {
                mysql_format(DBConn, query, sizeof query, "DELETE FROM `vehicles_dealer` WHERE `ID` = '%d';", pInfo[playerid][dEditingSQL]);
                new Cache:result = mysql_query(DBConn, query);

                SendServerMessage(playerid, "Voc� deletou o ve�culo %s (SQL: %d) da concession�ria com sucesso. Essa a��o � irrevers�vel.", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL]);
                cache_delete(result);

                format(logString, sizeof(logString), "%s (%s) deletou o ve�culo %s (SQL: %d) da concession�ria", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL]);
	            logCreate(playerid, logString, 1);
                ResetDealershipMenuVars(playerid);
            }
        }
    } else 
       DealershipConfigMain(playerid);
    
    return true;
}

Dialog:DealershipEditOptions(playerid, response, listitem, inputtext[]) {
    new string[512], title[128], Cache:result;
    format(title, sizeof(title), "{FFFFFF}Gerenciar %s {AFAFAF}(SQL: %d)", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL]);
    if(response) {
        if(pInfo[playerid][dEditingMenu] == 1){
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 1: format(string, sizeof(string), "Avi�es\n{BBBBBB}>>> {FFFFFF}Barcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 2: format(string, sizeof(string), "Avi�es\nBarcos\n{BBBBBB}>>> {FFFFFF}Bicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 3: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\n{BBBBBB}>>> {FFFFFF}Motos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 4: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\n{BBBBBB}>>> {FFFFFF}Sedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 5: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\n{BBBBBB}>>> {FFFFFF}SUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 6: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\n{BBBBBB}>>> {FFFFFF}Lowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 7: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\n{BBBBBB}>>> {FFFFFF}Esportivos\nIndustriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 8: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\n{BBBBBB}>>> {FFFFFF}Industriais\nCaminhonetes\n�nicos\nTrailers industriais");
                case 9: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\n{BBBBBB}>>> {FFFFFF}Caminhonetes\n�nicos\nTrailers industriais");
                case 10: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n{BBBBBB}>>> {FFFFFF}�nicos\nTrailers industriais");
                case 11: format(string, sizeof(string), "Avi�es\nBarcos\nBicicletas\nMotos\nSedans\nSUVs & Wagons\nLowriders\nEsportivos\nIndustriais\nCaminhonetes\n�nicos\n{BBBBBB}>>> {FFFFFF}Trailers industriais");
            }
            mysql_format(DBConn, query, sizeof query, "UPDATE `vehicles_dealer` SET `category` = '%d' WHERE `ID` = '%d';", listitem+1, pInfo[playerid][dEditingSQL]);
            mysql_query(DBConn, query);

            SendServerMessage(playerid, "Voc� alterou a categoria do ve�culo %s de %s para %s.", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), DealershipCategory(pInfo[playerid][dEditingCategory]), DealershipCategory(listitem+1));

            format(logString, sizeof(logString), "%s (%s) alterou a categoria do ve�culo %s (%d) de %s para %s", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL], DealershipCategory(pInfo[playerid][dEditingCategory]), DealershipCategory(listitem+1));
	        logCreate(playerid, logString, 1);

            pInfo[playerid][dEditingCategory] = listitem+1;
            Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            cache_delete(result);
        }
        else if(pInfo[playerid][dEditingMenu] == 2){
            switch(listitem) {
                case 0: format(string, sizeof(string), "{BBBBBB}>>> {FFFFFF}Comum\nPremium Bronze\nPremium Prata\nPremium Ouro");
                case 1: format(string, sizeof(string), "Comum\n{BBBBBB}>>> {FFFFFF}Premium Bronze\nPremium Prata\nPremium Ouro");
                case 2: format(string, sizeof(string), "Comum\nPremium Bronze\n{BBBBBB}>>> {FFFFFF}Premium Prata\nPremium Ouro");
                case 3: format(string, sizeof(string), "Comum\nPremium Bronze\nPremium Prata\n{BBBBBB}>>> {FFFFFF}Premium Ouro");
            }
            mysql_format(DBConn, query, sizeof query, "UPDATE `vehicles_dealer` SET `premium` = '%d' WHERE `ID` = '%d';", listitem, pInfo[playerid][dEditingSQL]);
            mysql_query(DBConn, query);

            SendServerMessage(playerid, "Voc� alterou o premium do ve�culo %s de %s para %s.", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), PremiumType(pInfo[playerid][dEditingPremium]), PremiumType(listitem));

            format(logString, sizeof(logString), "%s (%s) alterou o premium do ve�culo %s (%d) de %s para %s", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL], PremiumType(pInfo[playerid][dEditingPremium]), PremiumType(listitem));
	        logCreate(playerid, logString, 1);

            pInfo[playerid][dEditingPremium] = listitem;
            Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_LIST, title, string, "Selecionar", "<<");
            cache_delete(result);
        }
        else if(pInfo[playerid][dEditingMenu] == 3){
            new price = strval(inputtext);
        
            format(string, sizeof(string), "Voc� n�o especificou nenhum valor.\nDigite o novo valor do ve�culo:\n\nValor anterior: US$ %s", FormatNumber(pInfo[playerid][dEditingPrice]));
            if (isnull(inputtext)) return Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_INPUT, title, string, "Alterar", "<<");

            format(string, sizeof(string), "O valor n�o pode ser igual ou menor a zero.\nDigite o novo valor do ve�culo:\n\nValor anterior: US$ %s", FormatNumber(pInfo[playerid][dEditingPrice]));
            if (price < 1) return Dialog_Show(playerid, DealershipEditOptions, DIALOG_STYLE_INPUT, title, string, "Alterar", "<<");

            mysql_format(DBConn, query, sizeof query, "UPDATE `vehicles_dealer` SET `price` = '%d' WHERE `ID` = '%d';", price, pInfo[playerid][dEditingSQL]);
            mysql_query(DBConn, query);

            SendServerMessage(playerid, "Voc� alterou o valor do ve�culo %s de US$ %s para US$ %s.", ReturnVehicleModelName(pInfo[playerid][dEditingModel]), FormatNumber(pInfo[playerid][dEditingPrice]), FormatNumber(price));

            format(logString, sizeof(logString), "%s (%s) alterou o valor do ve�culo %s (%d) de US$ %s para US$ %s", pNome(playerid), GetPlayerUserEx(playerid), ReturnVehicleModelName(pInfo[playerid][dEditingModel]), pInfo[playerid][dEditingSQL], FormatNumber(pInfo[playerid][dEditingPrice]), FormatNumber(price));
	        logCreate(playerid, logString, 1);

            pInfo[playerid][dEditingPrice] = price;

            cache_delete(result);
            
            format(string, sizeof(string), 
                "{AFAFAF}Categoria\t{FFFFFF}%s\n\
                {AFAFAF}Premium\t{FFFFFF}%s\n\
                {AFAFAF}Valor\t{FFFFFF}US$ %s\n\t\n{FF0000}Deletar ve�culo", DealershipCategory(pInfo[playerid][dEditingCategory]), PremiumType(pInfo[playerid][dEditingPremium]),FormatNumber(pInfo[playerid][dEditingPrice])
            );
            Dialog_Show(playerid, DealershipEdit, DIALOG_STYLE_TABLIST, title, string, "Selecionar", "<<");
        }
    } else {
        format(string, sizeof(string), 
            "{AFAFAF}Categoria\t{FFFFFF}%s\n\
            {AFAFAF}Premium\t{FFFFFF}%s\n\
            {AFAFAF}Valor\t{FFFFFF}US$ %s\n\t\n{FF0000}Deletar ve�culo", DealershipCategory(pInfo[playerid][dEditingCategory]), PremiumType(pInfo[playerid][dEditingPremium]),FormatNumber(pInfo[playerid][dEditingPrice])
        );

        Dialog_Show(playerid, DealershipEdit, DIALOG_STYLE_TABLIST, title, string, "Selecionar", "<<");
    }
    return true;
}

ResetDealershipMenuVars(playerid) {
    pInfo[playerid][dEditingSQL] =
    pInfo[playerid][dEditingModel] =
    pInfo[playerid][dEditingPremium] =
    pInfo[playerid][dEditingCategory] =
    pInfo[playerid][dEditingPrice] =
    pInfo[playerid][dEditingMenu] = 0;
    return true;
}