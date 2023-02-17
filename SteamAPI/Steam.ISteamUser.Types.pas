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

implementation

end.

