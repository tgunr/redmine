function toggle_download_form(field) {
    if (field.checked) {
        Element.hide('download-button');
        Element.hide('download-button-settings');
    } else {
        Element.show('download-button');
        Element.show('download-button-settings');
    }
}

function toggle_download_external_url(field) {
    if (field.value == '-1') {
        Element.show('download-button-url');
    } else {
        Element.hide('download-button-url');
    }
    if ((field.value != '-1') && (field.value != '0')) {
        Element.show('download-button-hint');
    } else {
        Element.hide('download-button-hint');
    }
}

function update_download_button(field, project_name, version_name, default_label, default_url, default_url_prefix) {
    if (field.name == 'download[label]') {
        var label;
        if (!field.getValue().blank()) {
            label = field.getValue();
        } else {
            label = default_label;
        }
        $('download-button').down('.icon-download').childNodes[0].nodeValue = label;
    } else if (field.name == 'download[file_id]') {
        if (field.getValue() == '-1') {
            $('download-button').down('a').href = $('download_url').getValue();
        } else if (field.getValue() == '0') {
            $('download-button').down('a').href = default_url;
        } else {
            $('download-button').down('a').href = default_url_prefix + field.getValue() + '/' + field.options[field.selectedIndex].text;
        }
    } else if (field.name == 'download[url]') {
        $('download-button').down('a').href = $('download_url').getValue();
    } else {
        var name = $('download_package');
        var version = $('download_include_version');
        var package;
        if (!name.getValue().blank()) {
            package = name.getValue();
        } else {
            package = project_name;
        }
        if (version.checked && (version_name != '')) {
            package += " " + version_name;
        }
        $('download-button').down('.version').update(package);
    }
}
