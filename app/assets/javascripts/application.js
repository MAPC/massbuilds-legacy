// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require leaflet
//= depend_on_asset "layers.png"
//= depend_on_asset "layers-2x.png"
//= require semantic_ui/semantic_ui
//= require_tree .

$(document).ready(function() {
  semanticInitializers();
});

$( document ).on('page:load',function() {
  semanticInitializers();
});

function semanticInitializers() {
  $('.ui.dropdown').dropdown();
  $('img.contributor').popup();
  $('.button').popup();
  $('.menu .item').tab();
  $('.message .close')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade');
    });
  $('.launch-modal').on('click', function(){
    // Get the data-modal attribute containing the id of the modal
    // we want to launch.
    modal_id = $(this).attr('data-modal');
    $('#' + modal_id + '.modal').modal('show');
  });
}
