codeunit 50104 "Backup XML ABI" implements Backup
{
    procedure Backup(Movie: Record "Movie ABI"): Boolean
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        ImageInStream, InStream : InStream;
        ImageOutStream, OutStream : OutStream;
        FileName: Text;
        ImageTxt: Text;
        FileNameLbl: Label 'Movies.xml';
    begin
        Movie.Reset();
        if not Movie.FindSet() then
            exit;

        TempXMLBuffer.AddGroupElement('Movies');

        repeat
            TempXMLBuffer.AddGroupElement('Movie');

            TempXMLBuffer.AddElement('No_', Movie."No.");
            TempXMLBuffer.AddElement('Title', Movie.Title);
            TempXMLBuffer.AddElement('Year', Format(Movie.Year));
            TempXMLBuffer.AddElement('Genre', Movie.Genre);
            TempXMLBuffer.AddElement('Actors', Movie.Actors);
            TempXMLBuffer.AddElement('Production', Movie.Production);
            TempXMLBuffer.AddElement('Description', Movie.Description);
            TempXMLBuffer.AddElement('Score', Format(Movie.Score));

            Clear(TempBlob);
            TempBlob.CreateOutStream(ImageOutStream);
            Movie.Image.ExportStream(ImageOutStream);
            TempBlob.CreateInStream(ImageInStream);
            ImageTxt := Base64Convert.ToBase64(ImageInStream);


            TempXMLBuffer.AddElement('Image', ImageTxt);
            TempXMLBuffer.GetParent();
        until Movie.Next() = 0;

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        TempXMLBuffer.Save(TempBlob);
        TempBlob.CreateInStream(InStream);
        FileName := FileNameLbl;
        DownloadFromStream(InStream, '', '', '', FileName);
    end;
}