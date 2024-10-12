pageextension 68002 "PTE Tinx Message Entry" extends "TINX Message Entry List"
{

    actions
    {
        addlast(processing)
        {
            action(PTEClear)
            {
                Caption = 'Clear';
                ApplicationArea = All;
                RunObject = report "PTE Clear Tinx Message Entry";
            }
        }
    }
}