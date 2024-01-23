pageextension 50150 "Customer List ABI" extends "Customer List"
{
    actions
    {
        addlast("&Customer")
        {
            action(Export2JSON)
            {
                Caption = 'Export All as JSON';
                ApplicationArea = All;
                Image = ExportDatabase;
                ToolTip = 'Executes the Export All as JSON action.';

                trigger OnAction()
                var
                    ExportJSON: Codeunit "Export JSON ABI";
                begin
                    ExportJSON.ExportCustomersAsJson(Rec);
                end;
            }
        }
        addlast(Category_Category7)
        {
            actionref(Export2JSON_Promoted; Export2JSON)
            {
            }
        }
    }
}
