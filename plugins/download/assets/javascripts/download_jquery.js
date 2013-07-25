function toggle_download_form(field) {
    if (field.checked) {
        $('#download-button').hide();
        $('#download-button-settings').hide();
    } else {
        $('#download-button').show();
        $('#download-button-settings').show();
    }
}

function toggle_download_external_url(field) {
    if (field.value == '-1') {
        $('#download-button-url').show();
    } else {
        $('#download-button-url').hide();
    }
    if ((field.value != '-1') && (field.value != '0')) {
        $('#download-button-hint').show();
    } else {
        $('#download-button-hint').hide();
    }
}

function update_download_button(field, project_name, version_name, default_label, default_url, default_url_prefix) {
    if (field.name == 'download[label]') {
        var label;
        if ($(field).val() != '') {
            label = $(field).val();
        } else {
            label = default_label;
        }
        $('#download-button').find('.icon-download').contents().first()[0].textContent = label;
    } else if (field.name == 'download[file_id]') {
        if ($(field).val() == '-1') {
            $('#download-button').find('a').attr('href', $('#download_url').val());
        } else if ($(field).val() == '0') {
            $('#download-button').find('a').attr('href', default_url);
        } else {
            $('#download-button').find('a').attr('href', default_url_prefix + $(field).val() + '/' + field.options[field.selectedIndex].text);
        }
    } else if (field.name == 'download[url]') {
        $('#download-button').find('a').attr('href', $('#download_url').val());
    } else {
        var name = $('#download_package');
        var version = $('#download_include_version');
        var package;
        if (name.val() != '') {
            package = name.val();
        } else {
            package = project_name;
        }
        if (version.is(':checked') && (version_name != '')) {
            package += " " + version_name;
        }
        $('#download-button').find('.version').html(package);
    }
}
