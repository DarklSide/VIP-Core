#pragma semicolon 1

#include <sourcemod>
#include <vip_core>
#include <clientprefs>

#define DEBUG_MODE 0

#define VIP_VERSION	"2.2.0 DEV"

public Plugin:myinfo =
{
	name = "[VIP] Core",
	author = "R1KO (skype: vova.andrienko1)",
	version = VIP_VERSION,
	url = "http://hlmod.ru"
};


#if DEBUG_MODE 1
new String:g_sDebugLogFile[PLATFORM_MAX_PATH];

stock DebugMsg(const String:sMsg[], any:...)
{
	decl String:sBuffer[250];
	VFormat(sBuffer, sizeof(sBuffer), sMsg, 2);
	LogToFile(g_sDebugLogFile, sBuffer);
}
#define DebugMessage(%0) DebugMsg(%0);
#else
#define DebugMessage(%0)
#endif

#include "vip/downloads.sp"
#include "vip/vars.sp"
#include "vip/utils.sp"
#include "vip/features.sp"
#include "vip/sounds.sp"
#include "vip/info.sp"
#include "vip/db.sp"
#include "vip/initialization.sp"
#include "vip/cvars.sp"
#include "vip/vipmenu.sp"
#include "vip/api.sp"
#include "vip/cmds.sp"
#include "vip/clients.sp"

public OnPluginStart()
{
	#if DEBUG_MODE 0
	BuildPath(Path_SM, g_sDebugLogFile, sizeof(g_sDebugLogFile), "logs/VIP_Debug.log");
	#endif

	LoadTranslations("vip_core.phrases");
	LoadTranslations("vip_modules.phrases");
	LoadTranslations("common.phrases");

	GLOBAL_ARRAY	= CreateArray(ByteCountToCells(FEATURE_NAME_LENGTH));
	GLOBAL_TRIE	= CreateTrie();
	ReadConfigs();

	g_hVIPMenu = CreateMenu(Handler_VIPMenu, MenuAction_Start|MenuAction_Display|MenuAction_Cancel|MenuAction_Select|MenuAction_DisplayItem|MenuAction_DrawItem);

	AddMenuItem(g_hVIPMenu, "NO_FEATURES", "NO_FEATURES", ITEMDRAW_DISABLED);

	CreateCvars();
	CreateForwards();

	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("cs_match_end_restart", Event_MatchEndRestart, EventHookMode_PostNoCopy);

	RegConsoleCmd("sm_refresh_vips",	ReloadVIPPlayers_CMD);
	RegConsoleCmd("sm_reload_vip_cfg",	ReloadVIPCfg_CMD);
	RegConsoleCmd("sm_addvip",			AddVIP_CMD);
	RegConsoleCmd("sm_delvip",			DelVIP_CMD);

	g_GameType = UTIL_GetGameType();
}

public OnAllPluginsLoaded()
{
	DB_OnPluginStart();
}