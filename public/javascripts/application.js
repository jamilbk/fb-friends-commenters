"use strict";

jQuery(window).ready(function () {
  $('.friend').click(function () {
    $('#content').html("<div id='progress'><progress>LOADING...</progress></div>");
  });
});
