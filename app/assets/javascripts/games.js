$(function() {

  var fb = firebase.initializeApp({databaseURL: "https://divergence-chess.firebaseio.com"});
  var database = firebase.database();
  var fbref = database.ref();

  $('td a').each(function(index) {
    database.ref($(this).attr("href")).set({
      current_position_x: $(this).parent().data('x-position'),
      current_position_y: $(this).parent().data('y-position')
    });
  });

  fbref.child("pieces").on('child_changed', function(snapshot) {
    $('.highlight').removeClass("highlight");
    var key = snapshot.getKey();
    var newX = snapshot.val().current_position_x;
    var newY = snapshot.val().current_position_y;
    var piece_color = snapshot.val().p_color;
    if (snapshot.val().p_color == 'white'){
      var opp_color = 'Black';
    } else {
      var opp_color = 'White';
    }
    var square = $('td[data-x-position=' + newX + '][data-y-position=' + newY + ']');
    var piece = $("a[href='/pieces/" + key + "']");

    if (square.find('.ui-draggable').length){
      deadPiece = square.find('.ui-draggable');
      database.ref(deadPiece.attr("href")).remove();
      deadPiece.remove();
    }
    piece.detach().css({top: 0,left: 0}).appendTo(square);
    if (snapshot.val().promoted == 'Queen'){
      piece.children().attr("alt", piece_color + ' queen');
      piece.children().attr("src", '/assets/' + piece_color + '-queen.png');
    }
    square.addClass("highlight");
    $('#game-message').html(opp_color + ' turn');

  });

  $('td a').click(function(ev) {
    ev.preventDefault();
  });

  $('td a').mousedown(function() {
    $('td a').not(this).css('z-index', '100');
    $(this).css('z-index', '1000');
    $('.highlight').removeClass("highlight");
    $(this).parent().addClass("highlight");
  });

  $('td a').draggable({
    revert: "invalid",
    revertDuration: 0
  });

  $('td').droppable({
    drop: function(ev, ui) {
      var dropped = ui.draggable;
      var droppedOn = $(this);
      var pieceLink = dropped.attr("href");
      var x = droppedOn.data("x-position");
      var y = droppedOn.data("y-position");

      $.post(pieceLink, {
        _method: "PUT",
        piece: {
          current_position_x: x,
          current_position_y: y
        }
      })
      .fail(function(response) {
        var msg = response.responseText;
        $('#game-message').html(msg);
        $(ui.helper).css({top: 0,left: 0});
      })
      .done(function(msg) {
        $('#game-message').html(msg);
      });

    }
  });

});
