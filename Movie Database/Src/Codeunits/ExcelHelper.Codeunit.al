#pragma warning disable AA0228
codeunit 50107 "Excel Helper ABI"
{
    Access = Internal;
    SingleInstance = true;

    procedure ExportAllUserRecordsToExcel(SendStreamTo: Enum SendStreamTo)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        CreateExcelHeaders(TempExcelBuffer);
        ExportAllUserRecordsToExcel(TempExcelBuffer);
        CloseExcelFile(SendStreamTo, 'Users', TempExcelBuffer);
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

    local procedure CloseExcelFile(SendStreamTo: Enum SendStreamTo; Name: Text[250]; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        ISendStream: Interface SendStream;
        FileNameTok: Label 'Business Central Booster %1', Locked = true, Comment = '%1 = Name of the set';
        FileNameWithExtensionTok: Label 'Business Central Booster %1.xlsx', Locked = true;
        FileName: Text;
    begin
        ISendStream := SendStreamTo;

        TempExcelBuffer.CreateNewBook(Name);
        TempExcelBuffer.WriteSheet(Name, CompanyName, UserId());
        TempExcelBuffer.CloseBook();

        // Use Direct Download if you want to download the file directly to the user's browser
        FileName := StrSubstNo(FileNameTok, Name);
        DirectDownload(Name, TempExcelBuffer);

        // Use SaveToStream if you want to save the file to an OutStream and then do something with it
        FileName := StrSubstNo(FileNameWithExtensionTok, Name);
        ISendStream.SendStream(FileName, TempExcelBuffer);
    end;

    local procedure DirectDownload(FileName: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;

    internal procedure GetContentType(FileName: Text): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        exit(FileManagement.GetFileNameMimeType(FileName));
    end;
}

