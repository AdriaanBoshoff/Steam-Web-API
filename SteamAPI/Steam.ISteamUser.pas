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
      API_GetFriendList = 'GetFriendList';
      API_GetPlayerSummaries = 'GetPlayerSummaries';
  private
    { Private Variables }
    FToken: string;
  private
    { Private Methods }
    function SetupRestRequest(const API_PATH: string; const APIVersion: string = '1'): TRESTRequest;
  public
    { Public Methods }
    function GetPlayerBans(const SteamIDs: string): TArray<TISteamUser_PlayerBan>;
    function GetFriendsList(const SteamID: UInt64): TArray<TISteamUser_FriendList>;
    function GetPlayerSummariesV2(const SteamIDs: string): TArray<TISteamUser_PlayerSummary>;
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
  inherited;
end;

function TSteamAPIISteamUser.GetFriendsList(const SteamID: UInt64): TArray<TISteamUser_FriendList>;
begin
  var rest := SetupRestRequest(API_GetFriendList);
  try
    rest.AddParameter('steamid', SteamID.ToString);
    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      SetLength(Result, (rest.Response.JSONValue.FindValue('friendslist.friends') as TJSONArray).Count);

      var I := 0;
      for var jFriend in (rest.Response.JSONValue.FindValue('friendslist.friends') as TJSONArray) do
      begin
        var aFriend: TISteamUser_FriendList;
        jFriend.TryGetValue<string>('steamid', aFriend.SteamID);
        jFriend.TryGetValue<string>('relationship', aFriend.Relationship);
        jFriend.TryGetValue<Int64>('friend_since', aFriend.Friend_Since);

        Result[I] := aFriend;

        Inc(I);
      end;
    end
    else
      raise Exception.Create('[TSteamAPIISteamUser.GetFriendsList] ' + rest.Response.StatusText);
  finally
    rest.Free;
  end;
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

function TSteamAPIISteamUser.GetPlayerSummariesV2(const SteamIDs: string): TArray<TISteamUser_PlayerSummary>;
begin
  var rest := SetupRestRequest(API_GetPlayerSummaries, '2');
  try
    rest.AddParameter('steamids', SteamIDs);
    rest.Method := TRESTRequestMethod.rmGET;
    rest.Execute;

    if rest.Response.StatusCode = 200 then
    begin
      SetLength(Result, (rest.Response.JSONValue.FindValue('response.players') as TJSONArray).Count);

      var I := 0;
      for var jPlayer in (rest.Response.JSONValue.FindValue('response.players') as TJSONArray) do
      begin
        var aPlayer: TISteamUser_PlayerSummary;
        jPlayer.TryGetValue<string>('steamid', aPlayer.SteamID);
        jPlayer.TryGetValue<Integer>('communityvisibilitystate', aPlayer.CommunityVisibilityState);
        jPlayer.TryGetValue<Integer>('profilestate', aPlayer.ProfileState);
        jPlayer.TryGetValue<string>('personaname', aPlayer.PersonaName);
        jPlayer.TryGetValue<Integer>('commentpermission', aPlayer.CommentPermission);
        jPlayer.TryGetValue<string>('profileurl', aPlayer.ProfileURL);
        jPlayer.TryGetValue<string>('avatar', aPlayer.AvatarURL);
        jPlayer.TryGetValue<string>('avatarmedium', aPlayer.AvatarMediumURL);
        jPlayer.TryGetValue<string>('avatarfull', aPlayer.AvatarFullURL);
        jPlayer.TryGetValue<string>('avatarhash', aPlayer.AvatarHash);
        jPlayer.TryGetValue<Int64>('lastlogoff', aPlayer.LastLogOff);
        jPlayer.TryGetValue<Integer>('personastate', aPlayer.PersonaState);
        jPlayer.TryGetValue<string>('primaryclanid', aPlayer.PrimaryClanID);
        jPlayer.TryGetValue<Int64>('timecreated', aPlayer.TimeCreated);
        jPlayer.TryGetValue<Integer>('personastateflags', aPlayer.PersonaStateFlags);
        jPlayer.TryGetValue<string>('gameserverip', aPlayer.GameServerIP);
        jPlayer.TryGetValue<string>('gameserversteamid', aPlayer.GameServerSteamID);
        jPlayer.TryGetValue<string>('gameextrainfo', aPlayer.GameExtraInfo);
        jPlayer.TryGetValue<string>('gameid', aPlayer.GameID);
        jPlayer.TryGetValue<string>('loccountrycode', aPlayer.LocCountryCode);
        jPlayer.TryGetValue<string>('locstatecode', aPlayer.LocStateCode);
        jPlayer.TryGetValue<string>('loccityid', aPlayer.LocCityID);

        Result[I] := aPlayer;

        Inc(I);
      end;
    end
    else
      raise Exception.Create('[TSteamAPIISteamUser.GetPlayerSummaries] ' + rest.Response.StatusText);
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

