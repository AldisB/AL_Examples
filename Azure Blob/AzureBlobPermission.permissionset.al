permissionset 50200 AzureBlobPermission
{
    Assignable = true;
    Caption = 'Azure Blob Permission', Locked = true;
    Permissions = tabledata "Azure Storage Setup ABI" = RIMD,
        table "Azure Storage Setup ABI" = X,
        page "Azure Storage Setup ABI" = X,
        codeunit "Isolated Storage Mgt. ABI" = X,
        codeunit "Azure Storage Helper ABI" = X,
        codeunit "Doc. Attachment Events ABI" = X;
}