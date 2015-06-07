module Delayed::Plugins::Mutex
  class Engine < ::Rails::Engine
    isolate_namespace DelayedPluginsMutex
  end
end
