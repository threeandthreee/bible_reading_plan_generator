$(document).ready(function(){
  let trad = ace.edit("trad-editor", {mode: 'ace/mode/yaml'})
  let bala = ace.edit("bala-editor", {mode: 'ace/mode/yaml'})
  let simp = ace.edit("simp-editor", {mode: 'ace/mode/yaml'})
  let opin = ace.edit("opin-editor", {mode: 'ace/mode/yaml'})
  let cust = ace.edit("cust-editor", {mode: 'ace/mode/yaml'})


  $.ajax({ url: "/blueprints/traditional.yml" })
    .then(function(data) {
      trad.session.setValue(data)
    })
  $.ajax({ url: "/blueprints/balanced.yml" })
    .then(function(data) {
      bala.session.setValue(data)
    })
  $.ajax({ url: "/blueprints/simple.yml" })
    .then(function(data) {
      simp.session.setValue(data)
    })
  $.ajax({ url: "/blueprints/opinionated.yml" })
    .then(function(data) {
      opin.session.setValue(data)
    })

  $('#gen-btn').click(function(){
    let data
    let activeId = $('.tab-pane.active').attr('id')
    if(activeId == 'trad')
      data = trad.getValue()
    else if(activeId == 'bala')
      data = bala.getValue()
    else if(activeId == 'simp')
      data = simp.getValue()
    else if(activeId == 'opin')
      data = opin.getValue()
    else if(activeId == 'cust')
      data = cust.getValue()

    $.ajax({
      url: "/",
      method: "POST",
      data: data
    }).then(function(data) {
      $('.output-box textarea').val(data)
    }, function(err) {
      $('.output-box textarea').val('Error. Something seems to be wrong with your blueprint.')
    })
  })

  $("#copy-btn").click(function(){
    $(".output-box textarea")[0].select()
    document.execCommand('copy')
  })
})