$(document).ajaxComplete (event, request) ->
  msg = request.getResponseHeader("X-Message")
  alert_type = 'alert-success'
  alert_type = 'alert-danger' unless request.getResponseHeader("X-Message-Type").indexOf("danger") is -1
 
  unless request.getResponseHeader("X-Message-Type").indexOf("keep") is 0
    #add flash message if there is any text to display
    $('#flash_hook').replaceWith("<div id='flash_hook'>
  <div aria-hidden='true' aria-labelledby='mySmallModalLabel' class='modal' id='message_modal' role='dialog' tabindex='-1'>
    <div class='modal-dialog'>
      <div class='modal-content modal-" +alert_type+ "'>
        <div class='modal-body'>
          " + msg + " 
          <button class='close' data-dismiss='modal' type='button'>
            <span aria-hidden='true'>
              <span class='glyphicon glyphicon-remove-circle'></span>
            </span>
            <span class='sr-only'>
              Close
            </span>
          </button>
        </div>
      </div>
    </div>
  </div>
</div>") if msg
    $('#message_modal').modal('toggle') if msg
    setTimeout (->
      $('#message_modal').modal 'hide'
      return
    ), 2000 if msg
    ###$("#flash_hook").replaceWith("<div id='flash_hook'>
          <div class='alert " + alert_type + "'>
            <button type='button' class='close' data-dismiss='alert'>&times;</button>
            " + msg + "
          </div>
        </div>") if msg
    ###
    #delete the flash message (if it was there before) when an ajax request returns no flash message
    $("#flash_hook").replaceWith("<div id='flash_hook'></div>") unless msg