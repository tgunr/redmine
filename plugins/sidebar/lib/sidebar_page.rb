class SidebarPage
    include Redmine::I18n

    attr_reader :name, :urls, :caption

    def initialize(name, urls, options = {})
        @name = name
        @urls = urls
        @caption = l(options[:caption] || "label_#{name}")
    end

    def self.available_pages
        if @available_pages
            @available_pages
        else
            @available_pages = [
                self.new(:news_list,        { :news => :index }),
                self.new(:news,             { :news => :show }),
                self.new(:version,          { :versions => :show }),
                self.new(:files_list,       { :files => :index, :projects => :list_files }),
                self.new(:new_issue,        { :issues => :new }, :caption => :label_issue_new),
                self.new(:forums_list,      { :boards => :index }),
                self.new(:forum,            { :boards => :show, :messages => :show }, :caption => :label_board),
                self.new(:repository,       { :repositories => :show }),
                self.new(:revisions,        { :repositories => [ :changes, :revisions ] }, :caption => :label_revision_plural),
                self.new(:repository_entry, { :repositories => :entry }),
                self.new(:annotation,       { :repositories => :annotate }),
                self.new(:differences_view, { :repositories => :diff }),
                self.new(:settings,         { :projects => :settings })
            ]
        end
    end

    def self.sidebar_enabled?(path, project)
        unless @path_to_page_cache
            @path_to_page_cache = {}
            self.available_pages.each do |page|
                page.urls.each do |controller, actions|
                    if actions.is_a?(Array)
                        actions.each do |action|
                            @path_to_page_cache["#{controller}/#{action}"] = page
                        end
                    else
                        @path_to_page_cache["#{controller}/#{actions}"] = page
                    end
                end
            end
        end

        sidebar_page = @path_to_page_cache[path]
        if sidebar_page
            global_settings = Setting.plugin_sidebar
            project_settings = project ? SidebarSetting.find_by_project_id(project.id) : nil

            case global_settings['policy']
            when 'global'
                global_settings['pages'] && global_settings['pages'].include?(sidebar_page.name.to_s)
            when 'disable'
                project_settings ? project_settings.enabled?(sidebar_page.name) : (global_settings['pages'] && global_settings['pages'].include?(sidebar_page.name.to_s))
            when 'configurable', 'project'
                project_settings && project_settings.enabled?(sidebar_page.name)
            else
                false
            end
        else
            false
        end
    end

end
