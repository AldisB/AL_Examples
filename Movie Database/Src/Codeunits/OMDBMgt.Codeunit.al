codeunit 50101 "OMDB Mgt."
{
    trigger OnRun()
    var
        SearchByTitle: Page "Search by Title ABI";
    begin
        if SearchByTitle.RunModal() <> Action::OK then
            exit;

        GetSearchResultList(SearchByTitle.GetMovieTitle());
    end;

    internal procedure GetSearchResultList(SearchString: Text)
    var
        JsonResult: Text;
        RequestURI: SecretText;
        APIKey: SecretText;
    begin
        if SearchString = '' then
            exit;

        OMDBSetup.Get();
        APIKey := OMDBSetup."API Key";
        RequestURI := SecretText.SecretStrSubstNo(OMDBSetup."API URL", APIKey, SearchString); // http://www.omdbapi.com/?apikey=%1&s=%2
        JsonResult := SendRequest(RequestURI);

        if JsonResult = '' then
            exit;

        CreateResultList(JsonResult);
    end;

    local procedure SendRequest(RequestURI: SecretText) ResponseText: Text
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        ErrorBuilder: TextBuilder;
        CallFailedLbl: Label 'The call to the web service failed.';
    begin
        HttpRequestMessage.SetSecretRequestUri(RequestURI);
        HttpRequestMessage.Method('GET');

        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error(CallFailedLbl);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            exit(ResponseText);
        end;

        ErrorBuilder.AppendLine('The web service returned an error message:');
        ErrorBuilder.Append(('Status code: '));
        ErrorBuilder.AppendLine(Format(HttpResponseMessage.HttpStatusCode()));
        ErrorBuilder.Append(('Description:'));
        ErrorBuilder.AppendLine(HttpResponseMessage.ReasonPhrase());
        Error(ErrorBuilder.ToText());
    end;

    local procedure CreateResultList(JsonResult: Text)
    var
        ResultJsonArray: JsonArray;
        ResultJsonToken, MoviesJsonToken, MovieValueJsonToken : JsonToken;
        ResultJsonObject: JsonObject;
        MovieTitles: TextBuilder;
        Options, imdbID : Text;
        Selected: Integer;
        Text002Lbl: Label 'Choose one of the following options:';
    begin
        if not ResultJsonToken.ReadFrom(JsonResult) then
            exit;

        if not ResultJsonToken.SelectToken('Search', MoviesJsonToken) then
            exit;

        ResultJsonArray := MoviesJsonToken.AsArray();
        Clear(MoviesJsonToken);

        foreach MoviesJsonToken in ResultJsonArray do
            if MoviesJsonToken.IsObject() then begin
                ResultJsonObject := MoviesJsonToken.AsObject();
                ResultJsonObject.Get('Title', MovieValueJsonToken);
                MovieTitles.Append(MovieValueJsonToken.AsValue().AsText() + ',');
            end;

        Options := MovieTitles.ToText().TrimEnd(',');
        // Sets the default to option 3  
        Selected := Dialog.StrMenu(Options, 3, Text002Lbl);
        if Selected = 0 then
            exit;

        ResultJsonArray.Get(Selected - 1, MoviesJsonToken);
        ResultJsonObject := MoviesJsonToken.AsObject();
        ResultJsonObject.Get('imdbID', MovieValueJsonToken);
        imdbID := MovieValueJsonToken.AsValue().AsText();

        GetMovieDetails(imdbID);
    end;

    local procedure GetMovieDetails(imdbID: Text)
    var
        JsonResult: Text;
        RequestURI: SecretText;
        APIKey: SecretText;
    begin
        if imdbID = '' then
            exit;

        OMDBSetup.Get();
        APIKey := OMDBSetup."API Key";
        RequestURI := SecretText.SecretStrSubstNo(OMDBSetup."Movie Details URL", APIKey, imdbID); // http://www.omdbapi.com/?apikey=%1&i=%2
        JsonResult := SendRequest(RequestURI);

        if JsonResult = '' then
            exit;

        InsertMovie(JsonResult, imdbID);
    end;

    local procedure InsertMovie(JsonResult: Text; imdbID: Text)
    var
        Movie: Record "Movie ABI";
        ResultJsonToken: JsonToken;
    begin
        if JsonResult = '' then
            exit;

        if not ResultJsonToken.ReadFrom(JsonResult) then
            exit;

        Movie.SetRange("No.", imdbID);
        if not Movie.IsEmpty then
            exit;

        Movie.Init();
        Movie."No." := CopyStr(UpperCase(imdbID), 1, MaxStrLen(Movie."No."));
        Movie.Title := CopyStr(GetJsonValue('Title', ResultJsonToken), 1, MaxStrLen(Movie.Title));
        if Evaluate(Movie.Year, GetJsonValue('Year', ResultJsonToken)) then;
        Movie.Genre := CopyStr(GetJsonValue('Genre', ResultJsonToken), 1, MaxStrLen(Movie.Genre));
        Movie.Actors := CopyStr(GetJsonValue('Actors', ResultJsonToken), 1, MaxStrLen(Movie.Actors));
        Movie.Production := CopyStr(GetJsonValue('Production', ResultJsonToken), 1, MaxStrLen(Movie.Production));
        Movie.Description := CopyStr(GetJsonValue('Plot', ResultJsonToken), 1, MaxStrLen(Movie.Description));
        if Evaluate(Movie.Score, GetJsonValue('imdbRating', ResultJsonToken)) then;
        GetPoster(GetJsonValue('Poster', ResultJsonToken), Movie);
        Movie.Insert(false);

    end;

    local procedure GetJsonValue(JsonKey: Text; ResultJsonToken: JsonToken): Text
    var
        Value: Text;
        ResultJsonObject: JsonObject;
        DetailsJsonToken: JsonToken;
    begin
        ResultJsonObject := ResultJsonToken.AsObject();
        if not ResultJsonObject.Get(JsonKey, DetailsJsonToken) then
            exit('');

        Value := DetailsJsonToken.AsValue().AsText();
        exit(Value);
    end;

    local procedure GetPoster(url: Text; var Movie: Record "Movie ABI")
    var
        InStream: InStream;
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
    begin
        HttpClient.Get(url, HttpResponseMessage);
        HttpResponseMessage.Content.ReadAs(InStream);
        Movie.Image.ImportStream(InStream, Movie.Title, 'image/jpeg');
    end;

    var
        [NonDebuggable]
        OMDBSetup: Record "OMDB Setup ABI";
}
