pageextension 68000 "PTE Error Message Register" extends "Error Message Register"
{

    actions
    {
        addlast(processing)
        {
            action(PTEClear)
            {
                Caption = 'Clear';
                ApplicationArea = All;
                RunObject = report "PTE Clear Error Messages";
            }
        }
    }
}