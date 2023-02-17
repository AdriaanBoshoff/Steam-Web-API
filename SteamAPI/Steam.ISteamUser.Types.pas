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

implementation

end.

