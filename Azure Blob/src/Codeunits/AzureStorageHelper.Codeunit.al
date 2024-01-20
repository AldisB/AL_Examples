codeunit 50201 "Azure Storage Helper ABI"
{
    internal procedure SaveAttachmentToAzureStorage(FileName: Text; FileExtension: Text; DocInStream: InStream): Boolean
    var
        ABSOperationResponse: Codeunit "ABS Operation Response";
        ABSBlobClient: Codeunit "ABS Blob Client";
    begin
        AzureStorageSetup.Get();

        FileNameContainsExtension(FileName, FileExtension);
        CreateBlobClient(ABSBlobClient, AzureStorageSetup."Storage Account Name", AzureStorageSetup."Container Name");
        ABSOperationResponse := ABSBlobClient.PutBlobBlockBlobStream(FileName, DocInStream);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    internal procedure DeleteAttachmentFromAzureStorage(FileName: Text; FileExtension: Text): Boolean
    var
        ABSOperationResponse: Codeunit "ABS Operation Response";
        ABSBlobClient: Codeunit "ABS Blob Client";
    begin
        AzureStorageSetup.Get();

        FileNameContainsExtension(FileName, FileExtension);
        CreateBlobClient(ABSBlobClient, AzureStorageSetup."Storage Account Name", AzureStorageSetup."Container Name");
        ABSOperationResponse := ABSBlobClient.DeleteBlob(FileName);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    internal procedure DownloadAttachmentFromAzureStorage(FileName: Text; FileExtension: Text): Boolean
    var
        ABSOperationResponse: Codeunit "ABS Operation Response";
        ABSBlobClient: Codeunit "ABS Blob Client";
    begin
        AzureStorageSetup.Get();

        FileNameContainsExtension(FileName, FileExtension);
        CreateBlobClient(ABSBlobClient, AzureStorageSetup."Storage Account Name", AzureStorageSetup."Container Name");
        ABSOperationResponse := ABSBlobClient.GetBlobAsFile(FileName);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    local procedure CreateBlobClient(var ABSBlobClient: Codeunit "ABS Blob Client"; StorageAccountName: Text; ContainerName: Text)
    var
        AzureStorageSetup: Record "Azure Storage Setup ABI";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        IsolatedStorageMgt: Codeunit "Isolated Storage Mgt. ABI";
        Authorization: Interface "Storage Service Authorization";
        [NonDebuggable]
        StorageAccessKey: Text;
        KeyNotSetErr: Label 'Storage Access Key is not set. Please set it in the Isolated Storage.';
    begin
        AzureStorageSetup.Get();
        if not IsolatedStorageMgt.GetKey(AzureStorageSetup."Shared Access Key ID", StorageAccessKey) then
            Error(KeyNotSetErr);

        Authorization := StorageServiceAuthorization.CreateSharedKey(StorageAccessKey);
        ABSBlobClient.Initialize(StorageAccountName, ContainerName, Authorization);
    end;

    local procedure FileNameContainsExtension(var FileName: Text; FileExtension: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        if FileManagement.HasExtension(FileName) then
            exit;

        FileName := FileName + '.' + FileExtension;
    end;

    var
        AzureStorageSetup: Record "Azure Storage Setup ABI";
}