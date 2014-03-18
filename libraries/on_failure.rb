module OnFailureDoThis
  def run_action_rescued(action = nil)
    run_action_unrescued(action)
  rescue Exception => e
    Chef::Log.info "Rescuing exception: #{e.inspect}"
    if new_resource.instance_variable_defined?('@on_failure_struct'.to_sym) &&
      (new_resource.on_failure_struct.exceptions.any? { |klass| e.is_a?(klass) } ||
       new_resource.on_failure_struct.exceptions.empty?)
      #Chef::Log.info "This new run_action: #{new_resource.on_failure_struct.inspect}"
      Chef::Log.info "On failure defined. Perfomring requested tasks before raising the exception"
      instance_exec(new_resource, &new_resource.on_failure_struct.block)
      if new_resource.on_failure_struct.options[:retries] > 0
        new_resource.on_failure_struct.options[:retries] -= 1
        Chef::Log.info "Retrying the resource action"
        retry
      else
        Chef::Log.info "Damn.. done with retries, re-raising..."
        raise e
      end
    else
      Chef::Log.info "Oops. my fault. I shouldn't have rescued, re-raising..."
      raise e
    end
  end

  def notify(action, notifying_resource)
    run_context.resource_collection.find(notifying_resource).run_action(action)
  end

  def self.included(base)
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

  def on_failure(*args, &block)
    #Chef::Log.info "On failure called with options: #{args.inspect} and a block: #{block.inspect}"
    options = {:retries => 1}
    exceptions = []
    args.each do |arg|
      exceptions << arg if arg.is_a?(Class)
      options.merge!(arg) if arg.is_a?(Hash)
    end
    self.instance_variable_set("@on_failure_struct".to_sym, OnFailure.new(options || {}, exceptions || [], block))
  end
end
