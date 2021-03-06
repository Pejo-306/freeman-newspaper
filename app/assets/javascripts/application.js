// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require_tree ./application
//= require_tree .

/*
 * check if function element exists (is present in the DOM
 */
jQuery.fn.exists = function() { 
  return this.length > 0 
}

String.prototype.is_blank = function() {
    return (this.length === 0 || !this.trim());
}

$(document).on('turbolinks:load', function() {
  // enable Bootstrap 4 tooltips
  $('[data-toggle="tooltip"]').tooltip();
});

