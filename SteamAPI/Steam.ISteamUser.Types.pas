unit Steam.ISteamUser.Types;

interface

type
  TISteamUser_PlayerBan = record
    SteamID: string;
    CommunityBanned: Boolean;
    VACBanned: Boolean;
    NumberOfVACBans: Integer;
    DaysSinceLastBan: Integer;
    NumberOfGameBans: Integer;
    EconomyBan: string;
  end;

type
  TISteamUser_FriendList = record
    SteamID: string;
    Relationship: string;
    Friend_Since: Int64;
  end;

type
  TISteamUser_PlayerSummary = record
    SteamID: string;
    CommunityVisibilityState: Integer;
    ProfileState: Integer;
    PersonaName: string;
    CommentPermission: Integer;
    ProfileURL: string;
    AvatarURL: string;
    AvatarMediumURL: string;
    AvatarFullURL: string;
    AvatarHash: string;
    LastLogOff: Int64;
    PersonaState: Integer;
    PrimaryClanID: string;
    TimeCreated: Int64;
    PersonaStateFlags: Integer;
    GameServerIP: string;
    GameServerSteamID: string;
    GameExtraInfo: string;
    GameID: string;
    LocCountryCode: string;
    LocStateCode: string;
    LocCityID: string;
  end;

implementation

end.

