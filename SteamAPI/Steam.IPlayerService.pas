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
      API_GetOwnedGames = 'GetOwnedGames';
      API_GetSteamLevel = 'GetSteamLevel';
      API_GetBadges = 'GetBadges';
  private
    { Private Variables }
    FToken: string;
  private
    { Private Methods }
    function SetupRestRequest(const API_PATH: string): TRESTRequest;
  public
    { Public Methods }
    function GetRecentlyPlayedGames(const SteamID: UInt64; const Count: UInt32 = 0): TArray<TSteamRecentlyPlayedGame>;
    function GetOwnedGames(const SteamID: UInt64; const IncludeAppInfo, IncludeFreeGames: Boolean): TArray<TSteamOwnedGame>;
    function GetSteamLevel(const SteamID: UInt64): Integer;
    function GetBadges(const SteamID: UInt64): TSteamPlayerBadges;
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

function TSteamAPIIPlayerService.GetBadges(const SteamID: UInt64): TSteamPlayerBadges;
begin
  var rest := Self.SetupRestRequest(API_GetBadges);
  try
    rest.AddParameter('steamid', SteamID.ToString);
    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      var badgeCount :=(rest.Response.JSONValue.FindValue('response.badges') as TJSONArray).Count;

      SetLength(Result.Badges, badgeCount);

      var I := 0;
      for var jBadge in rest.Response.JSONValue.FindValue('response.badges') as TJSONArray do
      begin
        var aBadge: TSteamBadge;
        jBadge.TryGetValue<Integer>('badgeid', aBadge.BadgeID);
        jBadge.TryGetValue<Integer>('appid', aBadge.AppID);
        jBadge.TryGetValue<Integer>('level', aBadge.Level);
        jBadge.TryGetValue<Int64>('completion_time', aBadge.CompletionTime);
        jBadge.TryGetValue<Integer>('xp', aBadge.XP);
        jBadge.TryGetValue<string>('communityitemid', aBadge.CommunityID);
        jBadge.TryGetValue<Integer>('scarcity', aBadge.Scarcity);

        Result.Badges[I] := aBadge;

        Inc(I);
      end;

      rest.Response.JSONValue.TryGetValue<Integer>('response.player_xp', result.PlayerXP);
      rest.Response.JSONValue.TryGetValue<Integer>('response.player_level', result.PlayerLevel);
      rest.Response.JSONValue.TryGetValue<Integer>('response.player_xp_needed_to_level_up', result.PlayerXpNeededToLevelUp);
      rest.Response.JSONValue.TryGetValue<Integer>('response.player_xp_needed_current_level', result.PlayerXpNeededCurrentLevel);
    end
    else
      raise Exception.Create('[TSteamAPIIPlayerService.GetBadges] ' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
end;

function TSteamAPIIPlayerService.GetOwnedGames(const SteamID: UInt64; const IncludeAppInfo, IncludeFreeGames: Boolean): TArray<TSteamOwnedGame>;
begin
  var rest := Self.SetupRestRequest(API_GetOwnedGames);
  try
    rest.AddParameter('steamid', SteamID.ToString);

    if IncludeAppInfo then
      rest.AddParameter('include_appinfo', 'True')
    else
      rest.AddParameter('include_appinfo', 'False');

    if IncludeFreeGames then
      rest.AddParameter('include_played_free_games', 'True')
    else
      rest.AddParameter('include_played_free_games', 'False');

    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      var gameCount := rest.Response.JSONValue.GetValue<Integer>('response.game_count');
      SetLength(Result, gameCount);

      var I := 0;
      for var jGame in rest.Response.JSONValue.FindValue('response.games') as TJSONArray do
      begin
        var aGame: TSteamOwnedGame;
        jgame.TryGetValue<Integer>('appid', aGame.AppID);
        jgame.TryGetValue<string>('name', aGame.Name);
        jgame.TryGetValue<Integer>('playtime_forever', aGame.Playetime_Forever);
        jgame.TryGetValue<string>('img_icon_url', aGame.Img_Icon_URL);
        jgame.TryGetValue<Boolean>('has_community_visible_stats', aGame.Has_Community_Visible_Stats);
        jgame.TryGetValue<Integer>('playtime_windows_forever', aGame.Playtime_Windows_Forever);
        jgame.TryGetValue<Integer>('playtime_mac_forever', aGame.Playtime_Mac_forever);
        jgame.TryGetValue<Integer>('playtime_linux_forever', aGame.Playtime_Linux_Forever);
        jgame.TryGetValue<Int64>('rtime_last_played', aGame.rTime_Last_Played);

        Result[I] := aGame;

        Inc(I);
      end;
    end
    else
      raise Exception.Create('[TSteamAPIIPlayerService.GetOwnedGames] ' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
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
        jgame.TryGetValue<Integer>('appid', aGame.AppID);
        jgame.TryGetValue<string>('name', aGame.Name);
        jgame.TryGetValue<Integer>('playtime_2weeks', aGame.Playtime_2Weeks);
        jgame.TryGetValue<Integer>('playtime_forever', aGame.Playetime_Forever);
        jgame.TryGetValue<string>('img_icon_url', aGame.Img_Icon_URL);
        jgame.TryGetValue<Integer>('playtime_windows_forever', aGame.Playtime_Windows_Forever);
        jgame.TryGetValue<Integer>('playtime_mac_forever', aGame.Playtime_Mac_forever);
        jgame.TryGetValue<Integer>('playtime_linux_forever', aGame.Playtime_Linux_Forever);

        Result[I] := aGame;

        Inc(I);
      end;
    end
    else
      raise Exception.Create('[TSteamAPIIPlayerService.GetRecentlyPlayedGames] ' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
end;

function TSteamAPIIPlayerService.GetSteamLevel(const SteamID: UInt64): Integer;
begin
  Result := 0;

  var rest := Self.SetupRestRequest(API_GetSteamLevel);
  try
    rest.AddParameter('steamid', SteamID.ToString);

    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      rest.Response.JSONValue.TryGetValue<Integer>('response.player_level', result);
    end
    else
      raise Exception.Create('[TSteamAPIIPlayerService.GetSteamLevel] ' + rest.Response.StatusText);
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

