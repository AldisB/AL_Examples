#pragma warning disable LC0013, LC0035
table 50200 "Azure Storage Setup ABI"
{
    Caption = 'Azure Storage Setup';
    DataClassification = CustomerContent;

    fields
    {

        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Storage Account Name"; Text[50])
        {
            Caption = 'Storage Account Name';
        }
        field(3; "Shared Access Key ID"; Guid)
        {
            Caption = 'Shared Access Key ID';
        }
        field(4; "Container Name"; Text[50])
        {
            Caption = 'Container Name';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}