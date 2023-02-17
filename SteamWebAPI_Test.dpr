program SteamWebAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Steam.API in 'SteamAPI\Steam.API.pas',
  Steam.IPlayerService in 'SteamAPI\Steam.IPlayerService.pas',
  Steam.IPlayerService.Types in 'SteamAPI\Steam.IPlayerService.Types.pas',
  Steam.ISteamUser in 'SteamAPI\Steam.ISteamUser.pas',
  Steam.ISteamUser.Types in 'SteamAPI\Steam.ISteamUser.Types.pas';

const
  API_KEY = ''; // Removed for github

const
  STEAM_ID = 76561198113034550;

procedure Test_ISteamUser_GetPlayerBans;
begin
  var steam := TSteamAPI.Create(API_KEY);
  try
    for var aBan in steam.ISteamUser.GetPlayerBans('76561198113034550,76561198230794964,76561198068945665') do
    begin
      Writeln(Format('SteamId: %s', [aBan.SteamID]));
      Writeln(Format('CommunityBanned: %s', [BoolToStr(aBan.CommunityBanned, True)]));
      Writeln(Format('VACBanned: %s', [BoolToStr(aBan.VACBanned, True)]));
      Writeln(Format('NumberOfVACBans: %d', [aBan.NumberOfVACBans]));
      Writeln(Format('DaysSinceLastBan: %d', [aBan.DaysSinceLastBan]));
      Writeln(Format('NumberOfGameBans: %d', [aBan.NumberOfGameBans]));
      Writeln(Format('EconomyBan: %s', [aBan.EconomyBan]));
      Writeln('===================================');
    end;
  finally
    steam.Destroy;
  end;
end;

procedure Test_IPlayerService_GetRecentlyPlayedGames;
begin
  var steam := TSteamAPI.Create(API_KEY);
  try
    for var aGame in steam.IPlayerService.GetRecentlyPlayedGames(STEAM_ID, 0) do
    begin
      Writeln(Format('Game: %s   Hours: %d', [aGame.Name, aGame.Playetime_Forever div 60]));
    end;
  finally
    steam.Destroy;
  end;
end;

procedure Test_IPlayerService_GetOwnedGames;
begin
  var steam := TSteamAPI.Create(API_KEY);
  try
    var I := 0;
    for var aGame in steam.IPlayerService.GetOwnedGames(STEAM_ID, False, True) do
    begin
      Writeln(Format('Game: %s   Hours: %d', [aGame.Name, aGame.Playetime_Forever div 60]));

      Inc(I);
    end;

    Writeln(Format('Total Games: %d', [I]));
  finally
    steam.Destroy;
  end;
end;

procedure Test_IPlayerService_GetSteamLevel;
begin
  var steam := TSteamAPI.Create(API_KEY);
  try
    Writeln(Format('Steam Level: %d', [steam.IPlayerService.GetSteamLevel(STEAM_ID)]));
  finally
    steam.Destroy;
  end;
end;

procedure Test_IPlayerService_GetBadges;
begin
  var steam := TSteamAPI.Create(API_KEY);
  try
    var result := steam.IPlayerService.GetBadges(STEAM_ID);
    for var aBadge in result.Badges do
      Writeln(aBadge.Level);

    Writeln(result.PlayerXP);
    Writeln(result.PlayerLevel);
    Writeln(result.PlayerXpNeededToLevelUp);
    Writeln(result.PlayerXpNeededCurrentLevel);
  finally
    steam.Destroy;
  end;
end;

procedure Main;
begin
  while True do
  begin
    Write('>> ');
    var aResponse: string;
    Readln(aResponse);

    // Exit
    if aResponse = 'exit' then
    begin
      Break;
    end
    else
      Writeln(Format('Unknown command "%s"', [aResponse]));
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    //Main;

    Test_ISteamUser_GetPlayerBans;

    Writeln('Press any key to exit.');
    ReadLn;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.

