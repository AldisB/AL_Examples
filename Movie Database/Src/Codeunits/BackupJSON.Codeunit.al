codeunit 50103 "Backup JSON ABI" implements Backup
{
    procedure Backup(Movie: Record "Movie ABI"): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        ImageInStream, InStream : InStream;
        ImageOutStream, OutStream : OutStream;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        MovieJsonObject: JsonObject;
        FileName: Text;
        ImageTxt: Text;
        FileNameLbl: Label 'Movies.json';
    begin
        Movie.Reset();
        if not Movie.FindSet() then
            exit;

        repeat
            Clear(TempBlob);
            TempBlob.CreateOutStream(ImageOutStream);
            Movie.Image.ExportStream(ImageOutStream);
            TempBlob.CreateInStream(ImageInStream);
            ImageTxt := Base64Convert.ToBase64(ImageInStream);

            Clear(JsonObject);
            JsonObject.Add('No_', Movie."No.");
            JsonObject.Add('Title', Movie.Title);
            JsonObject.Add('Year', Movie.Year);
            JsonObject.Add('Genre', Movie.Genre);
            JsonObject.Add('Actors', Movie.Actors);
            JsonObject.Add('Production', Movie.Production);
            JsonObject.Add('Description', Movie.Description);
            JsonObject.Add('Score', Movie.Score);
            JsonObject.Add('Image', ImageTxt);
            JsonArray.Add(JsonObject);
        until Movie.Next() = 0;
        MovieJsonObject.Add('Movies', JsonArray);

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        MovieJsonObject.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream);

        FileName := FileNameLbl;
        DownloadFromStream(InStream, '', '', '', FileName);

    end;
}