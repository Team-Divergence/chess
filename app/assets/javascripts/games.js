$(function() {
  
  // Initialize Firebase
  var config = {
    apiKey: "AIzaSyBPksTx_CuBtYcletVX8e89utAq35cl6hA",
    authDomain: "divergence-chess.firebaseapp.com",
    databaseURL: "https://divergence-chess.firebaseio.com",
    storageBucket: "divergence-chess.appspot.com",
  };
  var fb = firebase.initializeApp(config);
  var database = firebase.database();
  var fbref = database.ref();

  fbref.child("pieces").on('child_changed', function(snapshot) {
    //$('td a').addClass("highlight");
    $('.highlight').removeClass("highlight");
    var key = snapshot.getKey();
    var newX = snapshot.val().current_position_x;
    var newY = snapshot.val().current_position_y;
    var square = $('td[data-x-position=' + newX + '][data-y-position=' + newY + ']');
    var piece = $('a[href$=' + key + ']');
    piece.detach().appendTo(square);
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
        $(ui.helper).css({top: 0,left: 0});
      })
      .done(function(msg) {

        if (droppedOn.find('.ui-draggable').length){
          deadPiece = droppedOn.find('.ui-draggable');
          database.ref(deadPiece.attr("href")).remove();
          droppedOn.find('.ui-draggable').remove();
        }
        $(dropped).detach().css({top: 0,left: 0}).appendTo(droppedOn);
        droppedOn.addClass("highlight");

        database.ref(pieceLink).set({
          current_position_x: x,
          current_position_y: y
        });
      });

    }
  });

});