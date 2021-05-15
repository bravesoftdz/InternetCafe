unit FormEnterPassWord_U;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TFormEnterPassWord = class(TForm)
    Label1: TLabel;
    EditPassword: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    EditUsername: TEdit;
    labelUsername: TLabel;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    // ������ �� ��� ���� ������
  public
    { Public declarations }
  end;

var
  FormEnterPassWord: TFormEnterPassWord;

implementation

{$R *.dfm}

uses Classes_U, Type_U;

var
  i: Byte = 1;

procedure TFormEnterPassWord.OKBtnClick(Sender: TObject);
resourcestring
  StrMsg1 = '��� ���� ������� ������� �������� ��� ������ ���� ������� �������';
  StrMsg2 = '��� �������� �� ���� ������ ����� ���� �������� ��� �����';
  StrMsg3 = '��� �������� �� ���� ������ ����� �� ����� ������';
begin
  if i < 3 then
  begin
    if TUser.CheckPassword(EditUsername.Text, EditPassword.Text) then
    begin
      if TUser.IsAdministrator(EditUsername.Text) then
      begin
        Administrator := TUser.Create(nil, FormEnterPassWord.EditUsername.Text);
        Administrator.LoadRecord(FormEnterPassWord.EditUsername.Text);
        ModalResult := mrOk
      end
      else
      begin
        MessageBox(Handle, PChar(StrMsg1), PChar(MsgCaptionWarning),
          MB_OK + MB_ICONINFORMATION);
        Close;
      end;
    end
    else
    begin
      MessageBox(Handle, PChar(StrMsg2), PChar(MsgCaptionWarning),
        MB_OK + MB_ICONINFORMATION);
      i := i + 1;
    end;
  end
  else
  begin
    MessageBox(Handle, PChar(StrMsg3), PChar(MsgCaptionWarning),
      MB_OK + MB_ICONINFORMATION);
    Close;
  end;
end;

end.
