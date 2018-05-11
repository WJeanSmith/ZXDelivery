{*******************************************************************************
  ����: dmzn@163.com 2018-05-07
  ����: ���복����ѯ
*******************************************************************************}
unit UFrameCusInOutMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, System.IniFiles,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, UFrameBase, Data.DB, Datasnap.DBClient,
  uniSplitter, uniBasicGrid, uniDBGrid, uniPanel, uniToolBar, uniGUIBaseClasses,
  uniEdit, uniLabel, Vcl.Menus, uniMainMenu, uniButton, uniBitBtn;

type
  TfFrameCusInOutMoney = class(TfFrameBase)
    Label2: TUniLabel;
    EditCustomer: TUniEdit;
    Label3: TUniLabel;
    EditDate: TUniEdit;
    BtnDateFilter: TUniBitBtn;
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
    procedure BtnDateFilterClick(Sender: TObject);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    {*ʱ������*}
    procedure OnDateFilter(const nStart,nEnd: TDate);
    //����ɸѡ
  public
    { Public declarations }
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnDestroyFrame(const nIni: TIniFile); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //�������
  end;

implementation

{$R *.dfm}
uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, UManagerGroup,
  USysBusiness, USysDB, USysConst, UFormDateFilter;

procedure TfFrameCusInOutMoney.OnCreateFrame(const nIni: TIniFile);
begin
  inherited;
  InitDateRange(ClassName, FStart, FEnd);
end;

procedure TfFrameCusInOutMoney.OnDestroyFrame(const nIni: TIniFile);
begin
  SaveDateRange(ClassName, FStart, FEnd);
  inherited;
end;

procedure TfFrameCusInOutMoney.OnDateFilter(const nStart,nEnd: TDate);
begin
  FStart := nStart;
  FEnd := nEnd;
  InitFormData(FWhere);
end;

function TfFrameCusInOutMoney.InitFormDataSQL(const nWhere: string): string;
begin
  with TStringHelper, TDateTimeHelper do
  begin
    EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

    Result := 'Select iom.*,S_Name From $IOM iom ' +
              ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ';
    //xxxxx

    if nWhere = '' then
         Result := Result + 'Where (M_Date>=''$Start'' And M_Date<''$End'')'
    else Result := Result + 'Where (' + nWhere + ')';

    Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
              MI('$IOM', sTable_InOutMoney),
              MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
    //xxxxx
  end;
end;

//Desc: ����ɸѡ
procedure TfFrameCusInOutMoney.BtnDateFilterClick(Sender: TObject);
begin
  ShowDateFilterForm(FStart, FEnd, OnDateFilter);
end;

procedure TfFrameCusInOutMoney.EditTruckKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  Key := #0;

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  RegisterClass(TfFrameCusInOutMoney);
end.