class SidebarContent < ActiveRecord::Base
    belongs_to :project

    validates_presence_of :project, :content_type, :content, :location
    validates_inclusion_of :content_type, :in => %w(text wiki html)
    validates_inclusion_of :location, :in => %w(project issues only_regexp except_regexp)

    def content=(arg)
        if arg.present? && arg.is_a?(Hash)
            case content_type
            when 'text'
                write_attribute(:content, arg['text'])
            when 'wiki'
                write_attribute(:content, arg['wiki'])
            when 'html'
                write_attribute(:content, arg['html'])
            end
        end
    end

    def url_regexp=(arg)
        if arg.present?
            if location == 'only_regexp' || location == 'except_regexp'
                write_attribute(:url_regexp, arg)
            end
        else
            write_attribute(:url_regexp, nil)
        end
    end

protected

    def validate
        if content_type.present? && content_type == 'wiki' && content.present?
            unless project && project.wiki && project.wiki.find_page(content)
                errors.add(:content, :wiki_page_not_found)
            end
        end
    end

end
