class CreateDownloadButtons < ActiveRecord::Migration

    def self.up
        create_table :download_buttons do |t|
            t.column :project_id,      :integer, :null => false
            t.column :disabled,        :boolean, :default => false, :null => false
            t.column :label,           :string, :limit => 30, :null => true, :default => nil
            t.column :package,         :string, :limit => 30, :null => true, :default => nil
            t.column :include_version, :boolean, :default => true, :null => false
            t.column :file_id,         :integer, :null => true, :default => 0
            t.column :url,             :string, :limit => 255, :null => true, :default => nil
        end
        add_index :download_buttons, :project_id, :name => :download_buttons_project_id
    end

    def self.down
        drop_table :download_buttons
    end

end
