report 68000 "PTE Clear Error Log"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Clear Error Log';

    dataset
    {
        dataitem(ErrorMessageRegister; "Error Message Register")
        {
            RequestFilterFields = "Created On";
            trigger OnPreDataItem()
            begin
                if Count > 10000 then
                    Error('Please use a smaller dataset');
            end;

            trigger OnAfterGetRecord()
            begin
                AddThisErrorMessageRegisterToBuffer();
            end;

            trigger OnPostDataItem()
            begin
                DeleteRegisters();
            end;
        }
    }

    local procedure AddThisErrorMessageRegisterToBuffer();
    begin
        ErrorMessageRegisterBuffer := ErrorMessageRegister;
        ErrorMessageRegisterBuffer.Insert();
    end;

    local procedure DeleteRegisters()
    var
        Dlg: Dialog;
        i, n : Integer;
    begin
        Dlg.Open('Delete Error Register #1#################');
        if ErrorMessageRegisterBuffer.FindSet() then
            repeat
                i += 1;
                n += 1;
                if n = 100 then begin
                    Commit();
                    n := 0;
                end;
                Dlg.Update(1, Format(i) + ' of ' + Format(ErrorMessageRegisterBuffer.Count));
                ErrorMessageRegister.Get(ErrorMessageRegisterBuffer.ID);
                ErrorMessageRegister.Delete(true);
            until ErrorMessageRegisterBuffer.Next() = 0;
    end;

    var
        ErrorMessageRegisterBuffer: Record "Error Message Register" temporary;
}