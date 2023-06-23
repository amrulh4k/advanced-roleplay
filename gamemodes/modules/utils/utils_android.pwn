#include <YSI_Players\y_android>

public OnAndroidCheck(playerid, bool:isDisgustingThiefToBeBanned) {
    if (isDisgustingThiefToBeBanned) {
        SendErrorMessage(playerid, "You cannot log into Advanced Roleplay via a mobile phone.");
        KickEx(playerid);
    }
}