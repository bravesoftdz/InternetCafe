unit Round_U;

interface

uses
  Windows, Forms, Type_U;

type
  TRound = class(TObject) // ���� �������
  private
    FUnitRound: Currency;
    FValueNiveauRound: Currency;
    FValue: Currency;
    FValueRound: Currency;
    FPercentageNiveauRound: Single;

    procedure SetValueNiveauRound(const Value: Currency);
    procedure SetUnitRound(const Value: Currency);
    procedure SetPercentageNiveauRound(const Value: Single);
    function GetValueRound: Currency;
  public
    function Round(Value: Currency): Currency; // ����� ������
    property Value: Currency read FValue write FValue; // ������
    property ValueRound: Currency read GetValueRound; // ������ ������
    property UnitRound: Currency read FUnitRound write SetUnitRound;
    // ���� �������
    property ValueNiveauRound: Currency read FValueNiveauRound write
      SetValueNiveauRound; // ���� ��� �����
    property PercentageNiveauRound: Single read FPercentageNiveauRound write
      SetPercentageNiveauRound; // ���� ��� �����
  end;

implementation

uses SysUtils, Math;

{ TRoundPrice }

function TRound.Round(Value: Currency): Currency;
var
  FCostInt, FValueRoundInt, FValueNiveauRoundInt, FRemainderInt: int64;
  FFractional: Byte; // �� ��� ������� ������� �������� ��� ����� ����� ��� ������ �� 10

  procedure CurrToInt; // ����� �� ������ �� ��� ����� ��� ��� ����

    function FractionalMax: Byte; // ����� ����� ��� �������

      function FractionalNumber(Value: Currency): Byte; // function FractionalNumber(Value: Currency): Byte; // ��� ������� ��� ������
      var
        i: Byte;
        ValueStr: string;
      begin
        Result := 0;
        ValueStr := CurrToStr(Value);
        for i := 1 to Length(ValueStr) do
        begin
          if ValueStr[i] = '.' then
          begin
            Result := Length(ValueStr) - i + 1;
          end;
        end;
      end;

    begin
      if FractionalNumber(FValue) <= FractionalNumber(FUnitRound) then
      begin
        Result := FractionalNumber(FValue);
      end
      else
      begin
        FractionalMax := FractionalNumber(FUnitRound);
      end;
      if Result < FractionalNumber(FValueNiveauRound) then
      begin
        Result := FractionalNumber(FValueNiveauRound);
      end;
    end;

  var
    i: Byte;
  begin
    FFractional := 1;
    for i := 1 to FractionalMax do
    begin
      FFractional := FFractional * 10;
    end;
    FCostInt := System.Round(FValue * FFractional);
    FValueRoundInt := System.Round(FUnitRound * FFractional);
    FValueNiveauRoundInt := System.Round(FValueNiveauRound * FFractional);
  end;

begin
  FValue := Value;
  CurrToInt;
  FRemainderInt := (FCostInt mod FValueRoundInt);

  if FCostInt >= 0 then
  begin
    if FRemainderInt < FValueNiveauRoundInt then
    begin
      FValueRound := (FCostInt - FRemainderInt) / FFractional;
    end
    else
    begin
      FValueRound := (FCostInt + (FValueRoundInt - FRemainderInt))
        / FFractional;
    end;
  end
  else
  begin
    if FRemainderInt >= -FValueNiveauRoundInt then
    begin
      FValueRound := (FCostInt - FRemainderInt) / FFractional;
    end
    else
    begin
      FValueRound := (FCostInt - (FValueRoundInt + FRemainderInt))
        / FFractional;
    end;
  end;
  Result := FValueRound;
end;

procedure TRound.SetValueNiveauRound(const Value: Currency);
resourcestring
  MsgCaption1 = '���� ����� �������';
  MsgText1 = '�� ���� �� ���� ���� ����� �������  ���� �� ���� �������';
  MsgCaption2 = '���� �����';
  MsgText2 = '�� ���� �� ���� ���� ����� �������  �����';
begin
  if (Value > FUnitRound) then
  begin
    MessageBox(Application.Handle, PChar(MsgText1), PChar(MsgCaption1),
      $180000);
    Exit;
  end;
  if (Value < 0) then
  begin
    MessageBox(Application.Handle, PChar(MsgText2), PChar(MsgCaption2),
      $180000);
    Exit;
  end;
  FValueNiveauRound := Value;
  FPercentageNiveauRound := RoundTo((FValueNiveauRound * 100) / FUnitRound, -2);
end;

procedure TRound.SetUnitRound(const Value: Currency);
resourcestring
  MsgCaption3 = '���� �����';
  MsgText3 = '�� ���� �� ���� ����  �������  �����';
begin
  if (Value < 0) then
  begin
    MessageBox(Application.Handle, PChar(MsgText3), PChar(MsgCaption3),
      $180000);
    Exit;
  end;

  FUnitRound := Value;
  FValueNiveauRound := (FUnitRound * FPercentageNiveauRound) / 100;
end;

procedure TRound.SetPercentageNiveauRound(const Value: Single);
resourcestring
  MsgCaption4 = '���� ����� �������';
  MsgText4 = '���� ����� ������� ������ ��� 0 .. 100';
begin
  if (Value > 100) or (Value < 0) then
  begin
    MessageBox(Application.Handle, PChar(MsgText4), PChar(MsgCaption4),
      $180000);
    Exit;
  end;
  FPercentageNiveauRound := Value;
  FValueNiveauRound := RoundTo((FUnitRound * FPercentageNiveauRound) / 100, -2);
end;

function TRound.GetValueRound: Currency;
begin
  Result := Round(FValue);
end;

end.
