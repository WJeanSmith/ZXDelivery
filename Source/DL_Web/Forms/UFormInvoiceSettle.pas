{*******************************************************************************
  作者: dmzn@163.com 2018-05-20
  描述: 销售结算
*******************************************************************************}
unit UFormInvoiceSettle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, uniGUITypes,
  uniGUIForm, USysConst, UFormBase, uniMemo, uniGUIClasses, uniEdit, uniLabel,
  uniPanel, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, uniButton;

type
  TfFormInvoiceSettle = class(TfFormBase)
    UniLabel1: TUniLabel;
    EditWeek: TUniEdit;
    UniLabel2: TUniLabel;
    EditMemo: TUniMemo;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FNowYear,FNowWeek,FWeekName: string;
    //当前周期
    FWeekBegin,FWeekEnd: TDateTime;
    //周期区间
    procedure InitFormData;
    //初始化
    procedure ShowHintText(const nText: string);
    //提示内容
  public
    { Public declarations }
  end;

procedure ShowInvoiceSettleForm(const nYear,nWeek,nWeekName: string;
  const nBegin,nEnd: TDateTime; const nResult: TFormModalResult);
//入口函数

implementation

{$R *.dfm}

uses
  Data.Win.ADODB, uniGUIVars, MainModule, uniGUIApplication, UManagerGroup,
  ULibFun, USysBusiness, USysDB;

//Date: 2018-05-20
//Parm: 年;周期,名称
//Desc: 显示销售结算窗口
procedure ShowInvoiceSettleForm(const nYear,nWeek,nWeekName: string;
  const nBegin,nEnd: TDateTime; const nResult: TFormModalResult);
var nForm: TUniForm;
begin
  nForm := SystemGetForm('TfFormInvoiceSettle', True);
  if not Assigned(nForm) then Exit;

  with nForm as TfFormInvoiceSettle do
  begin
    FNowYear := nYear;
    FNowWeek := nWeek;
    FWeekName := nWeekName;

    FWeekBegin := nBegin;
    FWeekEnd := nEnd;
    InitFormData; //init
    
    ShowModal(
      procedure(Sender: TComponent; Result:Integer)
      begin
        if Result = mrOk then
          nResult(mrOk, @FParam);
        //xxxxx
      end);
    //xxxxx
  end;
end;

procedure TfFormInvoiceSettle.InitFormData;
begin
  if FNowWeek = '' then
       EditWeek.Text := '请选择结算周期'
  else EditWeek.Text := Format('%s 年份:[ %s ]', [FWeekName, FNowYear]);
end;

procedure TfFormInvoiceSettle.ShowHintText(const nText: string);
begin
  EditMemo.Lines.Add(IntToStr(EditMemo.Lines.Count) + ' ::: ' + nText);
end;

//------------------------------------------------------------------------------
//Desc: 执行结算
procedure TfFormInvoiceSettle.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    nInit: Int64;
    nList: TStrings;
    nQuery: TADOQuery;
