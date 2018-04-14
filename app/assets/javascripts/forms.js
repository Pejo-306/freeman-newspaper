function expandInputField() {
    var font_size;
    var parent_container;
    var value_length_in_px;

    parent_container = this.parentNode;
    font_size = window.getComputedStyle(this, null).getPropertyValue('font-size');
    font_size = parseInt(font_size);
    value_length_in_px = (this.value.length + 1) * font_size / 2;
    if (value_length_in_px > parseInt(parent_container.offsetWidth)) {
        this.style.width = parent_container.offsetWidth + 'px';
    } else if (this.value.length > this.placeholder.length - 1) {
        this.style.width = ((this.value.length + 1) * font_size / 2) + 'px';
    } else {
        this.style.width = (this.placeholder.length * font_size / 2) + 'px';
    }
}

function expandTextArea(min_height) {
    this.style.height = 0;
    if (parseInt(this.scrollHeight) < min_height) {
        this.style.height = min_height + 'px';
    } else {
        this.style.height = this.scrollHeight + 'px';
    }
}

function getMinTextareaHeight(jq_identifier) {
    var min_height;

    jq_identifier.css('height', '0');
    min_height = $('main').height() - $('main article').height() - $('.push').height();
    if (jq_identifier[0].scrollHeight > min_height) {
        jq_identifier.css('height', jq_identifier[0].scrollHeight);
    } else {
        jq_identifier.css('height', min_height);
    }
    return min_height;
}

$(function() {
    var content_field;
    var min_textarea_height;

    $('#title-field').on('input', expandInputField);

    content_field = $('#content-field');
    content_field.css('overflow', 'hidden');
    min_textarea_height = getMinTextareaHeight(content_field);
    content_field.css('height', min_textarea_height);
    $(window).resize(function() {
        min_textarea_height = getMinTextareaHeight(content_field);
    });
    content_field.on('input', function() {
        expandTextArea.call(this, min_textarea_height);
    });
});

