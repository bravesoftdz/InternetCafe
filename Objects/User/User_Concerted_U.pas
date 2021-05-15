unit User_Concerted_U;

interface

uses Type_U, Connexion_Concerted_U;

type
  TAutorisations = class(TObject) // �������� (���������)
  private
    FRegistration: Boolean;
    FRecordAutorisations :TRecordAutorisations;
    function GetRecordAutorisations: TRecordAutorisations;
    procedure SetRecordAutorisations(const Value: TRecordAutorisations);
  public
    property Registration: Boolean read FRegistration write FRegistration;
    property RecordAutorisations: TRecordAutorisations read GetRecordAutorisations write SetRecordAutorisations; //
  end;

  TUser_Concerted = class(TObject)
  private
    function GetRecordUser: TRecordUser;
    procedure SetRecordUser(const Value: TRecordUser);
  protected
    FComputation: Currency;
    FN_Carte: Integer;
    FPassword: String;
    FVocation: String;
    FPseudonyme: String;
    FPrename: String;
    FNiveau_didacticism: String;
    FAdresse: String;
    FSexe: Boolean;
    FEmail: String;
    FNiveau_Informatique: String;
    FName: String;
    FRemark: String;
    FDate_Register: TDateTime;
    FDateNescience: TDateTime;
    FRecordUser: TRecordUser;
    FRate: String;
    FN_mobile: Integer;
    FLogOn: Boolean; // ����� ������
    FAutorisations: TAutorisations; // ���������
    FUnitObjets: TObject;
    procedure Setpseudonyme(const Value: String); virtual;
  public
    constructor Create(VUnitObjects: TObject; VPseudonyme: string = '');
      virtual;
    class function Recording(VRUser: TRecordUser; VConnexion: TObject)
      : Boolean; virtual; abstract; // ����� (����� ���� ����)
    class function UsernameExists(VUsername: string) : Boolean; virtual; abstract; // ������ �� ���� ��� ��������
    class function CheckPassword(VUsername: string; VPassword: string): Boolean; virtual; abstract;
    // ������ �� ��� ���� ������
    function IsAdministrator: Boolean;overload; virtual;
    class function IsAdministrator(VUsername: string): Boolean;overload; virtual; abstract;
    class procedure Demand_Use(VUsername: string; TimeDesired: TTime;
      VUnitObjets: TObject); virtual; abstract; // ���  �������
    property Pseudonyme: String read Fpseudonyme write Setpseudonyme;
    // ��� ������
    property Prename: String read FPrename write FPrename; // �����
    property Name: String read FName write FName; // ��� ������
    property Password: String read FPassword write FPassword; // ��� ������
    property Rate: String read FRate write FRate;
    // ��� �������� (����� ������� �� ��� �������)
    property Sexe: Boolean read FSexe write FSexe; // �����
    property N_Carte: Integer read FN_Carte write FN_Carte;
    // ��� ����� ������� ������
    property Email: String read FEmail write FEmail; // ������ ����������
    property Adresse: String read FAdresse write FAdresse; // �������
    property N_mobile: Integer read FN_mobile write FN_mobile; // �������
    property DateNescience: TDateTime read FDateNescience write FDateNescience;
    // ����� �������
    property Computation: Currency read FComputation write FComputation;
    // ������ �� �����
    property Date_Register: TDateTime read FDate_Register write FDate_Register;
    // ����� �������
    property Niveau_Informatique: String read FNiveau_Informatique write
      FNiveau_Informatique; // ������� �� ������� �����
    property Niveau_didacticism
      : String read FNiveau_didacticism write FNiveau_didacticism;
    // ������� �� ������� �����
    property Vocation: String read FVocation write FVocation; // ������
    property Remark: String read FRemark write FRemark; // ������ �� ������
    property LogOn: Boolean read FLogOn write FLogOn; // ������ �� ������
    property Autorisations
      : TAutorisations read FAutorisations write FAutorisations;
    property RecordUser: TRecordUser read GetRecordUser write SetRecordUser; //
    property UnitObjets: TObject read FUnitObjets write FUnitObjets;
    destructor Destroy; override;
  end;

implementation

uses Classes_U;

{ TUser }

constructor TUser_Concerted.Create(VUnitObjects: TObject;
  VPseudonyme: string = '');
begin
  FPseudonyme := VPseudonyme;
  if Assigned(VUnitObjects) then
  begin
    FUnitObjets := VUnitObjects;
    TUnitObjets(FUnitObjets).User := self;
  end;
end;

destructor TUser_Concerted.Destroy;
begin
  TUnitObjets(FUnitObjets).User := nil;
  FAutorisations.Free;
  inherited;
end;

function TUser_Concerted.GetRecordUser: TRecordUser;
begin
  with FRecordUser do
  begin
    Pseudonyme := Fpseudonyme; // ���  ������
    Prename := FPrename; // ��� ��������
    Name := FName; // ��� ������
    Sexe := FSexe; // �����
    Password := FPassword; // ���� ������
    N_Carte := FN_Carte; // ��� ����� ������� ������
    Email := FEmail; // ������ ����������
    Adresse := FAdresse; // �������
    DateNescience := FDateNescience; // ����� �������
    Computation := FComputation; // ������ �� �����
    Rate := FRate; // ����� ������
    Date_Register := FDate_Register; // ����� �������
    N_mobile := FN_mobile; // ������ ������
    Niveau_Informatique := FNiveau_Informatique; // ������� �� ������� �����
    Niveau_didacticism := FNiveau_didacticism; // //  ������� �� ������� �����
    Vocation := FVocation; // ; //   ������
    Remark := FRemark; // ������ �� ������
    LogOn := FLogOn; // ����� ������
  end;
  Result := FRecordUser;
end;

function TUser_Concerted.IsAdministrator: Boolean;
begin
  if Assigned(FAutorisations) then
    Result := True
  else
    Result := False;
end;

procedure TUser_Concerted.Setpseudonyme(const Value: String);
begin
  if Fpseudonyme = Value then
    Exit;
  Fpseudonyme := Value;
end;

procedure TUser_Concerted.SetRecordUser(const Value: TRecordUser);
begin
  Fpseudonyme := Value.Pseudonyme; // ���  ������
  FPrename := Value.Prename; // ��� ��������
  FName := Value.Name; // ��� ������
  FSexe := Value.Sexe; // �����
  FPassword := Value.Password; // ���� ������
  FN_Carte := Value.N_Carte; // ��� ����� ������� ������
  FEmail := Value.Email; // ������ ����������
  FAdresse := Value.Adresse; // �������
  FDateNescience := Value.DateNescience; // ����� �������
  FComputation := Value.Computation; // ������ �� �����
  FRate := Value.Rate; // ����� ������
  FDate_Register := Value.Date_Register; // ����� �������
  FN_mobile := Value.N_mobile; // ������ ������
  FNiveau_Informatique := Value.Niveau_Informatique; // ������� �� ������� �����
  FVocation := Value.Vocation; // ; //   ������
  FRemark := Value.Remark; // ������ �� ������
  FLogOn := Value.FLogOn;
  /// / ����� ������
end;

{ TAutorisations }

function TAutorisations.GetRecordAutorisations: TRecordAutorisations;
begin
  with FRecordAutorisations do
  begin
    Registration := FRegistration;

  end;
  Result := FRecordAutorisations;
end;

procedure TAutorisations.SetRecordAutorisations(
  const Value: TRecordAutorisations);
begin
  FRegistration := Value.Registration; // ���  ������
end;

end.
