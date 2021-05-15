unit Use_Concerted_U;

interface

uses
  Use_Account_U, User_Concerted_U, Post_Client_Concerted_U,
  Type_U, Connexion_Concerted_U;

type
  TUse_Concerted = class(TUse_Account)
  protected
    FStateTime: TStateTime;
    FPost_Client: TPost_Client_Concerted;
    FRecordUse: TRecordUse;
    FPayment: Currency;
    FUser: TUser_Concerted;
    FUnitObjets: TObject;
    FCost: Currency;
    procedure SetStateTime(const Value: TStateTime); virtual;
    procedure SetTimeStart(const Value: TDateTime);
  private
    FTimeUse: TTime;
    FTimeStart: TDateTime;
    FTerminated: Boolean;
    function GetCost: Currency;
    function GetTimeUse: TTime;
    function GetRecordUse: TRecordUse;
    procedure SetRecordUse(const Value: TRecordUse);
    function GetStateTime: TStateTime;
  public
    constructor Create(VUnitObject: TObject); virtual; // CreateUnLock
    procedure Start; virtual; // ������
//    procedure Suspend; virtual; abstract; // ���� ������
    procedure Resume; virtual; abstract; // ������
    procedure StopAndCancel; virtual; abstract; // ����� ������
    procedure Terminate; virtual;  // ����
    property Post_Client
      : TPost_Client_Concerted read FPost_Client write FPost_Client;
    property User: TUser_Concerted read FUser write FUser; { ��� �������� }
    property TimeStart: TDateTime read FTimeStart write SetTimeStart;
    // default Now;{��� ��� ������}
    property TimeUse: TTime read GetTimeUse write FTimeUse; // {����� ��������}
    property Cost: Currency read GetCost write FCost;
    { ���� ��� ������ ��� ���� ����� }
    property Payment: Currency read FPayment write FPayment; { ����� }
    property StateTime: TStateTime read FStateTime write SetStateTime;
    { ������� }
    property RecordUse: TRecordUse read GetRecordUse write SetRecordUse;
    property UnitObjets: TObject read FUnitObjets write FUnitObjets;
    property Terminated: Boolean read FTerminated write FTerminated;
    destructor Destroy; override;
  end;

implementation

uses DateUtils, SysUtils, Classes_U, Round_U;

constructor TUse_Concerted.Create(VUnitObject: TObject);
begin
  inherited Create;
  FUnitObjets := VUnitObject;
  TUnitObjets(FUnitObjets).Use := self;
  FPost_Client := TUnitObjets(VUnitObject).Post_Client;
  FUser := TUnitObjets(VUnitObject).User;
end;

destructor TUse_Concerted.Destroy;
begin
  FreeAndNil(FRound);
  TUnitObjets(FUnitObjets).Use := nil;
  inherited;
end;

procedure TUse_Concerted.Start; // ������
begin
  if FTimeDesired = 0 then
    FStateTime := stTimeUnlimited
  else
    FStateTime := stTimelimited;
end;

procedure TUse_Concerted.Terminate;
begin
  FTerminated := True;
end;

function TUse_Concerted.GetCost: Currency;
begin
  FCost := AccountCost(TimeUse);
  Result := FCost;
end;

function TUse_Concerted.GetTimeUse: TTime;
begin
  FTimeUse := AccountTimeUseWhomTimeFin(Now);
  Result := FTimeUse;
end;

function TUse_Concerted.GetRecordUse: TRecordUse;
begin
  with FRecordUse do
  begin
    PriceHour := FPriceHour; { ��� ������ }
    TimeStart := FTimeStart; // default Now;{��� ��� ������}
    TimeFinVirtual := FTimeFin; // ��� ����� ������
    TimeDesired := FTimeDesired;
    TimeUse := FTimeUse; // {����� ��������}
    CostVirtual := FCostVirtual; { ������ ������� }
    Cost := FCost; { ������ }
    StateTime := FStateTime; { ������� }
  end;
  Result := FRecordUse;
end;

procedure TUse_Concerted.SetRecordUse(const Value: TRecordUse);
begin
  // FRecordUse.Post_Client:= TObject;    ����� �����
  // FRecordUse.User:= TUser;           {��� ��������}
  FPriceHour := Value.PriceHour; { ��� ������ }
  FTimeStart := Value.TimeStart; // default Now;{��� ��� ������}
  FTimeFin := Value.TimeFinVirtual; // ��� ����� ������
  FTimeUse := Value.TimeUse; // {����� ��������}
  FTimeDesired := Value.TimeDesired; // ����� �������
  FCostVirtual := Value.CostVirtual; { ������ ������� }
  FCost := Value.Cost; { ������ }
  FStateTime := Value.StateTime; { ������� }
end;

procedure TUse_Concerted.SetStateTime(const Value: TStateTime);
begin
  FStateTime := Value;
end;

function TUse_Concerted.GetStateTime: TStateTime;
begin

end;

procedure TUse_Concerted.SetTimeStart(const Value: TDateTime);
begin
  FTimeStart := Value;
  SetCostVirtual(FCostVirtual); // �������� ������ ��� ����� ��� �����
end;

end.

