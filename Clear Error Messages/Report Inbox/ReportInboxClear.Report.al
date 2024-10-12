report 68001 "PTE Clear Report Inbox"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Clear Report Inbox';

    dataset
    {
        dataitem(ReportInbox; "Report Inbox")
        {
            RequestFilterFields = "Created Date-Time";
            trigger OnPreDataItem()
            begin
                if Count > 100000 then
                    Error('Please use a smaller dataset');
            end;

            trigger OnAfterGetRecord()
            begin
                AddThisReportInboxToBuffer();
            end;

            trigger OnPostDataItem()
            begin
                DeleteRegisters();
            end;
        }
    }

    local procedure AddThisReportInboxToBuffer();
    begin
        ReportInboxBuffer := ReportInbox;
        ReportInboxBuffer.Insert();
    end;

    local procedure DeleteRegisters()
    var
        Dlg: Dialog;
        i, n : Integer;
    begin
        Dlg.Open('Delete Report Inbox #1#################');
        if ReportInboxBuffer.FindSet() then
            repeat
                i += 1;
                n += 1;
                if n = 100 then begin
                    Commit();
                    n := 0;
                end;
                Dlg.Update(1, Format(i) + ' of ' + Format(ReportInboxBuffer.Count));
                ReportInbox.Get(ReportInboxBuffer."Entry No.");
                ReportInbox.Delete(true);
            until ReportInboxBuffer.Next() = 0;
    end;

    var
        ReportInboxBuffer: Record "Report Inbox" temporary;
}