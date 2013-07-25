module SidebarContentHelper

    def sidebar_content(sidebar, project)
        content = ''
        case sidebar.content_type
        when 'text'
            content = textilizable(sidebar.content)
        when 'wiki'
            if project && project.wiki
                page = project.wiki.find_page(sidebar.content)
                if page
                    content = textilizable(page.text)
                end
            end
        when 'html'
            content = sidebar.content
        end
        return content
    end

end
