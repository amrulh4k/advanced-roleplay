#include <YSI_Coding\y_hooks>

CMD:creditos(playerid, params[]) {

    new string[2048];
    format(string, sizeof(string), 
    "{36A717}Thiago Guimar�es {AFAFAF}(Raayzeck/Thiago){FFFFFF} pela cria��o e manuten��o geral do Advanced Roleplay e seus servidores;\n\
    {36A717}Lucas Fran�a {AFAFAF}(brta$){FFFFFF} e {36A717}Wilton Barros {AFAFAF}(Wil){FFFFFF} pela idealiza��o do Advanced Roleplay;\n\
    {36A717}Victor Carbonara {AFAFAF}(Coral){FFFFFF} participa��o no desenvolvimento e elabora��o de ideias do novo gamemode;\n\
    {36A717}Gabriel Souza {AFAFAF}(Smyle){FFFFFF} pela cria��o de in�meros sistemas do Advanced Roleplay;\n\
    {36A717}Igor Marques {AFAFAF}(Wee){FFFFFF} pela cria��o e manuten��o geral do User Control Panel;\n\
    {36A717}Erick Auander {AFAFAF}(ElWonder){FFFFFF}, {36A717}Kaan Inal {AFAFAF}(Sahin){FFFFFF}, {36A717}Beatriz Merhy {AFAFAF}(Misthy/Beatriz){FFFFFF}, {36A717}Gabriel Camargo {AFAFAF}(Outfit){FFFFFF}, {36A717}Bruno Rocha {AFAFAF}(Rocha/opus dei){FFFFFF} pela confec��o de mapas e modifica��o para o servidor;\n\
    {AFAFAF}SF-CNR{FFFFFF} por deixar seu sistema de sinuca open-source;\n\
    {AFAFAF}Kalcor{FFFFFF}, {AFAFAF}Southclaws{FFFFFF}, {AFAFAF}Y_Less{FFFFFF}, {AFAFAF}maddinat0r{FFFFFF}, {AFAFAF}BigETI{FFFFFF}, {AFAFAF}iAmir{FFFFFF}, {AFAFAF}TommyB{FFFFFF}, {AFAFAF}katursis{FFFFFF} e {AFAFAF}in�meros outros{FFFFFF} que, indiretamente, colaboraram com o desenvolvimento deste servidor;\n\
    {36A717}Todos os jogadores do Advanced Roleplay{FFFFFF} pelo apoio.");

    Dialog_Show(playerid, showCredits, DIALOG_STYLE_MSGBOX, "{FFFFFF}Cr�ditos", string, "Fechar", "");
    return true;
}