page 50250 "Balance Chart ABI"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Balance Chart';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                usercontrol("Chart Control"; "Chart Control")
                {
                    trigger ControlReady()
                    begin
                        GetChart();
                    end;
                }
            }
        }
    }

    local procedure GetChart()
    var
        Customer: Record Customer;
        CustomerNameJsonArray, CustomerBalanceJsonArray : JsonArray;
    begin
        Customer.SetLoadFields(Name, "Balance (LCY)");
        Customer.SetAutoCalcFields("Balance (LCY)");
        if not Customer.FindSet() then
            exit;
        repeat
            CustomerNameJsonArray.Add(Customer.Name);
            CustomerBalanceJsonArray.Add(Customer."Balance (LCY)");
        until Customer.Next() = 0;

        CurrPage."Chart Control".drawChart(CustomerNameJsonArray, CustomerBalanceJsonArray);
    end;
}
