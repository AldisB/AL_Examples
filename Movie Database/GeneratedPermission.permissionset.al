permissionset 50101 GeneratedPermission
{
    Caption = 'Movie Database permissions', Locked = true;
    Access = Internal;
    Assignable = true;
    Permissions = tabledata "Movie ABI" = RIMD,
        table "Movie ABI" = X,
        page "Movies List ABI" = X,
        page "Movies Card ABI" = X,
        page "Movie Poster ABI" = X,
        page "API - Movies ABI" = X,
        page "Search by Title ABI" = X,
        codeunit "OMDB Mgt." = X,
        tabledata "OMDB Setup ABI" = RIMD,
        table "OMDB Setup ABI" = X,
        page "OMDB Setup ABI" = X,
        codeunit "Backup CSV ABI" = X,
        codeunit "Backup JSON ABI" = X,
        codeunit "Backup XML ABI" = X,
        codeunit "Backup XLSX ABI" = X,
        codeunit "Backup XML2 ABI" = X,
        codeunit "Excel Helper ABI" = X,
        codeunit SendStreamToBrowser = X,
        codeunit SendStreamToEmail = X,
        codeunit SendStreamToHTTP = X;
}