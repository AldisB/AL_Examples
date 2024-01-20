page 50103 "API - Movies ABI"
{
    APIGroup = 'apiGroup';
    APIPublisher = 'abi';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'API Movies';
    DelayedInsert = true;
    EntityName = 'movie';
    EntitySetName = 'movies';
    PageType = API;
    SourceTable = "Movie ABI";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Editable = false;
                }
                field(no; Rec."No.")
                {
                }
                field(title; Rec.Title)
                {
                }
                field(year; Rec.Year)
                {
                }
                field(genre; Rec.Genre)
                {
                }
                field(actors; Rec.Actors)
                {
                }
                field(production; Rec.Production)
                {
                }
                field(description; Rec.Description)
                {
                }
                field(score; Rec.Score)
                {
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }
}
