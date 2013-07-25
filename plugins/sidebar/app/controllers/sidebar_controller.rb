class SidebarController < ApplicationController
    menu_item :settings, :only => :pages

    before_filter :find_project
    before_filter :find_sidebar_content, :except => :pages
    before_filter :find_sidebar_visibility, :only => :pages
    before_filter :authorize

    def edit
        if params[:sidebar][:content_type].present?
            if @sidebar
                if @sidebar.update_attributes(params[:sidebar])
                    flash[:notice] = l(:notice_successful_update)
                end
            else
                attrs = params[:sidebar].dup
                @sidebar = SidebarContent.new(attrs.merge(:project => @project))
                if @sidebar.save
                    flash[:notice] = l(:notice_successful_create)
                end
            end
        else
            if @sidebar
                if @sidebar.destroy
                    flash[:notice] = l(:notice_successful_delete)
                    @sidebar = nil
                end
            end
        end

        respond_to do |format|
            format.html do
                redirect_to(:controller => 'projects', :action => 'settings', :id => @project, :tab => 'sidebar', :sidebar => params[:sidebar])
            end
            format.js do
                if Rails::VERSION::MAJOR >= 3 && Rails::VERSION::MINOR >= 1
                    @notice = flash.discard(:notice)
                else
                    @notice = flash.delete(:notice)
                    render(:update) do |page|
                        page.replace_html('tab-content-sidebar', :partial => 'projects/settings/sidebar')
                    end
                end
            end
        end
    end

    def preview
        if params[:sidebar]
            @previewed = @sidebar
            case params[:sidebar][:content_type]
            when 'text'
                @text = params[:sidebar][:content] ? params[:sidebar][:content][:text] : nil
                render(:partial => 'common/preview')
            when 'wiki'
                page = @project && @project.wiki && params[:sidebar][:content] ?
                       @project.wiki.find_page(params[:sidebar][:content][:wiki]) : nil
                @text = ''
                if page
                    @text = page.text
                end
                render(:partial => 'common/preview')
            when 'html'
                html = '<fieldset class="preview">'
                html << '<legend>' + l(:label_preview) + '</legend>'
                if params[:sidebar][:content]
                    html << params[:sidebar][:content][:html]
                end
                html << '</fieldset>'
                render(:text => html)
            else
                render_403
            end
        end
    end

    def pages
        @visibility ||= SidebarSetting.new(:project => @project)
        if request.post?
            @visibility.pages = params[:pages]
            if @visibility.save
                flash[:notice] = l(:notice_successful_update)
            end
            redirect_back_or_default(:controller => 'projects', :action => 'settings', :id => @project, :tab => 'sidebar')
        end
    end

private

    def find_project
        @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render_404
    end

    def find_sidebar_content
        @sidebar = SidebarContent.find_by_project_id(@project.id)
    end

    def find_sidebar_visibility
        @visibility = SidebarSetting.find_by_project_id(@project.id)
    end

end
