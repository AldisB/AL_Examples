page 50104 "Search by Title ABI"
{
    ApplicationArea = All;
    Caption = 'Get movie details form OMDB';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(MovieTitle; MovieTitle)
            {
                Caption = 'Movie Title';
                ToolTip = 'Specifies the value of the Movie Title field.';
            }
        }
    }

    var
        MovieTitle: Text;

    internal procedure GetMovieTitle(): Text
    begin
        exit(MovieTitle);
    end;
}
