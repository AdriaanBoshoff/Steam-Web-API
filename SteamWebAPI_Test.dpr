program SteamWebAPI_Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Steam.API in 'SteamAPI\Steam.API.pas',
  Steam.IPlayerService in 'SteamAPI\Steam.IPlayerService.pas',
  Steam.IPlayerService.Types in 'SteamAPI\Steam.IPlayerService.Types.pas';

const
  API_KEY = ''; // Removed for github

const
  STEAM_ID = 76561198113034550;

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
  try
    //Main;

    Test_IPlayerService_GetSteamLevel;

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

