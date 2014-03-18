module OnFailureDoThis
  def run_action_rescued(action = nil)
    Chef::Log.info "This new run_action: #{new_resource.on_failure_struct.inspect}"
    run_action_unrescued(action)
  rescue Exception => e
    Chef::Log.info "Rescuing exception: #{e.inspect}"
    if new_resource.instance_variable_defined?('@on_failure_struct'.to_sym)
      Chef::Log.info "On failure defined. Perfomring requested tasks before raising the exception"
      instance_exec(new_resource, &new_resource.on_failure_struct.block)
    end
    raise e
  end

  def notify(action, notifying_resource)
    run_context.resource_collection.find(notifying_resource).run_action(action)
  end

  def self.included(base)
    Chef::Log.info "On Failure Included to #{base.inspect}"
    base.class_eval do
      alias_method :run_action_unrescued, :run_action
      alias_method :run_action, :run_action_rescued
    end
  end

  unless(Chef::Provider.ancestors.include?(OnFailureDoThis))
    Chef::Provider.send(:include, OnFailureDoThis)
  end
end

class Chef::Resource
  class OnFailure < Struct.new(:options, :exceptions, :block)
  end

  attr_accessor :on_failure_struct

  def on_failure(args = nil, &block)
    Chef::Log.info "On failure called with options: #{args.inspect} and a block: #{block.inspect}"
    options = args if args.is_a?(Hash)
    exceptions = args if args.is_a?(Array)
    self.instance_variable_set("@on_failure_struct".to_sym, OnFailure.new(options || {}, exceptions || [], block))
  end
end
