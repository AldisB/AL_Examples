page 50101 "Movies Card ABI"
{
    ApplicationArea = All;
    Caption = 'Movie Card';
    PageType = Card;
    SourceTable = "Movie ABI";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(Genre; Rec.Genre)
                {
                    ToolTip = 'Specifies the value of the Genre field.';
                }
                field(Actors; Rec.Actors)
                {
                    ToolTip = 'Specifies the value of the Actor field.';
                }
                field(Production; Rec.Production)
                {
                    ToolTip = 'Specifies the value of the Production field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    MultiLine = true;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                }

                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the value of the Image field.';
                }
            }
        }
        area(factboxes)
        {
            part(MoviePoster; "Movie Poster ABI")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }
}