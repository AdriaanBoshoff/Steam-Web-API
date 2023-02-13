unit Steam.API;

interface

uses
  Steam.IPlayerService;

type
  TSteamAPI = class
  private
    { Private Variables }
    FToken: string;
  public
   { Public Variables }
    IPlayerService: TSteamAPIIPlayerService;
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
end;

destructor TSteamAPI.Destroy;
begin
  IPlayerService.Destroy;
end;

end.

