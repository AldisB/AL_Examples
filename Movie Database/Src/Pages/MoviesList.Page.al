page 50100 "Movies List ABI"
{
    Caption = 'Movies';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Movie ABI";
    CardPageId = "Movies Card ABI";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
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
    }
    actions
    {
        area(Processing)
        {
            action(SearchOMDB)
            {
                Caption = 'Search on OMDB';
                ToolTip = 'Executes the Search on OMDB action.';
                Image = Find;

                trigger OnAction()
                var
                    OMDBMgt: Codeunit "OMDB Mgt.";
                begin
                    OMDBMgt.Run();
                end;
            }
            action(BackupMovies)
            {
                Caption = 'Backup Movies';
                Image = Export;
                ToolTip = 'Executes the Backup Movies action.';

                trigger OnAction()
                var
                    OMDBSetup: Record "OMDB Setup ABI";
                    Backup: Interface Backup;
                begin
                    OMDBSetup.Get();
                    Backup := OMDBSetup."Backup Type";
                    Backup.Backup(Rec);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Home';
                actionref(SearchOMDb_Promoted; SearchOMDb)
                {
                }
                actionref(BackupMovies_Promoted; BackupMovies)
                {
                }
            }
        }
    }
}