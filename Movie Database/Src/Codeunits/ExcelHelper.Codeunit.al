#pragma warning disable AA0228
codeunit 50107 "Excel Helper ABI"
{
    Access = Internal;
    SingleInstance = true;

    procedure ExportAllUserRecordsToExcel()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        CreateExcelHeaders(TempExcelBuffer);
        ExportAllUserRecordsToExcel(TempExcelBuffer);
        CloseExcelFile('Users', TempExcelBuffer);
    end;

    local procedure ExportAllUserRecordsToExcel(var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        User: Record User;
    begin
        if User.FindSet() then
            repeat
                ExportRecordToExcel(User, TempExcelBuffer);
            until User.Next() = 0;
    end;

    local procedure CreateExcelHeaders(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        CreateExcelColumnHeader('First Name', TempExcelBuffer);
        CreateExcelColumnHeader('Last Name', TempExcelBuffer);
        CreateExcelColumnHeader('Email', TempExcelBuffer);
    end;

    local procedure ExportRecordToExcel(User: Record User; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
    begin
        TempExcelBuffer.NewRow();
        CreateExcelColumn(User."User Security ID", TempExcelBuffer);
        CreateExcelColumn(User."User Name", TempExcelBuffer);
        CreateExcelColumn(User."Full Name", TempExcelBuffer);
        CreateExcelColumn(User."Contact Email", TempExcelBuffer);
        CreateExcelColumn(Format(User."License Type"), TempExcelBuffer);
    end;

    local procedure CreateExcelColumnHeader(TextValue: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(TextValue, true, TempExcelBuffer."Cell Type"::"Text", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(NumberValue: Integer; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(NumberValue, false, TempExcelBuffer."Cell Type"::"Number", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(TextValue: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(TextValue, false, TempExcelBuffer."Cell Type"::"Text", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(VariantValue: Variant; IsBold: Boolean; CellType: Option "Number","Text","Date","Time";
                                      var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.AddColumn(VariantValue, false, '', IsBold, false, false, '', CellType);
    end;

    local procedure CloseExcelFile(Name: Text[250]; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        FileNameTok: Label 'Business Central Booster %1', Locked = true, Comment = '%1 = Name of the set';
        FileNameWithExtensionTok: Label 'Business Central Booster %1.xlsx', Locked = true;
        FileName: Text;
    begin
        TempExcelBuffer.CreateNewBook(Name);
        TempExcelBuffer.WriteSheet(Name, CompanyName, UserId());
        TempExcelBuffer.CloseBook();

        // Use Direct Download if you want to download the file directly to the user's browser
        FileName := StrSubstNo(FileNameTok, Name);
        DirectDownload(Name, TempExcelBuffer);

        // Use SaveToStream if you want to save the file to an OutStream and then do something with it
        FileName := StrSubstNo(FileNameWithExtensionTok, Name);
        SaveToStream(FileName, TempExcelBuffer);
    end;

    local procedure DirectDownload(FileName: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;

    local procedure SaveToStream(FileName: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        TempBlob: Codeunit "Temp Blob";
        SendStream: Interface SendStream;
        ExcelOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ExcelOutStream);
        TempExcelBuffer.SaveToStream(ExcelOutStream, true);

        case SendStreamTo of
            SendStreamTo::DownloadToUsersBrowser:
                begin
                    SendStream := SendStreamTo::DownloadToUsersBrowser;
                    SendStream.SendStream(FileName, TempBlob);
                end;
            SendStreamTo::SendAsEmail:
                begin
                    SendStream := SendStreamTo::SendAsEmail;
                    SendStream.SendStream(FileName, TempBlob);
                end;
            SendStreamTo::SendAsHttp:
                begin
                    SendStream := SendStreamTo::SendAsHttp;
                    SendStream.SendStream(FileName, TempBlob);
                end;
        end;
    end;

    internal procedure SetSendStreamTo(SendStreamToValue: Enum SendStreamTo)
    begin
        SendStreamTo := SendStreamToValue;
    end;

    internal procedure GetContentType(FileName: Text): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        exit(FileManagement.GetFileNameMimeType(FileName));
    end;

    var
        SendStreamTo: Enum SendStreamTo;
}

