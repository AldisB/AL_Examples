
function drawChart(labels, data) {
    var controlAddIn = document.getElementById("controlAddIn");
    var canvas = document.createElement("canvas");
    canvas.id = "myChart";
    canvas.setAttribute("width", "650"); 
    canvas.setAttribute("height", "550"); 
    controlAddIn.appendChild(canvas);
    var ctx = canvas.getContext('2d'); 
    var myChart = new Chart (ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Balance (LCY)',
                data: data,
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{ 
                    ticks: {
                        beginAtZero: true
                    }
                }]
            }
        }
    });
}