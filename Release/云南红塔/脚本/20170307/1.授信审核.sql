delete from sys_dict where d_name='SysParam' and d_memo='CreditVerify'
insert into sys_dict(d_name,d_desc,d_value,d_memo) values('SysParam', '授信需要审核', 'Y', 'CreditVerify')