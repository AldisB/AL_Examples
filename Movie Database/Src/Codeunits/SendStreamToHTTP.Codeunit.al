codeunit 50110 SendStreamToHTTP implements SendStream
{
    internal procedure SendStream(FileName: Text; var TempBlob: Codeunit System.Utilities."Temp Blob")
    var
        ExcelHttpClient: HttpClient;
        ExcelHttpResponseMessage: HttpResponseMessage;
        ExcelHttpContent: HttpContent;
        ServiceUrl: Text;
        CallToWebserviceFailedErr: Label 'Call to webservice failed.';
        WebserviceReturnedErr: Label 'Webservice returned an error. Description: %1', Comment = '%1 = Error description';
    begin
        ServiceUrl := 'https://www.test.com/uploadexcel';

        SetHttpContentAndHeaders(FileName, TempBlob, ExcelHttpContent);

        if not (ExcelHttpClient.Post(ServiceUrl, ExcelHttpContent, ExcelHttpResponseMessage)) then
            Error(CallToWebserviceFailedErr);

        if not (ExcelHttpResponseMessage.IsSuccessStatusCode()) then
            Error(WebserviceReturnedErr, ExcelHttpResponseMessage.ReasonPhrase);

        // Handle the response from the webservice               
    end;

    local procedure SetHttpContentAndHeaders(FileName: Text; var TempBlob: Codeunit "Temp Blob";
                                             var ExcelHttpContent: HttpContent)
    var
        ExcelHelper: Codeunit "Excel Helper ABI";
        ContentHeaders: HttpHeaders;
        ExcelInStream: InStream;
        ContentType: Text;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        ContentType := ExcelHelper.GetContentType(FileName);

        ExcelHttpContent.WriteFrom(ExcelInStream);
        ExcelHttpContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', ContentType);
    end;
}