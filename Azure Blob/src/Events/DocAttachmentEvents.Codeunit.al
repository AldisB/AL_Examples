codeunit 50202 "Doc. Attachment Events ABI"
{

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnInsertAttachmentOnBeforeImportStream, '', false, false)]
    local procedure OnInsertAttachmentOnBeforeImportStream(var DocumentAttachment: Record "Document Attachment"; DocInStream: InStream; FileName: Text; var IsHandled: Boolean)
    var
        AzureStorageHelper: Codeunit "Azure Storage Helper ABI";
        ConfirmManagement: Codeunit "Confirm Management";
        DefaultAnswer: Boolean;
        StoreinAzureLbl: Label 'Would you like to store attachemtn in Azure Storage?';

    begin
        DefaultAnswer := false;
        if not ConfirmManagement.GetResponseOrDefault(StoreinAzureLbl, DefaultAnswer) then
            exit;

        IsHandled := true;
        if AzureStorageHelper.SaveAttachmentToAzureStorage(DocumentAttachment."File Name", DocumentAttachment."File Extension", DocInStream) then
            DocumentAttachment."Attachment Location" := DocumentAttachment."Attachment Location"::"Azure Storage";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteEvent(RunTrigger: Boolean; var Rec: Record "Document Attachment")
    var
        AzureStorageHelper: Codeunit "Azure Storage Helper ABI";
    begin
        if not (Rec."Attachment Location" = Rec."Attachment Location"::"Azure Storage") then
            exit;

        AzureStorageHelper.DeleteAttachmentFromAzureStorage(Rec."File Name", Rec."File Extension");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnInsertOnBeforeCheckDocRefID, '', false, false)]
    local procedure OnInsertOnBeforeCheckDocRefID(var DocumentAttachment: Record "Document Attachment"; var IsHandled: Boolean)
    begin
        if not (DocumentAttachment."Attachment Location" = DocumentAttachment."Attachment Location"::"Azure Storage") then
            exit;

        IsHandled := true;
    end;
}