controladdin "Chart Control"
{
    RequestedHeight = 600;
    RequestedWidth = 700;
    MinimumHeight = 400;
    MaximumHeight = 700;
    MinimumWidth = 700;
    MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts =
        'https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js',
        './JavaScripts/chartbc.js';
    // StyleSheets =
    //     'style.css';
    StartupScript = './JavaScripts/start.js';
    // RecreateScript = 'recreateScript.js';
    // RefreshScript = 'refreshScript.js';
    // Images =
    //     'image1.png',
    //     'image2.png';

    procedure drawChart(CustomerNameJsonArray: JsonArray; CustomerBalanceJsonArray: JsonArray)

    event ControlReady()
}