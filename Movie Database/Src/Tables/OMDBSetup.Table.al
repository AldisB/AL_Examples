table 50101 "OMDB Setup ABI"
{
    Caption = 'OMDB Setup';
    DataClassification = CustomerContent;

    fields
    {
#pragma warning disable LC0013
        field(1; "Primary Key"; Code[10])
#pragma warning restore LC0013
        {
            Caption = 'Primary Key';
            AllowInCustomizations = Never;
        }
        field(2; "API URL"; Text[2048])
        {
            Caption = 'API URL';
            ExtendedDatatype = URL;
        }
        field(3; "API Key"; Text[30])
        {
            Caption = 'API Key';
            ExtendedDatatype = Masked;
        }
        field(4; "Movie Details URL"; Text[2048])
        {
            Caption = 'Movie Details URL';
            ExtendedDatatype = URL;
        }
        field(5; "Backup Type"; Enum "Backup Type ABI")
        {
            Caption = 'Backup Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
