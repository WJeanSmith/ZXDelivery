/*已存在表新增加的字段*/
go
ALTER TABLE P_Materails ADD
    M_IsSale            char(1)             null
go

ALTER TABLE S_Bill ADD
    L_PrintGLF          char(1)             null
go

ALTER TABLE S_BillBak ADD
    L_PrintGLF          char(1)             null
go

ALTER TABLE Sys_CustomerAccount ADD
    A_InitMoney         decimal(15,5)       null
go

ALTER TABLE Sys_PoundBak ADD
    P_KZValue           decimal(15,5)       null
go

ALTER TABLE Sys_PoundLog ADD
    P_KZValue           decimal(15,5)       null
go

ALTER TABLE Sys_WeixinMatch ADD
    M_WXFactory         varchar(15)         null,
    M_AttentionID       varchar(32)         null,
    M_AttentionType     char(1)             null
go

ALTER TABLE Sys_WorkePC ADD
    W_PoundID           varchar(50)         null,
    W_MITUrl            varchar(128)        null,
    W_HardUrl           varchar(128)        null
go

/*已存在表不同的字段*/
go
/*相同表名称的不同的表结构的更新
*/
go
ALTER TABLE S_Bill ADD
    TMP_FIELD_L_DelMan            varchar(32)         null
go
UPDATE S_Bill SET TMP_FIELD_L_DelMan=L_DelMan
go
ALTER TABLE S_Bill
DROP COLUMN L_DelMan
go
EXECUTE sp_rename N'S_Bill.TMP_FIELD_L_DelMan', N'L_DelMan', 'COLUMN'
go

ALTER TABLE S_BillBak ADD
    TMP_FIELD_L_DelMan            varchar(32)         null
go
UPDATE S_BillBak SET TMP_FIELD_L_DelMan=L_DelMan
go
ALTER TABLE S_BillBak
DROP COLUMN L_DelMan
go
EXECUTE sp_rename N'S_BillBak.TMP_FIELD_L_DelMan', N'L_DelMan', 'COLUMN'
go