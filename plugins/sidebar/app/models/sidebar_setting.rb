class SidebarSetting < ActiveRecord::Base
    belongs_to :project

    serialize :pages, Array

    def pages=(list)
        available_pages = SidebarPage.available_pages.collect{ |page| page.name.to_s }
        write_attribute(:pages, list ? list.select{ |page| available_pages.include?(page.to_s) } : [])
    end

    def enabled?(page)
        settings = Setting.plugin_sidebar

        case settings['policy']
        when 'global'
            settings['pages'] && settings['pages'].include?(page.to_s)
        when 'disable'
            available?(page) && (!pages || pages.include?(page.to_s))
        when 'configurable'
            available?(page) && pages && pages.include?(page.to_s)
        when 'project'
            pages && pages.include?(page.to_s)
        else
            false
        end
    end

    def available?(page)
        settings = Setting.plugin_sidebar

        case settings['policy']
        when 'project'
            true
        when 'disable', 'configurable'
            settings['pages'] && settings['pages'].include?(page.to_s)
        else
            false
        end
    end

end
