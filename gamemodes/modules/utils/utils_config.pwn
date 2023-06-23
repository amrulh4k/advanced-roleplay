#include <YSI_Coding\y_hooks>

#define     LASTEST_RELEASE     "01/03/2023"
#define     VERSIONING          "0.1.6b - Beta"
#define     SERVERIP            "localhost:777"
#define     SERVERUCP           "https://ucp.advanced-roleplay.com.br"
#define     SERVERFORUM         "https://forum.advanced-roleplay.com.br"

new Server_Instability = 0;
// 0 = Access normal
// 1 = Access suspended

new SERVER_TYPE;
// 0 - localhost
// 1 - closedbeta
// 2 - closedalpha
// 3 - sandbox
// 4 - normal

new SERVER_MAINTENANCE;
// false = server online
// true = maintenance

new query[2048];

hook OnGameModeInit() {
    new servertype[256], maintence[256];
    if(Env_Has("SERVER_TYPE")) Env_Get("SERVER_TYPE", servertype, sizeof(servertype));
    
    if (!strcmp(servertype, "localhost", true)) SERVER_TYPE = 0;
    else if (!strcmp(servertype, "closedbeta", true)) SERVER_TYPE = 1;
    else if (!strcmp(servertype, "closedalpha", true)) SERVER_TYPE = 2;
    else if (!strcmp(servertype, "sandbox", true)) SERVER_TYPE = 3;
    else if (!strcmp(servertype, "normal", true)) SERVER_TYPE = 4;

    if(Env_Has("SERVER_MAINTENANCE")) Env_Get("SERVER_MAINTENANCE", maintence, sizeof(maintence));
    
    if (!strcmp(maintence, "false", true)) SERVER_MAINTENANCE = 0;
    else if (!strcmp(maintence, "true", true)) SERVER_MAINTENANCE = 1;

    return true;
}