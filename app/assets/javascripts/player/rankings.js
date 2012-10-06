var PingPong = PingPong || {};
PingPong.initRankings = function() {
    all_tabs = '#nav-ranking, #nav-possibility-matrix, #nav-history-graph, #nav-recent-games, #nav-player-edit';
    all_content = '#ranking, #possibility-matrix, #history-graph, #player-edit, #recent-games, #new-game, #rankings, #new-player';
    all_nav = '#nav-rankings, #nav-newgame, #nav-newplayer';

    $(all_tabs).removeClass('hide');

    $('#nav-ranking a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-ranking').addClass('active');
        $(all_content).addClass('hide');
        $('#rankings, #ranking, #recent-games').removeClass('hide');
    })

    $('#nav-possibility-matrix a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-possibility-matrix').addClass('active');
        $(all_content).addClass('hide');
        $('#rankings, #possibility-matrix').removeClass('hide');
    })

    $('#nav-history-graph a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-history-graph').addClass('active');
        $(all_content).addClass('hide');
        $('#rankings, #history-graph').removeClass('hide');
    })

    $('#nav-recent-games a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-recent-games').addClass('active');
        $(all_content).addClass('hide');
        $('#rankings, #recent-games').removeClass('hide');
    })

    $('#nav-player-edit a').click(function(e) {
        e.preventDefault();
        $(all_tabs).removeClass('active');
        $('#nav-player-edit').addClass('active');
        $(all_content + ', #recent-games').addClass('hide');
        $('#player-edit').removeClass('hide');
    })

    $('#nav-rankings a').click(function(e) {
        e.preventDefault();
        $('#nav-ranking a').click();
        $(all_nav).removeClass('active');
        $('#nav-rankings').addClass('active');
    });

    $('#nav-newgame a').click(function(e) {
        e.preventDefault();
        $(all_nav).removeClass('active');
        $('#nav-newgame').addClass('active');
        $(all_content).addClass('hide');
        $('#new-game').removeClass('hide');
    });

    $('#nav-newplayer a').click(function(e) {
        e.preventDefault();
        $(all_nav).removeClass('active');
        $('#nav-newplayer').addClass('active');
        $(all_content).addClass('hide');
        $('#new-player').removeClass('hide');
    });

};
