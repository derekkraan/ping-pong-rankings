$(document).ready(function() {
    all_tabs = '#nav-ranking, #nav-possibility-matrix, #nav-history-graph, #nav-recent-games, #nav-player-edit';
    all_content = '#ranking, #possibility-matrix, #history-graph, #player-edit, #recent-games';

    $(all_tabs).removeClass('hide');

    $('#nav-ranking a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-ranking').addClass('active');
        $(all_content).addClass('hide');
        $('#ranking, #recent-games').removeClass('hide');
    })

    $('#nav-possibility-matrix a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-possibility-matrix').addClass('active');
        $(all_content).addClass('hide');
        $('#possibility-matrix').removeClass('hide');
    })

    $('#nav-history-graph a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-history-graph').addClass('active');
        $(all_content).addClass('hide');
        $('#history-graph').removeClass('hide');
    })

    $('#nav-recent-games a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-recent-games').addClass('active');
        $(all_content).addClass('hide');
        $('#recent-games').removeClass('hide');
    })

    $('#nav-player-edit a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-player-edit').addClass('active');
        $(all_content + ', #recent-games').addClass('hide');
        $('#player-edit').removeClass('hide');
    })

});
