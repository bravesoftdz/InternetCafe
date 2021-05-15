unit SearchConnections_U;

interface

uses Classes_U,Forms,
  Classes {$IFDEF MSWINDOWS}, Windows {$ENDIF}, IdTCPClient, IdTCPServer,
  IdGlobal;

type
  TSearchConnections = class(TThread) // �� ��� ��������� �� ������ ������� ��� ���� �� ���
  private
    FUnitObjets: TUnitObjets;
    procedure SetName;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; VUnitObjets: TUnitObjets);
  end;

implementation

uses Type_U;

{ Important : les m�thodes et propri�t�s des objets de la VCL peuvent uniquement �tre
  utilis�s dans une m�thode appel�e en utilisant Synchronize, comme :

  Synchronize(UpdateCaption);

  o� UpdateCaption serait de la forme

  procedure TConectThead.UpdateCaption;
  begin
  Form1.Caption := 'Mis � jour dans un thread';
  end; }
{$IFDEF MSWINDOWS}

type
  TThreadNameInfo = record
    FType: LongWord; // doit �tre 0x1000
    FName: PChar; // pointeur sur le nom (dans l'espace d'adresse de l'utilisateur)
    FThreadID: LongWord; // ID de thread (-1=thread de l'appelant)
    FFlags: LongWord; // r�serv� pour une future utilisation, doit �tre z�ro
  end;
{$ENDIF}
  { TConectThead }

procedure TSearchConnections.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'SearchConnections';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException($406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord),
      @ThreadNameInfo);
  except
  end;
{$ENDIF}
end;

constructor TSearchConnections.Create(CreateSuspended: Boolean;
  VUnitObjets: TUnitObjets);
begin
  inherited Create(CreateSuspended);
  FUnitObjets := VUnitObjets;
end;

procedure TSearchConnections.Execute;
var
  B: TIdBytes;
var
  ServerName: String;
begin
  SetName;
  { Placer le code du thread ici }
  while not FUnitObjets.Connexion.IdTCPClient.Connected and not Application.Terminated do
  begin
    try
      LocalHostInfo.StateLock:=UnitObjets_Active.Post_Client.StateLock;
      B := RawToBytes(LocalHostInfo, sizeof(LocalHostInfo));
      FUnitObjets.Connexion.IdUDPClient.SendBuffer(B);
      repeat
        ServerName := '';
        ServerName := FUnitObjets.Connexion.IdUDPClient.ReceiveString;
        if (ServerName <> 'Password_UDP_Valid') And (ServerName <> '') then
        begin
          FUnitObjets.Post_Client.HostName := ServerName;
          FUnitObjets.Connexion.Connect;
        end;
      until ServerName = '';
    except
    end;
    Sleep(1000);
  end;
end;

end.
