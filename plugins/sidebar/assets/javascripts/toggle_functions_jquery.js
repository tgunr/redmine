function toggle_sidebar_form_visibility(value) {
    form = $('#sidebar-content-data');
    text = $('#content-text');
    wiki = $('#content-wiki');
    html = $('#content-html');
    preview = $('#preview-link');

    switch (value) {
        case 'text':
            form.show();
            text.show();
            wiki.hide();
            html.hide();
            preview.show();
            break;
        case 'wiki':
            form.show();
            text.hide();
            wiki.show();
            html.hide();
            preview.show();
            break;
        case 'html':
            form.show();
            text.hide();
            wiki.hide();
            html.show();
            preview.show();
            break;
        default:
            form.hide();
            text.hide();
            wiki.hide();
            html.hide();
            preview.hide();
            break;
    }
}

function toggle_url_regexp_visibility(value) {
    regexp = $('#url-regexp');
    field = $('#sidebar_url_regexp');

    switch (value) {
        case 'only_regexp':
        case 'except_regexp':
            regexp.show();
            break;
        default:
            regexp.hide();
            break;
    }
}

function toggle_sidebar_pages_visibility(value) {
    pages = $('#non-sidebar-pages');

    switch (value) {
        case 'project':
            pages.hide();
            break;
        default:
            pages.show();
            break;
    }
}
