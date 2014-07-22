$(function() {

  var DELETE_PLARER_URL = "/remove/player/";
  $(".oepn-confirm-dialog").on("click", function() {
    $("#confirm-dialog").modal("show");
    $("#confirm-ok-button")
      .attr("href", DELETE_PLARER_URL + $(this).data("playerid"));
  });

});
