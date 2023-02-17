unit Steam.ISteamUser;

interface

uses
  Rest.Client, Rest.Types, System.JSON, System.Classes, System.SysUtils,
  Steam.ISteamUser.Types;

type
  TSteamAPIISteamUser = class
  private
    { Private Const }
    const
      API_URL = 'https://api.steampowered.com/ISteamUser/';
      API_GetPlayerBans = 'GetPlayerBans';
  private
    { Private Variables }
    FToken: string;
  private
    { Private Methods }
    function SetupRestRequest(const API_PATH: string; const APIVersion: string = '1'): TRESTRequest;
  public
    { Public Methods }
    function GetPlayerBans(const SteamIDs: string): TArray<TISteamUser_PlayerBan>;
    /////////////////////////////////////////////
    constructor Create(const API_Key: string);
    destructor Destroy;
  end;

implementation

{ TSteamAPIISteamUser }

constructor TSteamAPIISteamUser.Create(const API_Key: string);
begin
  Self.FToken := API_Key;
end;

destructor TSteamAPIISteamUser.Destroy;
begin
  //
end;

function TSteamAPIISteamUser.GetPlayerBans(const SteamIDs: string): TArray<TISteamUser_PlayerBan>;
begin
  var rest := SetupRestRequest(API_GetPlayerBans);
  try
    rest.AddParameter('steamids', SteamIDs);
    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      SetLength(Result, (rest.Response.JSONValue.FindValue('players') as TJSONArray).Count);

      var I := 0;
      for var jPlayer in (rest.Response.JSONValue.FindValue('players') as TJSONArray) do
      begin
        var aPlayer: TISteamUser_PlayerBan;
        jPlayer.TryGetValue<string>('SteamId', aPlayer.SteamID);
        jPlayer.TryGetValue<Boolean>('CommunityBanned', aPlayer.CommunityBanned);
        jPlayer.TryGetValue<Boolean>('VACBanned', aPlayer.VACBanned);
        jPlayer.TryGetValue<Integer>('NumberOfVACBans', aPlayer.NumberOfVACBans);
        jPlayer.TryGetValue<Integer>('DaysSinceLastBan', aPlayer.DaysSinceLastBan);
        jPlayer.TryGetValue<Integer>('NumberOfGameBans', aPlayer.NumberOfGameBans);
        jPlayer.TryGetValue<string>('EconomyBan', aPlayer.EconomyBan);

        Result[I] := aPlayer;

        Inc(I);
      end;
    end
    else
      raise Exception.Create('[TSteamAPIISteamUser.GetPlayerBans] ' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
end;

function TSteamAPIISteamUser.SetupRestRequest(const API_PATH: string; const APIVersion: string): TRESTRequest;
begin
  Result := TRESTRequest.Create(nil);
  Result.Response := TRESTResponse.Create(Result);
  Result.Client := TRESTClient.Create(Result);
  Result.Client.BaseURL := API_URL + API_PATH + '/v' + APIVersion + '/';
  Result.AddParameter('key', Self.FToken);
end;

end.

