unit Steam.IPlayerService.Types;

interface

type
  TSteamRecentlyPlayedGame = record
    AppID: Integer;
    Name: string;
    Playtime_2Weeks: Integer;
    Playetime_Forever: Integer;
    Img_Icon_URL: string;
    Playtime_Windows_Forever: Integer;
    Playtime_Mac_forever: Integer;
    Playtime_Linux_Forever: Integer;
  end;

type
  TSteamOwnedGame = record
    AppID: Integer;
    Name: string;
    Playetime_Forever: Integer;
    Img_Icon_URL: string;
    Has_Community_Visible_Stats: Boolean;
    Playtime_Windows_Forever: Integer;
    Playtime_Mac_forever: Integer;
    Playtime_Linux_Forever: Integer;
    rTime_Last_Played: Int64
  end;

type
  TSteamBadge = record
    BadgeID: Integer;
    AppID: Integer;
    Level: Integer;
    CompletionTime: Int64;
    XP: Integer;
    CommunityID: string;
    Scarcity: Integer;
  end;

type
  TSteamPlayerBadges = record
    Badges: TArray<TSteamBadge>;
    PlayerXP: Integer;
    PlayerLevel: Integer;
    PlayerXpNeededToLevelUp: Integer;
    PlayerXpNeededCurrentLevel: Integer;
  end;

implementation

end.

