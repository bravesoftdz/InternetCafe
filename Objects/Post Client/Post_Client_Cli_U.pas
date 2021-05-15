unit Post_Client_Cli_U;

interface

uses Forms, IdTCPClient, Classes, SysUtils, IdTCPServer, Windows, Dialogs,
  Post_Client_Concerted_U, IdSchedulerOfThread, IdStack;

type
  TPost_Client_Cli = class(TPost_Client_Concerted)
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    { Find }
    { M�thod }
    constructor Create; // override;
    procedure UnLock; override;
    procedure Lock; override;
    procedure ShutDown; override;
    procedure Restart; override;
    destructor Destroy; override;
    { property }
    { Ev�nements }
  end;

implementation

uses Connexion_Module_U, Form_Main_U, Form_Lock_U,
  IdTCPConnection, DateUtils, Miscellany_U,
  Type_U, Classes_U;

{ TPostClient }

// *************** ������� ******************

procedure TPost_Client_Cli.Lock;
begin
  inherited Lock;
  TForm_Lock.Lock_Windows;
end;

procedure TPost_Client_Cli.UnLock;
begin
  inherited UnLock;
  if Assigned(Form_Lock) then
    Form_Lock.UnLock_Windows;
end;

procedure TPost_Client_Cli.Restart;
resourcestring
  MsgText = '��� ��� ������ ����� �������';
begin
  // inherited;
  if ExitWindows(EWX_REBOOT, 0) then
  begin
    // �������� ����� (������ ������� UDP)
    begin
      try
        with TUnitObjets(FUnitObjets).Connexion, IdTCPClient.IOHandler do
        begin
          if IdTCPClient.Connected then
            Write(Cmd_Restarting)
          else
            MessageBox(Application.Handle, PChar(MsgNotConnected), PChar
                (MsgCaptionError), MsgType);
        end;

      except
        on E: Exception do
        begin
          MessageBox(Application.Handle, PChar(MsgText + #13 + E.Message), PChar
              (MsgCaptionError), MsgType)
        end;
      end;
    end;
  end;
end;

procedure TPost_Client_Cli.ShutDown;
resourcestring
  MsgText = '��� ��� ������ ���� �������';
begin
  // inherited;
  if _ExitWindows(EWX_POWEROFF or EWX_FORCE) then
  begin
    // �������� ����� (������ ������� UDP)
    try
      with TUnitObjets(FUnitObjets).Connexion, IdTCPClient.IOHandler do
      begin
        if IdTCPClient.Connected then
          Write(Cmd_ShuttingDown)
        else
          MessageBox(Application.Handle, PChar(MsgNotConnected), PChar
              (MsgCaptionError), MsgType);
      end;
    except
      on E: Exception do
      begin
        MessageBox(Application.Handle, PChar(MsgText + #13 + E.Message), PChar
            (MsgCaptionError), MsgType)
      end;
    end;
  end;
end;

destructor TPost_Client_Cli.Destroy;
begin
  // TUnitObjets(FUnitObjets).Connexion.IdTCPClient.Free;
  inherited;
end;

constructor TPost_Client_Cli.Create;
begin
  inherited;
  FHostName := GStack.HostName;
  FIPAddress := GStack.LocalAddress
end;

end.