begin
  nList := nil;
  nQuery := nil;
  nInit := GetTickCount;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nQuery := LockDBQuery(FDBType);

    EditMemo.Clear;
    ShowHintText('开始恢复上次结算数据...');

    nSQL := 'Select S_CusID,Sum(S_Value*S_Price*(-1)) as S_Money From %s ' +
            'Where S_Week=''%s'' Group By S_CusID';
    nSQL := Format(nSQL, [sTable_InvSettle, FNowWeek]);

    nStr := 'Update $T Set $T.A_Compensation=$T.A_Compensation-t.S_Money ' +
            'From ($S) t Where $T.A_CID=t.S_CusID';
    //xxxxx

    with TStringHelper do
     nStr := MacroValue(nStr, [MI('$T', sTable_CusAccount), MI('$S', nSQL)]);
    nList.Add(nStr);

    nStr := 'Delete From %s Where S_Week=''%s''';
    nStr := Format(nStr, [sTable_InvSettle, FNowWeek]);
    nList.Add(nStr);

    ShowHintText('恢复上次结算数据完毕.');
    //--------------------------------------------------------------------------
    ShowHintText('开始生成新结算数据...');
    nStr := 'Insert Into $ST(S_Week,S_Bill,S_CusID,S_ZhiKa,S_Stock,S_StockName,' +
      'S_Value,S_Price,S_OutFact,S_Man,S_Date) Select ''$WK'',L_ID,L_CusID,' +
      'L_ZhiKa,L_StockNo,L_StockName,L_Value,0,L_OutFact,''$SM'',$SD From ' +
      '$Bill Where L_OutFact>=''$SS'' And L_OutFact<''$ED''';

    with TStringHelper,TDateTimeHelper do
    nStr := MacroValue(nStr, [MI('$ST', sTable_InvSettle), MI('$WK', FNowWeek),
            MI('$SM', UniMainModule.FUserConfig.FUserID),
            MI('$SD', sField_SQLServer_Now), MI('$Bill', sTable_Bill),
            MI('$SS', Date2Str(FWeekBegin)), MI('$ED', Date2Str(FWeekEnd+1))]);
    nList.Add(nStr);

    ShowHintText('新结算数据生成完毕.');
    //--------------------------------------------------------------------------
    ShowHintText('开始合并返利价格...');
    nStr := 'Update $T Set $T.S_Price=$R.R_KPrice,$T.S_YunFei=$R.R_YunFei' +
            ' From $R Where R_Week=''$WK'' And $T.S_Week=$R.R_Week' +
            ' And $T.S_ZhiKa=$R.R_ZhiKa And $T.S_Stock=$R.R_Stock';
    //xxxxx

    with TStringHelper do
    nStr := MacroValue(nStr, [MI('$T', sTable_InvSettle),
            MI('$R', sTable_InvoiceReq), MI('$WK', FNowWeek)]);
    nList.Add(nStr);

    nStr := 'Delete From %s Where S_Week=''%s'' And S_Price=0';
    nStr := Format(nStr, [sTable_InvSettle, FNowWeek]);
    nList.Add(nStr);

    ShowHintText('返利价格合并完毕.');
    //--------------------------------------------------------------------------
    ShowHintText('开始计算返利...');
    nSQL := 'Select S_CusID,Sum(S_Value*S_Price*(-1)) as S_Money From %s ' +
            'Where S_Week=''%s'' Group By S_CusID';
    nSQL := Format(nSQL, [sTable_InvSettle, FNowWeek]);

    nStr := 'Update $T Set $T.A_Compensation=$T.A_Compensation+t.S_Money ' +
            'From ($S) t Where $T.A_CID=t.S_CusID';
    //xxxxx

    with TStringHelper do
     nStr := MacroValue(nStr, [MI('$T', sTable_CusAccount), MI('$S', nSQL)]);
    nList.Add(nStr);

    ShowHintText('返利计算完毕.');
    //--------------------------------------------------------------------------
    ShowHintText('开始生成最终结算报表...');
    nSQL := 'Select S_ZhiKa,S_Stock,Sum(S_Value) as S_Value From %s ' +
            'Where S_Week=''%s'' Group By S_ZhiKa,S_Stock';
    nSQL := Format(nSQL, [sTable_InvSettle, FNowWeek]);

    nStr := 'Update $T Set $T.R_KValue=t.S_Value,R_KMan=''$KM'',R_KDate=$DT ' +
            'From ($S) t Where $T.R_Week=''$WK'' And $T.R_ZhiKa=t.S_ZhiKa And ' +
            '$T.R_Stock=t.S_Stock';
    //xxxxx

    with TStringHelper do
    nStr := MacroValue(nStr, [MI('$T', sTable_InvoiceReq), MI('$S', nSQL),
            MI('$WK', FNowWeek), MI('$KM', UniMainModule.FUserConfig.FUserID),
            MI('$DT', sField_SQLServer_Now)]);
    nList.Add(nStr);

    ShowHintText('结算完毕.');
    //EditMemo.Text := nList.Text;
    //--------------------------------------------------------------------------
    DBExecute(nList, nQuery);
    ModalResult := mrOk;
  finally
    gMG.FObjectPool.Release(nList);
    ReleaseDBQuery(nQuery);

    nInit := GetTickCount - nInit;
    if nInit < 2000 then
      Sleep(2000 - nInit);
    //xxxxx
  end;
end;

initialization
  RegisterClass(TfFormInvoiceSettle);
end.
