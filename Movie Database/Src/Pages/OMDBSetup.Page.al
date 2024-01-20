page 50105 "OMDB Setup ABI"
{
    ApplicationArea = All;
    Caption = 'OMDB Setup';
    PageType = Card;
    SourceTable = "OMDB Setup ABI";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("API URL"; Rec."API URL")
                {
                    ToolTip = 'Specifies the value of the API URL field.';
                }
                field("Movie Details URL"; Rec."Movie Details URL")
                {
                    ToolTip = 'Specifies the value of the Movie Details URL field.';
                }
                field("API Key"; Rec."API Key")
                {
                    ToolTip = 'Specifies OMDB API Key.';
                }
                field("Backup Type"; Rec."Backup Type")
                {
                    ToolTip = 'Specifies the value of the Backup Type field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(false);
        end;
    end;
}
