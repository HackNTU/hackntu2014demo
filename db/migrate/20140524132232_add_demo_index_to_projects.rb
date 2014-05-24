class AddDemoIndexToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :demo_index, :integer
  end
end
