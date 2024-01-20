tableextension 50200 "Document Attachment ABI" extends "Document Attachment"
{
    fields
    {
        field(50200; "Attachment Location"; Enum "Doc. Attachment Location ABI")
        {
            Caption = 'Attachment Location';
            DataClassification = CustomerContent;
            InitValue = 1;
        }
    }
}
