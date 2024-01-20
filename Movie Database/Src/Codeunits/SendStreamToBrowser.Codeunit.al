codeunit 50108 SendStreamToBrowser implements SendStream
{
    procedure SendStream(FileName: Text; var TempBlob: Codeunit System.Utilities."Temp Blob")
    var
        ExcelInStream: InStream;
        ExcelFilterTok: Label 'Excel Files (*.xlsx)|*.xlsx', Locked = true;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        DownloadFromStream(ExcelInStream, 'Download Excel File', '', ExcelFilterTok, FileName)
    end;
}