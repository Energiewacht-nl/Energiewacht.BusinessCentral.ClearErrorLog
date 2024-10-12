report 68002 "PTE Clear Tinx Message Entry"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Clear Tinx Message Entries';

    dataset
    {
        dataitem(MessageEntry; "TINX Message Entry")
        {
            RequestFilterFields = "Date Created";
            trigger OnPreDataItem()
            begin
                if Count > 100000 then
                    Error('Please use a smaller dataset');
            end;

            trigger OnAfterGetRecord()
            begin
                AddThisMessageEntryToBuffer();
            end;

            trigger OnPostDataItem()
            begin
                DeleteRegisters();
            end;
        }
    }

    local procedure AddThisMessageEntryToBuffer();
    begin
        MessageEntryBuffer := MessageEntry;
        MessageEntryBuffer.Insert();
    end;

    local procedure DeleteRegisters()
    var
        Dlg: Dialog;
        i, n : Integer;
    begin
        Dlg.Open('Delete Error Register #1#################');
        if MessageEntryBuffer.FindSet() then
            repeat
                i += 1;
                n += 1;
                if n = 100 then begin
                    Commit();
                    n := 0;
                end;
                Dlg.Update(1, Format(i) + ' of ' + Format(MessageEntryBuffer.Count));
                MessageEntry.Get(MessageEntryBuffer."Entry No.");
                MessageEntry.Delete(true);
            until MessageEntryBuffer.Next() = 0;
    end;

    var
        MessageEntryBuffer: Record "TINX Message Entry" temporary;
}