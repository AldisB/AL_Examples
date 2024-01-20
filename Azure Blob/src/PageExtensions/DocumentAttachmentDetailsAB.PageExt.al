pageextension 50200 "Document Attachment Details AB" extends "Document Attachment Details"
{
    layout
    {
        modify(Name)
        {
            trigger OnDrillDown()
            begin
                case Rec."Attachment Location" of
                    Rec."Attachment Location"::"Azure Storage":
                        AzureStorageHelper.DownloadAttachmentFromAzureStorage(Rec."File Name", Rec."File Extension");
                    Rec."Attachment Location"::Database:
                        if Rec.HasContent() then
                            Rec.Export(true)
                        else
                            InitiateUploadFile();
                end;
            end;
        }
    }
    actions
    {
        addlast(processing)
        {
            action(DownladFormAzureStorage)
            {
                ApplicationArea = All;
                Caption = 'Downlad Form Azure Storage';
                Image = Download;
                ToolTip = 'Executes the Downlad Form Azure Storage action.';

                trigger OnAction()
                begin
                    if not (Rec."Attachment Location" = Rec."Attachment Location"::"Azure Storage") then
                        exit;
                    AzureStorageHelper.DownloadAttachmentFromAzureStorage(Rec."File Name", Rec."File Extension");
                end;
            }
        }
    }

    local procedure InitiateUploadFile()
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        ImportWithFilter(TempBlob, FileName);
        if FileName <> '' then
            DocumentAttachment.SaveAttachment(FromRecRef, FileName, TempBlob);
        CurrPage.Update(true);
    end;

    local procedure ImportWithFilter(var TempBlob: Codeunit "Temp Blob"; var FileName: Text)
    var
        FileManagement: Codeunit "File Management";
        IsHandled: Boolean;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTok: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        ImportTxt: Label 'Attach a document.';
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        FileName := FileManagement.BLOBImportWithFilter(
            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTok), FilterTok);
    end;

    var
        AzureStorageHelper: Codeunit "Azure Storage Helper ABI";
}
