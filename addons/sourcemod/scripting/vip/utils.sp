
UTIL_CloseHandleEx(&Handle:hValue)
{
	if(hValue != INVALID_HANDLE)
	{
		CloseHandle(hValue);
		hValue = INVALID_HANDLE;
	}
}

stock UTIL_ReplaceChars(String:sBuffer[], InChar, OutChar)
{
	new iNum = 0;
	for (new i = 0, iLen = strlen(sBuffer); i < iLen; ++i)
	{
		if(sBuffer[i] == InChar)
		{
			sBuffer[i] = OutChar;
			iNum++;
		}
	}

	return iNum;
}

bool:UTIL_StrCmpEx(const String:sString1[], const String:sString2[])
{
	decl MaxLen, i;

	new iLen1 = strlen(sString1),
		iLen2 = strlen(sString2);

	MaxLen = (iLen1 > iLen2) ? iLen1:iLen2;

	for (i = 0; i < MaxLen; i++)
	{
		if(sString1[i] != sString2[i])
		{
			return false;
		}
	}

	return true;
}
/*
UTIL_AddMenuDefaultItem(&Handle:hMenu, const String:sItem[])
{
	if(GetMenuItemCount(hMenu) == 0) AddMenuItem(hMenu, "", sItem, ITEMDRAW_DISABLED);
}
*/

GameType:UTIL_GetGameType()
{
	if (GetFeatureStatus(FeatureType_Native, "GetEngineVersion") == FeatureStatus_Available)
	{
		switch(GetEngineVersion())
		{
			case Engine_SourceSDK2006:	return GAME_CSS_34;
			case Engine_CSS:					return GAME_CSS;
			case Engine_CSGO:				return GAME_CSGO;
		}
	}
	else if (GetFeatureStatus(FeatureType_Native, "GuessSDKVersion") == FeatureStatus_Available)
	{
		switch(GetEngineVersion())
		{
			case SOURCE_SDK_EPISODE1:			return GAME_CSS_34;
			case SOURCE_SDK_CSS:			return GAME_CSS;
			case SOURCE_SDK_CSGO:			return GAME_CSGO;
		}
	}

	return GAME_UNKNOWN;
}

UTIL_TimeToSeconds(iTime)
{
	switch(g_CVAR_iTimeMode)
	{
		case TIME_MODE_SECONDS:	return iTime;
		case TIME_MODE_MINUTES:	return iTime*60;
		case TIME_MODE_HOURS:		return iTime*3600;
		case TIME_MODE_DAYS:		return iTime*86400;
	}

	return -1;
}

UTIL_SecondsToTime(iTime)
{
	switch(g_CVAR_iTimeMode)
	{
		case TIME_MODE_SECONDS:	return iTime;
		case TIME_MODE_MINUTES:	return iTime/60;
		case TIME_MODE_HOURS:		return iTime/3600;
		case TIME_MODE_DAYS:		return iTime/86400;
	}

	return -1;
}

