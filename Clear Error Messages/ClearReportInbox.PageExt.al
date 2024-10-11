pageextension 68001 "PTE Report Inbox" extends "Report Inbox"
{

    actions
    {
        addlast(processing)
        {
            action(PTEClear)
            {
                Caption = 'Clear';
                ApplicationArea = All;
                RunObject = report "PTE Clear Report Inbox";
            }
        }
    }
}