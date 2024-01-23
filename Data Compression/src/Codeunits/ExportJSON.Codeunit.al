codeunit 50150 "Export JSON ABI"
{

    procedure ExportCustomersAsJson(Customer: Record Customer): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        DataCompression: Codeunit "Data Compression";
        ImageInStream, InStream : InStream;
        ImageOutStream, OutStream : OutStream;
        AddressJsonArray, JsonArray : JsonArray;
        AddressJsonObject, JsonObject : JsonObject;
        CustomerJsonObject: JsonObject;
        FileName: Text;
        ImageTxt: Text;
        FileNameLbl: Label 'Customers.zip';
    begin
        Customer.Reset();
        if not Customer.FindSet() then
            exit;

        DataCompression.CreateZipArchive();

        repeat
            Clear(TempBlob);
            TempBlob.CreateOutStream(ImageOutStream);
            Customer.Image.ExportStream(ImageOutStream);
            TempBlob.CreateInStream(ImageInStream);
            ImageTxt := Base64Convert.ToBase64(ImageInStream);

            Clear(JsonObject);
            Clear(AddressJsonObject);
            Clear(AddressJsonArray);
            Clear(JsonArray);
            Clear(CustomerJsonObject);

            JsonObject.Add('No_', Customer."No.");
            JsonObject.Add('Name', Customer.Name);
            Clear(AddressJsonObject);
            AddressJsonObject.Add('Address', Customer.Address);
            AddressJsonObject.Add('Post Code', Customer."Post Code");
            AddressJsonObject.Add('City', Customer.City);
            AddressJsonObject.Add('Country_Region Code', Customer."Country/Region Code");
            AddressJsonArray.Add(AddressJsonObject);
            JsonObject.Add('Address', AddressJsonArray);
            JsonObject.Add('Phone No_', Customer."Phone No.");
            JsonObject.Add('E-mail', Customer."E-Mail");
            JsonObject.Add('Home Page', Customer."Home Page");
            JsonObject.Add('VAT Registration No_', Customer."VAT Registration No.");
            JsonObject.Add('Payment Terms Code', Customer."Payment Terms Code");
            JsonObject.Add('Payment Method Code', Customer."Payment Method Code");
            JsonObject.Add('Blocked', Format(Customer.Blocked));
            JsonObject.Add('Image', ImageTxt);
            //JsonArray.Add(JsonObject);
            CustomerJsonObject.Add('Customer', JsonObject);

            Clear(TempBlob);
            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            CustomerJsonObject.WriteTo(OutStream);
            TempBlob.CreateInStream(InStream);

            DataCompression.AddEntry(InStream, Customer."No." + '.json');
        until Customer.Next() = 0;

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        DataCompression.SaveZipArchive(OutStream);
        TempBlob.CreateInStream(InStream);

        FileName := FileNameLbl;
        DownloadFromStream(InStream, '', '', '', FileName);

    end;
}