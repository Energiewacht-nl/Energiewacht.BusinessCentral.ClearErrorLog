report 68004 "PTE Clear Job Queue L. Entries"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Clear Job Queue Log Entries';

    dataset
    {
        dataitem(JobQueueLogEntry; "Job Queue Log Entry")
        {
            RequestFilterFields = "Start Date/Time";
            trigger OnPreDataItem()
            begin
                if Count > 100000 then
                    Error('Please use a smaller dataset');
            end;

            trigger OnAfterGetRecord()
            begin
                AddThisJobQueueLogEntryBuffer();
            end;

            trigger OnPostDataItem()
            begin
                DeleteRegisters();
            end;
        }
    }

    local procedure AddThisJobQueueLogEntryBuffer();
    begin
        JobQueueLogEntryBuffer := JobQueueLogEntry;
        JobQueueLogEntryBuffer.Insert();
    end;

    local procedure DeleteRegisters()
    var
        Dlg: Dialog;
        i, n : Integer;
    begin
        Dlg.Open('Delete Records #1#################');
        if JobQueueLogEntryBuffer.FindSet() then
            repeat
                i += 1;
                n += 1;
                if n = 100 then begin
                    Commit();
                    n := 0;
                end;
                Dlg.Update(1, Format(i) + ' of ' + Format(JobQueueLogEntryBuffer.Count));
                JobQueueLogEntry.Get(JobQueueLogEntryBuffer."Entry No.");
                JobQueueLogEntry.Delete(true);
            until JobQueueLogEntryBuffer.Next() = 0;
    end;

    var
        JobQueueLogEntryBuffer: Record "Job Queue Log Entry" temporary;
}