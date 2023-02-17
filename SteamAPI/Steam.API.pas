unit Steam.API;

interface

uses
  Steam.IPlayerService, Steam.ISteamUser;

type
  TSteamAPI = class
  private
    { Private Variables }
    FToken: string;
  public
   { Public Variables }
    IPlayerService: TSteamAPIIPlayerService;
    ISteamUser: TSteamAPIISteamUser;
  public
   { Public Methods }
    constructor Create(const API_Key: string);
    destructor Destroy;
  end;

implementation

{ TSteamAPI }

constructor TSteamAPI.Create(const API_Key: string);
begin
  Self.FToken := API_Key;

  IPlayerService := TSteamAPIIPlayerService.Create(Self.FToken);
  ISteamUser := TSteamAPIISteamUser.Create(Self.FToken);
end;

destructor TSteamAPI.Destroy;
begin
  ISteamUser.Destroy;
  IPlayerService.Destroy;
end;

end.

