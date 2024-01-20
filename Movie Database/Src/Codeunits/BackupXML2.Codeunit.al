codeunit 50106 "Backup XML2 ABI" implements Backup
{
    procedure Backup(Movie: Record "Movie ABI"): Boolean
    var

        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        ImageInStream, InStream : InStream;
        ImageOutStream, OutStream : OutStream;
        XmlDoc: XmlDocument;
        Declaration: XmlDeclaration;
        MoviesElement: XmlElement;
        MovieElement: XmlElement;
        Element: XmlElement;
        XmlWriteOptions: XmlWriteOptions;
        FileName: Text;
        ImageTxt: Text;
        FileNameLbl: Label 'Movies.xml';
    begin
        Movie.Reset();
        if not Movie.FindSet() then
            exit;

        XmlDoc := XmlDocument.Create();

        Declaration := XmlDeclaration.Create('1.0', 'utf-8', 'yes');
        XmlDoc.SetDeclaration(Declaration);

        MoviesElement := XmlElement.Create('Movies');

        repeat
            Clear(MovieElement);
            MovieElement := XmlElement.Create('Movie');
            // MovieElement.SetAttribute('id', Movie."No.");

            AddElement(Element, 'No_', Movie."No.");
            AddElement(Element, 'Title', Movie.Title);
            AddElement(Element, 'Year', Format(Movie.Year));
            AddElement(Element, 'Genre', Movie.Genre);
            AddElement(Element, 'Actors', Movie.Actors);
            AddElement(Element, 'Production', Movie.Production);
            AddElement(Element, 'Description', Movie.Description);
            AddElement(Element, 'Score', Format(Movie.Score));

            Clear(TempBlob);
            TempBlob.CreateOutStream(ImageOutStream);
            Movie.Image.ExportStream(ImageOutStream);
            TempBlob.CreateInStream(ImageInStream);
            ImageTxt := Base64Convert.ToBase64(ImageInStream);

            AddElement(Element, 'Image', ImageTxt);
            MoviesElement.Add(MovieElement);
        until Movie.Next() = 0;

        XmlDoc.Add(MoviesElement);

        XmlWriteOptions.PreserveWhitespace(true);

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        XmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream);
        FileName := FileNameLbl;
        DownloadFromStream(InStream, '', '', '', FileName);
    end;

    local procedure AddElement(var Element: XmlElement; ElementName: Text; ElementValue: Text)
    begin
        Element := XmlElement.Create(ElementName);
        Element.Add(XmlText.Create(ElementValue));
    end;
}