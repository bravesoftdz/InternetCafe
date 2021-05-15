unit Use_Account_U;

interface

uses Round_U, Windows;

type
  TUse_Account = class(TObject)
  private
    procedure SetTimeFin(const Value: TDateTime);

  protected
    FTimeDesired: TTime; // ����� �������
    FTimeStart: TDateTime;
    FTimeFin: TDateTime;
    FCostVirtual: Currency;
    FPriceHour: Currency;
    procedure SetTimeDesired(const Value: TTime);
    procedure SetCostVirtual(const Value: Currency);
    function AccountTimeUseWhomCost: TTime; // ���� ��� ������ �� ������
    function AccountTimeUseWhomTimeFin(TimeFin: TDateTime): TDateTime;
    // ���� ��� ������ �� ��� ������ ������
    function AccountTimeFin: TDateTime; // ���� ��� ������ ������
    function AccountCost(TimeUtilize: TDateTime): Currency; // ���� ������
  public
    FRound: TRound;
    constructor Create;
    property TimeFin: TDateTime read FTimeFin write
      SetTimeFin; // ��� �������� �������
    property TimeDesired: TTime read FTimeDesired write SetTimeDesired;
    // ����� �������
    property PriceHour: Currency read FPriceHour write FPriceHour;
    { ��� ������ }
    property CostVirtual: Currency read FCostVirtual write SetCostVirtual;
    { ������ ������� }
  end;

implementation

uses DateUtils, SysUtils, Classes_U;

function TUse_Account.AccountCost(TimeUtilize: TDateTime): Currency;
// ���� ������
begin
  Result := (FPriceHour * MinuteOfTheDay(TimeUtilize)) / 60;
  if FRound <> nil then
    Result := FRound.Round(Result)
end;

function TUse_Account.AccountTimeFin: TDateTime; // ���� ��� ������ ������
begin
  Result := FTimeStart + FTimeDesired;
end;

function TUse_Account.AccountTimeUseWhomCost: TTime;
// ���� ��� ������ �� ������
var
  Hour: Integer;
  TimeUtilizeOfMinute: Integer;
begin
  if FPriceHour <> 0 then
  begin
    TimeUtilizeOfMinute := System.Round((60 * FCostVirtual) / FPriceHour);
    Hour := TimeUtilizeOfMinute div 60;
    if Hour <> 0 then
    begin
      Result := StrToTime(IntToStr(Hour) + ':' + IntToStr
          (TimeUtilizeOfMinute - (Hour * 60)) + ':' + '00');
    end
    else
    begin
      Result := StrToTime('00' + ':' + IntToStr(TimeUtilizeOfMinute)
          + ':' + '00');
    end;
  end
  else
  begin
    Result := StrToTime('00' + ':' + '00' + ':' + '00');
  end;

end;

function TUse_Account.AccountTimeUseWhomTimeFin(TimeFin: TDateTime): TDateTime;
// ���� ��� ������ �� ��� ������ ������
begin
  Result := TimeFin - FTimeStart; // + StrToTime('00:01:00');
end;

procedure TUse_Account.SetTimeFin(const Value: TDateTime);
begin
  if FTimeFin = Value then
    Exit;
  FTimeFin := Value;
  FTimeDesired := AccountTimeUseWhomTimeFin(FTimeFin);
  FCostVirtual := AccountCost(FTimeDesired);
end;

procedure TUse_Account.SetCostVirtual(const Value: Currency);
begin
  if FCostVirtual = Value then
    Exit;
  FCostVirtual := Value;
  FTimeDesired := AccountTimeUseWhomCost;
  FTimeFin := AccountTimeFin;
end;

procedure TUse_Account.SetTimeDesired(const Value: TTime);
begin
  if FTimeDesired = Value then
    Exit;
  FTimeDesired := Value;
  FCostVirtual := AccountCost(FTimeDesired);
  FTimeFin := AccountTimeFin;
end;

constructor TUse_Account.Create;
begin
  FTimeStart := Now;
end;

end.
