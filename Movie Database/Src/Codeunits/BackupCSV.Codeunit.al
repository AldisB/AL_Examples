codeunit 50105 "Backup CSV ABI" implements Backup
{
    procedure Backup(Movie: Record "Movie ABI"): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        TxtBuilder: TextBuilder;
        FileNameLbl: Label 'Movies.csv';
    begin
        Movie.Reset();
        if not Movie.FindSet() then
            exit;

        FileName := FileNameLbl;
        TxtBuilder.AppendLine(Movie.FieldCaption("No.") + ';' +
            Movie.FieldCaption(Title) + ';' +
            Movie.FieldCaption(Year) + ';' +
            Movie.FieldCaption(Genre) + ';' +
            Movie.FieldCaption(Actors) + ';' +
            Movie.FieldCaption(Production) + ';' +
            Movie.FieldCaption(Description) + ';' +
            Movie.FieldCaption(Score));

        repeat
            TxtBuilder.AppendLine(Movie."No." + ';' +
                Movie.Title + ';' +
                Format(Movie.Year) + ';' +
                Movie.Genre + ';' +
                Movie.Actors + ';' +
                Movie.Production + ';' +
                Movie.Description + ';' +
                Format(Movie.Score));

        until Movie.Next() = 0;

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(TxtBuilder.ToText());
        TempBlob.CreateInStream(InStream);

        DownloadFromStream(InStream, '', '', '', FileName);
    end;
}