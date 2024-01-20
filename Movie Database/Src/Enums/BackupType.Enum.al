enum 50101 "Backup Type ABI" implements Backup
{
    Extensible = true;

    value(1; CSV)
    {
        Caption = 'CSV';
        Implementation = Backup = "Backup CSV ABI";
    }
    value(2; XLSX)
    {
        Caption = 'XLSX';
        Implementation = Backup = "Backup XLSX ABI";
    }
    value(3; JSON)
    {
        Caption = 'JSON';
        Implementation = Backup = "Backup JSON ABI";
    }
    value(4; XML)
    {
        Caption = 'XML';
        Implementation = Backup = "Backup XML ABI";
    }
    value(5; XML2)
    {
        Caption = 'XML2';
        Implementation = Backup = "Backup XML2 ABI";
    }
}