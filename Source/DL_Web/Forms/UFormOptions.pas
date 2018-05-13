{*******************************************************************************
  ����: dmzn@163.com 2018-05-12
  ����: ����ѡ��
*******************************************************************************}
unit UFormOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, UFormBase, uniPanel, uniGUIBaseClasses, uniButton,
  uniEdit, uniLabel, uniCheckBox;

type
  TfFormOptions = class(TfFormBase)
    CheckColumnAdjust: TUniCheckBox;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnCreateForm(Sender: TObject); override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication;

function fFormOptions: TfFormOptions;
begin
  Result := TfFormOptions(UniMainModule.GetFormInstance(TfFormOptions));
end;

procedure TfFormOptions.OnCreateForm(Sender: TObject);
begin
  CheckColumnAdjust.Checked := UniMainModule.FGridColumnAdjust;
end;

procedure TfFormOptions.BtnOKClick(Sender: TObject);
begin
  UniMainModule.FGridColumnAdjust := CheckColumnAdjust.Checked;
  ModalResult := mrOk;
end;

initialization
  RegisterClass(TfFormOptions);
end.