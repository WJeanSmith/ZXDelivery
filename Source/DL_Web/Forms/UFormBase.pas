{*******************************************************************************
  ����: dmzn@163.com 2018-04-24
  ����: ��׼����
*******************************************************************************}
unit UFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, uniGUIClasses,
  uniGUIForm, uniPanel, uniGUIBaseClasses, uniButton, USysConst;

type
  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;
  end;

  TfFormBase = class(TUniForm)
    BtnOK: TUniButton;
    BtnExit: TUniButton;
    PanelWork: TUniSimplePanel;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
  protected
    { Protected declarations }
    FDBType: TAdoConnectionType;
    //��������
    FParam: TFormCommandParam;
    //�������
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    function SetParam(const nParam: TFormCommandParam): Boolean; virtual;
    {*���ò���*}
  end;

implementation

{$R *.dfm}

procedure TfFormBase.UniFormCreate(Sender: TObject);
begin
  FDBType := ctWork;
  OnCreateForm(Sender);
end;

procedure TfFormBase.UniFormDestroy(Sender: TObject);
begin
  OnDestroyForm(Sender);
end;

procedure TfFormBase.OnCreateForm(Sender: TObject);
begin

end;

procedure TfFormBase.OnDestroyForm(Sender: TObject);
begin

end;

function TfFormBase.SetParam(const nParam: TFormCommandParam): Boolean;
begin
  Result := True;
  FParam := nParam;
end;

end.