UTIL_GetTimeFromStamp(String:sBuffer[], maxlength, iTimeStamp, iClient = LANG_SERVER)
{
	if (iTimeStamp > 31536000)
	{
		new years = iTimeStamp / 31536000;
		new days = iTimeStamp / 86400 % 365;
		if (days > 0)
		{
			FormatEx(sBuffer, maxlength, "%d%T %d%T", years, "y.", iClient, days, "d.", iClient);
		}
		else
		{
			FormatEx(sBuffer, maxlength, "%d%T", years, "y.");
		}
		return;
	}
	if (iTimeStamp > 86400)
	{
		new days = iTimeStamp / 86400 % 365;
		new hours = (iTimeStamp / 3600) % 24;
		if (hours > 0)
		{
			FormatEx(sBuffer, maxlength, "%d%T %d%T", days, "d.", iClient, hours, "h.", iClient);
		}
		else
		{
			FormatEx(sBuffer, maxlength, "%d%T", days, "d.", iClient);
		}
		return;
	}
	else
	{
		new Hours = (iTimeStamp / 3600);
		new Mins = (iTimeStamp / 60) % 60;
		new Secs = iTimeStamp % 60;
		
		if (Hours > 0)
		{
			FormatEx(sBuffer, maxlength, "%02d:%02d:%02d", Hours, Mins, Secs);
		}
		else
		{
			FormatEx(sBuffer, maxlength, "%02d:%02d", Mins, Secs);
		}
	}
}
/*
bool:UTIL_GoToClient(iClient)
{
	decl VIP_AuthType:AuthType;
	if(GetTrieValue(g_hFeatures[iClient], KEY_AUTHTYPE, AuthType))
	{
		decl iClientID;
		if(GetTrieValue(g_hFeatures[iClient], KEY_CID, iClientID))
		{
			KvRewind(g_hUsers);
			switch(AuthType)
			{
				case AUTH_NAME:
				{
					KvJumpToKey(g_hUsers, "NAMES", false);
				}
				case AUTH_GROUP:
				{
					KvJumpToKey(g_hUsers, "ADMIN_GROUPS", false);
				}
				case AUTH_FLAGS:
				{
					KvJumpToKey(g_hUsers, "ADMIN_FLAGS", false);
				}
			}

			return KvJumpToKeySymbol(g_hUsers, iClientID);
		}
	}

	return false;
}

UTIL_SaveUsers()
{
	KvRewind(g_hUsers);
	KeyValuesToFile(g_hUsers, "addons/sourcemod/data/vip/cfg/users.ini");
}

UTIL_LoadVipCmd(Handle:hCvar, ConCmd:Call_CMD)
{
	decl iNum, String:sBuffer[128];
	GetConVarString(hCvar, sBuffer, sizeof(sBuffer));
	iNum = SearchCharInString(sBuffer, ';');

	if(iNum)
	{
		decl String:sCMDs[iNum+1][32], iSize, i;
		iSize = ExplodeString(sBuffer, ";", sCMDs, iNum+1, 32);
		for (i = 0; i < iSize; ++i)
		{
			if(strlen(sCMDs[i]) > 1)
			{
				DebugMessage("LoadVipCmd: %s", sCMDs[i])
				RegConsoleCmd(sCMDs[i], Call_CMD);
			}
		}
	} else
	{
		DebugMessage("LoadVipCmd: %s", sBuffer)

		RegConsoleCmd(sBuffer, Call_CMD);
	}
}

*/

UTIL_LoadVipCmd(&Handle:hCvar, ConCmd:Call_CMD)
{
	decl String:sPart[64], String:sBuffer[128], reloc_idx, iPos;
	GetConVarString(hCvar, sBuffer, sizeof(sBuffer));
	reloc_idx = 0;
	while ((iPos = SplitString(sBuffer[reloc_idx], ";", sPart, sizeof(sPart))))
	{
		if (iPos == -1)
		{
			strcopy(sPart, sizeof(sPart), sBuffer[reloc_idx]);
		}
		else
		{
			reloc_idx += iPos;
		}
		
		TrimString(sPart);
		
		if (sPart[0])
		{
			RegConsoleCmd(sPart, Call_CMD);
			
			if (iPos == -1)
			{
				return;
			}
		}
	}
}

UTIL_GetConVarAdminFlag(&Handle:hCvar)
{
	decl String:sBuffer[32];
	GetConVarString(hCvar, sBuffer, sizeof(sBuffer));
	return ReadFlagString(sBuffer);
}

bool:UTIL_CheckValidVIPGroup(const String:sGroup[])
{
	KvRewind(g_hGroups);
	return KvJumpToKey(g_hGroups, sGroup, false);
}

stock UTIL_SearchCharInString(const String:sBuffer[], c)
{
	decl iNum, i, iLen;
	iNum = 0;
	iLen = strlen(sBuffer);
	for (i = 0; i < iLen; ++i)
		if(sBuffer[i] == c) iNum++;
	
	return iNum;
}

UTIL_ReloadVIPPlayers(iClient, bool:bNotify)
{
	for(new i = 1; i <= MaxClients; ++i)
	{
		if (IsClientInGame(i))
		{
			Clients_CheckVipAccess(i, false);
		}
	}

	if(bNotify)
	{
		ReplyToCommand(iClient, "%t", "VIP_CACHE_REFRESHED");
	}
}

