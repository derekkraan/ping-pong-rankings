var chart = $('#rating_chart')
var r = new Raphael(chart[0]);

var x_values = $(rating_history).map(function(index,value) {
    return index;
}).toArray();
var y_values = $(rating_history).map(function(index,value) {
    return value.rating;
}).toArray();

r.linechart(0, 0, chart.width(), chart.width()/2, x_values, y_values, {axis: '0 0 1 1', shade: true, axisxstep: 20, axisystep: 4 });
