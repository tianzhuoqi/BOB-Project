title ���lua�﷨
@echo ��ʼ
if exist BuildLua.bat (cd ../../CompileScript/Ruby) else (cd CompileScript/Ruby)
ruby nlua_check.rb
@echo ����
pause