bool:UTIL_ADD_VIP_PLAYER(const iClient = -1, const iTarget = 0, const String:sSourceAuth[] = "", const String:sSourceName[] = "", const iTime, const String:sGroup[] = "")
{
	decl String:sAuth[32], String:sName[MAX_NAME_LENGTH], iExpires;

	if(iTime)
	{
		iExpires = iTime + GetTime();
	}
	else
	{
		iExpires = iTime;
	}

	if(iTarget)
	{
		if (GetFeatureStatus(FeatureType_Native, "GetClientAuthId") == FeatureStatus_Available)
		{
			GetClientAuthId(iTarget, AuthId_Engine, sAuth, sizeof(sAuth));
		}
		else
		{
			GetClientAuthString(iTarget, sAuth, sizeof(sAuth));
		}
		GetClientName(iTarget, sName, sizeof(sName));
	}
	else
	{
		strcopy(sAuth, sizeof(sAuth), sIdentity);
		strcopy(sName, sizeof(sName), sSourceName[0] ? sSourceName:"unknown");
	}
	
	decl Handle:hStmt, Handle:hDataPack, String:sError[256];

	hDataPack = CreateDataPack();
	hStmt = INVALID_HANDLE;

	if (g_bMySQL)
	{
		ADD_PARAM_STR(hDataPack, sAuth)
		if(DB_ExecuteQuery("SELECT `id` FROM `vip_users` WHERE `auth` = ? LIMIT 1;", hStmt, hDataPack, SZF(sError)))
		{
			LogMessage("[VIP Core] Query Successfull Executed");

			decl ID;

			if(SQL_FetchRow(hStmt))
			{
				LogMessage("[VIP Core] SQL_FetchRow");
				ID = SQL_FetchInt(hStmt, 0);
				LogMessage("[VIP Core] ID = %i", ID);
			}
			else
			{
				LogMessage("[VIP Core] ! SQL_FetchRow");
				
				hDataPack = CreateDataPack();
				ADD_PARAM_STR(hDataPack, sAuth)
				ADD_PARAM_STR(hDataPack, sName)

				if(DB_ExecuteQuery("INSERT INTO `vip_users` (`auth`, `name`) VALUES (?, ?);", hStmt, hDataPack, SZF(sError)))
				{
					LogMessage("[VIP Core] Query Successfull Executed");

					ID = SQL_GetInsertId(g_hDatabase);
					LogMessage("[VIP Core] SQL_GetInsertId = %i", ID);
				}
			}

			hDataPack = CreateDataPack();
			ADD_PARAM_INT(hDataPack, ID)
			ADD_PARAM_INT(hDataPack, g_CVAR_iServerID)
			ADD_PARAM_INT(hDataPack, iExpires)
			ADD_PARAM_STR(hDataPack, sGroup)
			ADD_PARAM_INT(hDataPack, iExpires)
			ADD_PARAM_STR(hDataPack, sGroup)

			if(!DB_ExecuteQuery("INSERT INTO `vip_overrides` (`user_id`, `server_id`, `expires`, `group`) VALUES (?, ?, ?, ?) \
									ON DUPLICATE KEY UPDATE `expires` = ?, `group` = ?;", hStmt, hDataPack, SZF(sError)))
			{
			//	LogMessage("[VIP Core] Query Successfull Executed");
				CloseHandle(hStmt);
				return false;
			}
		}
	}
	else
	{
		ADD_PARAM_STR(hDataPack, sAuth)
		ADD_PARAM_STR(hDataPack, sName)
		ADD_PARAM_INT(hDataPack, iExpires)
		ADD_PARAM_STR(hDataPack, sGroup)

		if(!DB_ExecuteQuery("INSERT OR REPLACE INTO `vip_users` (`auth`, `name`, `expires`, `group`) VALUES (?, ?, ?, ?);", hStmt, hDataPack, SZF(sError)))
		{
			//	LogMessage("[VIP Core] Query Successfull Executed");
			CloseHandle(hStmt);
			return false;
		}
	}
	
	CloseHandle(hStmt);
	
	if(SQL_GetAffectedRows(g_hDatabase))
	{
		ResetPack(hDataPack);
	
		decl String:sExpires[64], String:sTime[64];

		if(sGroup[0] == '\0')
		{
			FormatEx(sGroup, sizeof(sGroup), "%T", "NONE", iClient);
		}

		if(iTime)
		{
			UTIL_GetTimeFromStamp(sExpires, sizeof(sExpires), iTime, iClient);
			FormatTime(sTime, sizeof(sTime), "%d/%m/%Y - %H:%M", iExpires);
		}
		else
		{
			FormatEx(sExpires, sizeof(sExpires), "%T", "PERMANENT", iClient);
			FormatEx(sTime, sizeof(sTime), "%T", "NEVER", iClient);
		}

		if(iTarget)
		{
			Clients_CheckVipAccess(iTarget, true);
		}

		if (iClient == 0)
		{
			PrintToServer("%T", "ADMIN_ADD_VIP_IDENTITY_SUCCESSFULLY", LANG_SERVER);
		}
		else if (iClient != -1)
		{
			VIP_PrintToChatClient(iClient, "%t", "ADMIN_ADD_VIP_IDENTITY_SUCCESSFULLY");
		}

		if(g_CVAR_bLogsEnable)
		{
		//	LogToFile(g_sLogFile, "%T", "LOG_ADMIN_ADD_VIP_IDENTITY_SUCCESSFULLY", iClient, iClient, sAuth, sExpires, sTime, sGroup);
		}

		return true;
	}

	return false;
}
