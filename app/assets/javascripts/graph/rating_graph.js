var chart = $('#rating_chart')
var r = new Raphael(chart[0]);
r.linechart(0,0,chart.width(),chart.width()/2,[0,1,2,3,4,5],[0,2,3,5,4,3], {axis: '0 0 1 1', shade: true, axisxstep: 20, axisystep: 4 });
