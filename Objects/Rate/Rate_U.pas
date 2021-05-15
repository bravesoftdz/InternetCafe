unit Rate_U;

interface

type
  TRate = class(TObject) // ��� �������� (����� ������� �� ��� �������)
  private
    FNameRate: String;
    FPriceHour: Currency;
  protected

  public
    property NameRate: String read FNameRate write FNameRate; // ������
    property PriceHour: Currency read FPriceHour write FPriceHour; // ������
  end;

implementation

{ TRate }

end.
