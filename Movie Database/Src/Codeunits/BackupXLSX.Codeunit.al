codeunit 50102 "Backup XLSX ABI" implements Backup
{
    procedure Backup(Movie: Record "Movie ABI"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        FileNameLbl: Label 'Movies.xlsx';
        SheetNameLbl: Label 'Movies';
    begin
        Movie.Reset();
        if not Movie.FindSet() then
            exit;

        FileName := FileNameLbl;
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Movie.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Title), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Year), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Genre), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Actors), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Production), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Movie.FieldCaption(Score), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(Movie."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Title, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Year, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Movie.Genre, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Actors, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Production, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Movie.Score, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        until Movie.Next() = 0;

        TempExcelBuffer.CreateNewBook(SheetNameLbl);
        TempExcelBuffer.WriteSheet(SheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(OutStream, false);
        TempBlob.CreateInStream(InStream);

        DownloadFromStream(InStream, '', '', '', FileName);
    end;
}