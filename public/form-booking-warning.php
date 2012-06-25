<?php session_start(); ?>
<div class='warning'><p>translation missing: en.contents.booking-form.booking-warning</p></div>
<script type='text/javascript'>
  //<![CDATA[
    $('.field').removeClass('error');
    $(<?php echo $_SESSION["fields_with_errors"]; ?>).each(function(i, el) {
      $('input[name*=' + el + ']').parent().addClass('error')
    });
  //]]>
</script>
