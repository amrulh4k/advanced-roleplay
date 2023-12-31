#include <YSI_Coding\y_hooks>

static const gVehicleColors[] = {
    0x000000AA, 0xF5F5F5AA, 0x2A77A1AA, 0x840410AA, 0x263739AA, 0x86446EAA, 0xD78E10AA, 0x4C75B7AA, 0xBDBEC6AA, 0x5E7072AA,
    0x46597AAA, 0x656A79AA, 0x5D7E8DAA, 0x58595AAA, 0xD6DAD6AA, 0x9CA1A3AA, 0x335F3FAA, 0x730E1AAA, 0x7B0A2AAA, 0x9F9D94AA,
    0x3B4E78AA, 0x732E3EAA, 0x691E3BAA, 0x96918CAA, 0x515459AA, 0x3F3E45AA, 0xA5A9A7AA, 0x635C5AAA, 0x3D4A68AA, 0x979592AA,
    0x421F21AA, 0x5F272BAA, 0x8494ABAA, 0x767B7CAA, 0x646464AA, 0x5A5752AA, 0x252527AA, 0x2D3A35AA, 0x93A396AA, 0x6D7A88AA,
    0x221918AA, 0x6F675FAA, 0x7C1C2AAA, 0x5F0A15AA, 0x193826AA, 0x5D1B20AA, 0x9D9872AA, 0x7A7560AA, 0x989586AA, 0xADB0B0AA,
    0x848988AA, 0x304F45AA, 0x4D6268AA, 0x162248AA, 0x272F4BAA, 0x7D6256AA, 0x9EA4ABAA, 0x9C8D71AA, 0x6D1822AA, 0x4E6881AA,
    0x9C9C98AA, 0x917347AA, 0x661C26AA, 0x949D9FAA, 0xA4A7A5AA, 0x8E8C46AA, 0x341A1EAA, 0x6A7A8CAA, 0xAAAD8EAA, 0xAB988FAA,
    0x851F2EAA, 0x6F8297AA, 0x585853AA, 0x9AA790AA, 0x601A23AA, 0x20202CAA, 0xA4A096AA, 0xAA9D84AA, 0x78222BAA, 0x0E316DAA,
    0x722A3FAA, 0x7B715EAA, 0x741D28AA, 0x1E2E32AA, 0x4D322FAA, 0x7C1B44AA, 0x2E5B20AA, 0x395A83AA, 0x6D2837AA, 0xA7A28FAA,
    0xAFB1B1AA, 0x364155AA, 0x6D6C6EAA, 0x0F6A89AA, 0x204B6BAA, 0x2B3E57AA, 0x9B9F9DAA, 0x6C8495AA, 0x4D8495AA, 0xAE9B7FAA,
    0x406C8FAA, 0x1F253BAA, 0xAB9276AA, 0x134573AA, 0x96816CAA, 0x64686AAA, 0x105082AA, 0xA19983AA, 0x385694AA, 0x525661AA,
    0x7F6956AA, 0x8C929AAA, 0x596E87AA, 0x473532AA, 0x44624FAA, 0x730A27AA, 0x223457AA, 0x640D1BAA, 0xA3ADC6AA, 0x695853AA,
    0x9B8B80AA, 0x620B1CAA, 0x5B5D5EAA, 0x624428AA, 0x731827AA, 0x1B376DAA, 0xEC6AAEAA, 0x000000AA, 0x177517AA, 0x210606AA,
    0x125478AA, 0x452A0DAA, 0x571E1EAA, 0x010701AA, 0x25225AAA, 0x2C89AAAA, 0x8A4DBDAA, 0x35963AAA, 0xB7B7B7AA, 0x464C8DAA,
    0x84888CAA, 0x817867AA, 0x817A26AA, 0x6A506FAA, 0x583E6FAA, 0x8CB972AA, 0x824F78AA, 0x6D276AAA, 0x1E1D13AA, 0x1E1306AA,
    0x1F2518AA, 0x2C4531AA, 0x1E4C99AA, 0x2E5F43AA, 0x1E9948AA, 0x1E9999AA, 0x999976AA, 0x7C8499AA, 0x992E1EAA, 0x2C1E08AA,
    0x142407AA, 0x993E4DAA, 0x1E4C99AA, 0x198181AA, 0x1A292AAA, 0x16616FAA, 0x1B6687AA, 0x6C3F99AA, 0x481A0EAA, 0x7A7399AA,
    0x746D99AA, 0x53387EAA, 0x222407AA, 0x3E190CAA, 0x46210EAA, 0x991E1EAA, 0x8D4C8DAA, 0x805B80AA, 0x7B3E7EAA, 0x3C1737AA,
    0x733517AA, 0x781818AA, 0x83341AAA, 0x8E2F1CAA, 0x7E3E53AA, 0x7C6D7CAA, 0x020C02AA, 0x072407AA, 0x163012AA, 0x16301BAA,
    0x642B4FAA, 0x368452AA, 0x999590AA, 0x818D96AA, 0x99991EAA, 0x7F994CAA, 0x839292AA, 0x788222AA, 0x2B3C99AA, 0x3A3A0BAA,
    0x8A794EAA, 0x0E1F49AA, 0x15371CAA, 0x15273AAA, 0x375775AA, 0x060820AA, 0x071326AA, 0x20394BAA, 0x2C5089AA, 0x15426CAA,
    0x103250AA, 0x241663AA, 0x692015AA, 0x8C8D94AA, 0x516013AA, 0x090F02AA, 0x8C573AAA, 0x52888EAA, 0x995C52AA, 0x99581EAA,
    0x993A63AA, 0x998F4EAA, 0x99311EAA, 0x0D1842AA, 0x521E1EAA, 0x42420DAA, 0x4C991EAA, 0x082A1DAA, 0x96821DAA, 0x197F19AA,
    0x3B141FAA, 0x745217AA, 0x893F8DAA, 0x7E1A6CAA, 0x0B370BAA, 0x27450DAA, 0x071F24AA, 0x784573AA, 0x8A653AAA, 0x732617AA,
    0x319490AA, 0x56941DAA, 0x59163DAA, 0x1B8A2FAA, 0x38160BAA, 0x041804AA, 0x355D8EAA, 0x2E3F5BAA, 0x561A28AA, 0x4E0E27AA,
    0x706C67AA, 0x3B3E42AA, 0x2E2D33AA, 0x7B7E7DAA, 0x4A4442AA, 0x28344EAA
};

CMD:cores(playerid, params[]){
    static color_list[3072];
    color_list[0] = EOS;

    for (new colorid; colorid != sizeof gVehicleColors; colorid++)
        format(color_list, sizeof color_list, "%s{%06x}%03d%s", color_list, gVehicleColors[colorid] >>> 8, colorid, !((colorid + 1) % 16) ? ("\n") : (" "));
    
    Dialog_Show(playerid, vDialogColors, DIALOG_STYLE_MSGBOX, "Lista de Cores", color_list, "Fechar", "");
    return true;
}