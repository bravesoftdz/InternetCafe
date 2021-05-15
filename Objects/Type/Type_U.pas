unit Type_U;

interface

uses Windows, SysUtils;

type
  TStateTime = (stTimeUnlimited { ��� ��� ����� } , stTimelimited
    { ��� ���� } ); // ���� ������
  TStateLock = (slLock { ���� } , slUnLock { ����� } );
  TStateConnect = (scConnected { ���� } , scDisconnect
    { ������ ����� } , scShuttingDown, scRestarting, scOutsideDomaine
    { ���� ������ } ); // ����� �������

  PRecordUser = ^TRecordUser;

  TRecordUser = packed record
    pseudonyme: string[15]; // ���  ������
    Prename: string[15]; // ��� ��������
    Name: string[15]; // ��� ������
    Sexe: Boolean; // �����
    Password: string[15]; // ���� ������
    N_Carte: Integer; // ��� ����� ������� ������
    Email: string[30]; // ������ ����������
    Adresse: string[250]; // �������
    DateNescience: TDateTime; // ����� �������
    Computation: Currency; // ������ �� �����
    Rate: string[30]; // ����� ������
    Date_Register: TDateTime; // ����� �������
    N_mobile: Integer; // ������ ������
    Niveau_Informatique: string[15]; // ������� �� ������� �����
    Vocation: string[30]; // ������
    Remark: string[250]; // ������ �� ������
    FLogOn: Boolean; // ����� ������
  end;

  TRecordAutorisations = packed record // �������� (���������)
    Registration: Boolean;
  end;

  TRecordUse = packed record
    PriceHour: Currency; { ��� ������ }
    TimeStart: TDateTime; // default Now;{��� ��� ������}
    TimeFin: TDateTime; // ��� ����� ������
    TimeFinVirtual: TDateTime; // ��� ����� ������
    TimeUse: TDateTime; // {����� ��������}
    TimeDesired: TDateTime; // ����� �������
    CostVirtual: Currency; { ������ ������� }
    Cost: Currency; { ������ }
    StateTime: TStateTime; { ������� }
  end;

  TRecordRound = packed record
    UnitRound: Currency; // ���� �������
    ValueNiveauRound: Currency; // ���� ��� �����
  end;

Var
  VRecordRound: TRecordRound;

Type
  TRecordHostInfo = packed record
    HostName: string[63];
    IPAddress: string[15];
    Password_UDP: string[15];
    StateLock: TStateLock;
  end;

var
  LocalHostInfo: TRecordHostInfo;

const
  Unknown = 'Unknown'; // ��� �����
  Undefined = 'undefined';
  Common = 'Common'; // ����� ������ ����

const
  MsgType: Integer = MB_ICONSTOP + MB_DEFBUTTON1 + MB_SYSTEMMODAL + MB_RIGHT +
    MB_RTLREADING;
  MsgCaptionError = '���';
  MsgCaptionWarning = '�����';
  MsgCaptionQustion = '����';

const
  // //Client To Serever
  Cmd_GetPriceHour = $001;
  Cmd_Demand_Use = $002;
  Cmd_UsernameExists = $003;
  Cmd_CheckPassword = $004;
  Cmd_RecordingUser = $005;
  Cmd_Restarting = $006;
  Cmd_ShuttingDown = $007;
  Cmd_IsAdministrator = $0021;

  // // Serever To Client
  Cmd_CreateUser = $008;
  Cmd_Start = $009;
  Cmd_Resume = $010;
  Cmd_DemandUserefusal = 011;
  Cmd_StopAndCancel = $012;
  Cmd_Lock = $013;
  Cmd_Terminate = $014;

  Cmd_RecordingOk = $015;
  Cmd_RecordingCancel = $016;
  Cmd_Restart = $017;
  Cmd_ShutDown = $018;

  Cmd_ChangeUseTo = $019;
  Cmd_ChangeUseFor = $020;

resourcestring
  MsgCaptionRegistryRead = '���  �� ������� ��� ������';
  MsgTextRegistryRead = '��� ��� ������� �� ��� ������';
  MsgNotConnected = '��� ����';
  MsgText1 = '����� ����� ���� ������ ��� ����';
  MsgText2 = '���� ������ �� ��� �� 4 ����';
  MsgText3 = '��� ������  ����� �� 4 �����';
  MsgText4 = '��� ������� �� ��� �� 4 ����';
  MsgText5 = '��� ��������  ����� �� 4 ����';
  MsgText6 = '��� ������ ����� �� 9 �����';
  MsgText7 = '����� ������ ���������� ��� ����';
  MsgText8 = '���� ������ �����' + #13 + '���� :' + #13 + 'mohamed@yahoo.com' +
    #13 + 'ali@hotmail.com';
  MsgText9 = '���� �� ����� ����� �������� ����';

function StrFormatToCurr(Value: string): Currency;
function CurrToStrFormat(Value: Currency): string;

implementation

uses Registry;

function StrFormatToCurr(Value: string): Currency;
var
  i: Integer;
  R: string;
begin
  for i := 1 to Length(Value) do
    if (Value[i] in ['0' .. '9']) or ((Value[i] = '.') and (Pos('.', R) = 0))
      then
    begin
      R := R + Value[i]
    end;
  if R <> '' then
    Result := StrToCurr(R)
  else
    Result := 0;
end;

function CurrToStrFormat(Value: Currency): string;
begin
  Result := CurrToStrF(Value,
    { ffCurrency } ffNumber, CurrencyDecimals) + ' ' + CurrencyString;
end;

initialization

with TRegistry.Create do
begin
  try
    RootKey := HKEY_CURRENT_USER;
    if KeyExists('Software\DJ_group\MyCafe\Round') then
    begin
      OpenKey('Software\DJ_group\MyCafe\Round', False);
      VRecordRound.UnitRound := ReadCurrency('UnitRound'); // ���� �������
      VRecordRound.ValueNiveauRound := ReadCurrency('NiveauRound');
      // ���� ��� �����
      CloseKey;
    end;
    Free;
  except
    VRecordRound.UnitRound := 0; // ���� �������
    VRecordRound.ValueNiveauRound := 0; // ���� ��� �����
    // MessageBox(0, PChar(MsgTextRegistryRead), PChar(MsgCaptionRegistryRead), $180000);
    Free;
  end;
end;

end.
