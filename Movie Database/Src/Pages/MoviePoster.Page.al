page 50102 "Movie Poster ABI"
{
    ApplicationArea = All;
    Caption = 'Movie Poster';
    PageType = CardPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    SourceTable = "Movie ABI";

    layout
    {
        area(content)
        {

            field(Image; Rec.Image)
            {
                ToolTip = 'Specifies the value of the Image field.';
                ShowCaption = false;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(UploadPoster)
            {
                ApplicationArea = All;
                Caption = 'Upload Poster';
                Image = Import;
                ToolTip = 'Import a poster image file.';

                trigger OnAction()
                var
                    InStream: InStream;
                    TitleTxt: Label 'Select a poster to upload';
                    FileName: Text;
                begin
                    if not UploadIntoStream(TitleTxt, '', '', FileName, InStream) then
                        exit;

                    Clear(Rec.Image);
                    Rec.Image.ImportStream(InStream, Rec.Description);
                    Rec.Modify(true);
                end;
            }
        }
    }
}
