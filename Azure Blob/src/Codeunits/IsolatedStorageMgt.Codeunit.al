codeunit 50200 "Isolated Storage Mgt. ABI"
{
    trigger OnRun()
    begin
    end;

    [NonDebuggable]
    internal procedure HasKey(KeyName: Text): Boolean
    begin
        if not IsolatedStorage.Contains(KeyName) then
            exit(false);

        exit(true);
    end;

    [NonDebuggable]
    internal procedure SetKey(KeyName: Text; KeyValue: Text)
    begin
        if EncryptionEnabled() then
            IsolatedStorage.SetEncrypted(KeyName, KeyValue, DataScope::Company)
        else
            IsolatedStorage.Set(KeyName, KeyValue, DataScope::Company);
    end;

    [NonDebuggable]
    internal procedure GetKey(KeyName: Text; var KeyValue: Text): Boolean
    begin
        if not IsolatedStorage.Get(KeyName, KeyValue) then
            exit(false);

        exit(true);
    end;
}
