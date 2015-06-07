class AddEnqueueMutexToDelayedJob < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :enqueue_mutex, :string
    add_column :delayed_jobs, :enqueue_limit, :integer, null: false, default: 1
    add_index  :delayed_jobs, :enqueue_mutex, name: :idx_delayed_jobs_enqueue_mutex
  end
end
