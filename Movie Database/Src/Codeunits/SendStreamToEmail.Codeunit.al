codeunit 50109 SendStreamToEmail implements SendStream
{
    internal procedure SendStream(FileName: Text; var TempBlob: Codeunit System.Utilities."Temp Blob")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        ExcelHelper: Codeunit "Excel Helper ABI";
        ExcelInStream: InStream;
        ContentType: Text;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        ContentType := ExcelHelper.GetContentType(FileName);

        EmailMessage.Create('info@someone.com', 'Business Central Users', 'Attached is the list of users');
        EmailMessage.AddAttachment(CopyStr(FileName, 1, 250), CopyStr(ContentType, 1, 250), ExcelInStream);
        Email.Send(EmailMessage);
    end;
}