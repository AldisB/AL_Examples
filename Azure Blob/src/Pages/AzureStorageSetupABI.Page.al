page 50200 "Azure Storage Setup ABI"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Azure Storage Setup';
    PageType = Card;
    SourceTable = "Azure Storage Setup ABI";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Storage Account Name"; Rec."Storage Account Name")
                {
                    ToolTip = 'Specifies the value of the Storage Account Name field.';
                }
                field("Shared Access Key ID"; Rec."Shared Access Key ID")
                {
                    ToolTip = 'Specifies the value of the Shared Access Key ID field.';
                }
                field(SharedAccessKey; SharedAccessKey)
                {
                    Caption = 'Shared Access Key';
                    ToolTip = 'Specifies the value of the SharedAccessKey field.';

                    trigger OnValidate()
                    begin
                        Rec.TestField("Shared Access Key ID");

                        IsolatedStorageMgt.SetKey(Rec."Shared Access Key ID", SharedAccessKey);
                    end;
                }
                field("Container Name"; Rec."Container Name")
                {
                    ToolTip = 'Specifies the value of the Container Name field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert(false);
        end;

        IsolatedStorageMgt.GetKey(Rec."Shared Access Key ID", SharedAccessKey);
    end;

    var
        IsolatedStorageMgt: Codeunit "Isolated Storage Mgt. ABI";
        SharedAccessKey: Text;
}
