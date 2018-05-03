{*******************************************************************************
  ����: dmzn@163.com 2018-05-03
  ����: Զ��ҵ�����
*******************************************************************************}
unit USysRemote;

{$I Link.Inc}
interface

uses
  Windows, Classes, UClientWorker, UManagerGroup, UBusinessConst,
  ULibFun, USysDB, USysConst, USysFun;

function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//��ȡ���б��

implementation

//Date: 2018-05-03
//Parm: ����;����;����;���
//Desc: �����м���ϵ�ҵ���������
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessCommand) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessSaleBill) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessPurchaseOrder) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessHardware) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;


//Date: 2018-05-03
//Parm: ����;����;����;�����ַ;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessWechat(const nCmd: Integer; const nData,nExt,nSrvURL: string;
  const nOut: PWorkerWebChatData; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerWebChatData;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FRemoteUL := nSrvURL;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessWechat) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-05-03
//Parm: ����;����;ʹ�����ڱ���ģʽ
//Desc: ����nGroup.nObject���ɴ��б��
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

end.


