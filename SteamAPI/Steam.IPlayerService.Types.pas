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

implementation

end.

