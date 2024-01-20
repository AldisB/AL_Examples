enum 50102 SendStreamTo implements SendStream
{
    Extensible = true;

    value(1; DownloadToUsersBrowser)
    {
        Caption = 'Download To Users Browser';
        Implementation = SendStream = SendStreamToBrowser;
    }
    value(2; SendAsEmail)
    {
        Caption = 'Send As Email';
        Implementation = SendStream = SendStreamToEmail;
    }
    value(3; SendAsHttp)
    {
        Caption = 'Send As Http';
        Implementation = SendStream = SendStreamToHTTP;
    }
}