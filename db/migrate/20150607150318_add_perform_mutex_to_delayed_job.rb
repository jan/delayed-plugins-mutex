class AddPerformMutexToDelayedJob < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :perform_mutex, :string
    add_column :delayed_jobs, :perform_limit, :integer, null: false, default: 1
    add_index  :delayed_jobs, :perform_mutex, name: :idx_delayed_jobs_perform_mutex
  end
end
