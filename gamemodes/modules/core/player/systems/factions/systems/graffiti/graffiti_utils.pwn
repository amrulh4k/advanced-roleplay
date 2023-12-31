#define MAX_GRAFFITI (500)

enum GRAFFITI_INFO {
    gID,
    bool: gExists,
    Float: gX,
    Float: gY,
    Float: gZ,
    Float: gRX,
    Float: gRY,
    Float: gRZ,
    gObject,
    gText[64],
    gFont[32],
    gSize,
    gColor,
    gBold,
    gAuthor
}
new Graffiti[MAX_GRAFFITI][GRAFFITI_INFO];

new graffiti_text[3072];

new GraffitiColors[][] =
{
    "{FFFFCC}FFFFCC", "{FFFF99}FFFF99", "{FFFF66}FFFF66", "{FFFF33}FFFF33", "{FFFF00}FFFF00", "{CCCC00}CCCC00",
    "{FF9900}FF9900", "{FF9933}FF9933", "{CC9966}CC9966", "{CC6600}CC6600", "{996633}996633", "{663300}663300",
    "{FF6633}FF6633", "{CC3300}CC3300", "{FF3300}FF3300", "{FF0000}FF0000", "{CC0000}CC0000", "{990000}990000",
    "{FFCCCC}FFCCCC", "{FF9999}FF9999", "{FF6666}FF6666", "{FF3333}FF3333", "{FF0033}FF0033", "{CC0033}CC0033",
    "{FF6699}FF6699", "{FF3366}FF3366", "{FF0066}FF0066", "{CC3366}CC3366", "{996666}996666", "{663333}663333",
    "{FF99CC}FF99CC", "{FF3399}FF3399", "{FF0099}FF0099", "{CC0066}CC0066", "{993366}993366", "{660033}660033",
    "{CC99FF}CC99FF", "{9933CC}9933CC", "{9933FF}9933FF", "{9900FF}9900FF", "{660099}660099", "{663366}663366",
    "{9966CC}9966CC", "{9966FF}9966FF", "{6600CC}6600CC", "{6633CC}6633CC", "{663399}663399", "{330033}330033",
    "{CCCCFF}CCCCFF", "{9999FF}9999FF", "{6633FF}6633FF", "{6600FF}6600FF", "{330099}330099", "{330066}330066",
    "{6699FF}6699FF", "{3366FF}3366FF", "{0000FF}0000FF", "{0000CC}0000CC", "{0033CC}0033CC", "{000033}000033",
    "{0066FF}0066FF", "{0066CC}0066CC", "{3366CC}3366CC", "{0033FF}0033FF", "{003399}003399", "{003366}003366",
    "{99CCFF}99CCFF", "{3399FF}3399FF", "{0099FF}0099FF", "{6699CC}6699CC", "{336699}336699", "{006699}006699",
    "{99CCCC}99CCCC", "{66CCCC}66CCCC", "{339999}339999", "{669999}669999", "{006666}006666", "{336666}336666",
    "{99FFCC}99FFCC", "{66FFCC}66FFCC", "{33FFCC}33FFCC", "{00FFCC}00FFCC", "{33CCCC}33CCCC", "{009999}009999",
    "{CCFFCC}CCFFCC", "{99CC99}99CC99", "{66CC66}66CC66", "{669966}669966", "{336633}336633", "{003300}003300",
    "{33FF33}33FF33", "{00FF33}00FF33", "{00FF00}00FF00", "{00CC00}00CC00", "{33CC33}33CC33", "{00CC33}00CC33",
    "{66FF00}66FF00", "{66FF33}66FF33", "{33FF00}33FF00", "{33CC00}33CC00", "{339900}339900", "{009900}009900",
    "{CCFF99}CCFF99", "{99FF66}99FF66", "{66CC00}66CC00", "{66CC33}66CC33", "{669933}669933", "{336600}336600",
    "{99FF00}99FF00", "{99FF33}99FF33", "{99CC66}99CC66", "{99CC00}99CC00", "{99CC33}99CC33", "{669900}669900",
    "{FFFFFF}FFFFFF", "{CCCCCC}CCCCCC", "{999999}999999", "{666666}666666", "{333333}333333", "{000000}000000"
};

new GraffitiColorARGB[] =
{
    0xFFFFCC, 0xFFFF99, 0xFFFF66, 0xFFFF33, 0xFFFF00, 0xCCCC00,
    0xFF9900, 0xFF9933, 0xCC9966, 0xCC6600, 0x996633, 0x663300,
    0xFF6633, 0xCC3300, 0xFF3300, 0xFF0000, 0xCC0000, 0x990000,
    0xFFCCCC, 0xFF9999, 0xFF6666, 0xFF3333, 0xFF0033, 0xCC0033,
    0xFF6699, 0xFF3366, 0xFF0066, 0xCC3366, 0x996666, 0x663333,
    0xFF99CC, 0xFF3399, 0xFF0099, 0xCC0066, 0x993366, 0x660033,
    0xCC99FF, 0x9933CC, 0x9933FF, 0x9900FF, 0x660099, 0x663366,
    0x9966CC, 0x9966FF, 0x6600CC, 0x6633CC, 0x663399, 0x330033,
    0xCCCCFF, 0x9999FF, 0x6633FF, 0x6600FF, 0x330099, 0x330066,
    0x6699FF, 0x3366FF, 0x0000FF, 0x0000CC, 0x0033CC, 0x000033,
    0x0066FF, 0x0066CC, 0x3366CC, 0x0033FF, 0x003399, 0x003366,
    0x99CCFF, 0x3399FF, 0x0099FF, 0x6699CC, 0x336699, 0x006699,
    0x99CCCC, 0x66CCCC, 0x339999, 0x669999, 0x006666, 0x336666,
    0x99FFCC, 0x66FFCC, 0x33FFCC, 0x00FFCC, 0x33CCCC, 0x009999,
    0xCCFFCC, 0x99CC99, 0x66CC66, 0x669966, 0x336633, 0x003300,
    0x33FF33, 0x00FF33, 0x00FF00, 0x00CC00, 0x33CC33, 0x00CC33,
    0x66FF00, 0x66FF33, 0x33FF00, 0x33CC00, 0x339900, 0x009900,
    0xCCFF99, 0x99FF66, 0x66CC00, 0x66CC33, 0x669933, 0x336600,
    0x99FF00, 0x99FF33, 0x99CC66, 0x99CC00, 0x99CC33, 0x669900,
    0xFFFFFF, 0xCCCCCC, 0x999999, 0x666666, 0x333333, 0x000000
};