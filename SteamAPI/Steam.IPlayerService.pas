unit Steam.IPlayerService;

interface

uses
  Rest.Client, Rest.Types, System.JSON, System.SysUtils,
  Steam.IPlayerService.Types;

type
  TSteamAPIIPlayerService = class
  private
    { Private Const }
    const
      API_URL = 'https://api.steampowered.com/IPlayerService/';
      API_GetRecentlyPlayedGames = 'GetRecentlyPlayedGames';
  private
    { Private Variables }
    FToken: string;
  private
    { Private Methods }
    function SetupRestRequest(const API_PATH: string): TRESTRequest;
  public
    { Public Methods }
    function GetRecentlyPlayedGames(const SteamID: UInt64; const Count: UInt32 = 0): TArray<TSteamRecentlyPlayedGame>;
    /////////////////////////////////////////////
    constructor Create(const API_Key: string);
    destructor Destroy;
  end;

implementation

{ TSteamAPIIPlayerService }

constructor TSteamAPIIPlayerService.Create(const API_Key: string);
begin
  Self.FToken := API_Key;
end;

destructor TSteamAPIIPlayerService.Destroy;
begin
  //
end;

function TSteamAPIIPlayerService.GetRecentlyPlayedGames(const SteamID: UInt64; const Count: UInt32): TArray<TSteamRecentlyPlayedGame>;
begin
  var rest := Self.SetupRestRequest(API_GetRecentlyPlayedGames);
  try
    rest.AddParameter('steamid', SteamID.ToString);
    rest.AddParameter('count', Count.ToString);
    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      var gameCount := rest.Response.JSONValue.GetValue<Integer>('response.total_count');
      SetLength(Result, gameCount);

      var I := 0;
      for var jGame in rest.Response.JSONValue.FindValue('response.games') as TJSONArray do
      begin
        var aGame: TSteamRecentlyPlayedGame;
        aGame.AppID := jgame.GetValue<Integer>('appid');
        aGame.Name := jgame.GetValue<string>('name');
        aGame.Playtime_2Weeks := jgame.GetValue<Integer>('playtime_2weeks');
        aGame.Playetime_Forever := jgame.GetValue<Integer>('playtime_forever');
        aGame.Img_Icon_URL := jgame.GetValue<string>('img_icon_url');
        aGame.Playtime_Windows_Forever := jgame.GetValue<Integer>('playtime_windows_forever');
        aGame.Playtime_Mac_forever := jgame.GetValue<Integer>('playtime_mac_forever');
        aGame.Playtime_Linux_Forever := jgame.GetValue<Integer>('playtime_linux_forever');

        Result[I] := aGame;

        Inc(I);
      end;
    end
    else
      Exception.Create('[TSteamAPIIPlayerService.GetRecentlyPlayedGames]' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
end;

function TSteamAPIIPlayerService.SetupRestRequest(const API_PATH: string): TRESTRequest;
begin
  Result := TRESTRequest.Create(nil);
  Result.Response := TRESTResponse.Create(Result);
  Result.Client := TRESTClient.Create(Result);
  Result.Client.BaseURL := API_URL + API_PATH + '/v1/';
  Result.AddParameter('key', Self.FToken);
end;

end.

