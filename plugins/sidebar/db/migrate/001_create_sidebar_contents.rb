class CreateSidebarContents < ActiveRecord::Migration

    def self.up
        create_table :sidebar_contents do |t|
            t.column :project_id,   :integer, :null => false
            t.column :content_type, :string, :limit => 30, :null => false
            t.column :content,      :text
            t.column :location,     :string, :limit => 30, :null => false
            t.column :url_regexp,   :string
        end
        add_index :sidebar_contents, :project_id, :name => :sidebar_contents_project_id
    end

    def self.down
        drop_table :sidebar_contents
    end

end
