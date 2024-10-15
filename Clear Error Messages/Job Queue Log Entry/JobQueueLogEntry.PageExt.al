pageextension 68004 "PTE Job Queue Log Entries" extends "Job Queue Log Entries"
{

    actions
    {
        addlast(processing)
        {
            action(PTEClear)
            {
                Caption = 'Clear';
                ApplicationArea = All;
                RunObject = report "PTE Clear Job Queue L. Entries";
            }
        }
    }
}