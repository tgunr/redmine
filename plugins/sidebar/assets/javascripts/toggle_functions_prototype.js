function toggle_sidebar_form_visibility(value) {
    form = $('sidebar-content-data');
    text = $('content-text');
    wiki = $('content-wiki');
    html = $('content-html');
    preview = $('preview-link');

    switch (value) {
        case 'text':
            Element.show(form);
            Element.show(text);
            Element.hide(wiki);
            Element.hide(html);
            Element.show(preview);
            break;
        case 'wiki':
            Element.show(form);
            Element.hide(text);
            Element.show(wiki);
            Element.hide(html);
            Element.show(preview);
            break;
        case 'html':
            Element.show(form);
            Element.hide(text);
            Element.hide(wiki);
            Element.show(html);
            Element.show(preview);
            break;
        default:
            Element.hide(form);
            Element.hide(text);
            Element.hide(wiki);
            Element.hide(html);
            Element.hide(preview);
            break;
    }
}

function toggle_url_regexp_visibility(value) {
    regexp = $('url-regexp');
    field = $('sidebar_url_regexp');

    switch (value) {
        case 'only_regexp':
        case 'except_regexp':
            Element.show(regexp);
            break;
        default:
            Element.hide(regexp);
            break;
    }
}

function toggle_sidebar_pages_visibility(value) {
    pages = $('non-sidebar-pages');

    switch (value) {
        case 'project':
            Element.hide(pages);
            break;
        default:
            Element.show(pages);
            break;
    }
}
