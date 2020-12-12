#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: on_failure
# Library: on_failure
#
# Copyright (C) 2014 Kannan Manickam
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# update 12dec2020, bartvff: added continue: parameter to on_failure handler

module OnFailureDoThis
  def run_action_rescued(action = nil)
    run_action_unrescued(action)
    Chef::Log.debug "Finished running #{new_resource.resource_name}[#{new_resource.name}] -- so no exception"
  rescue Exception => e
    Chef::Log.info "#{new_resource.resource_name}[#{new_resource.name}] failed with: #{e.inspect}"
    if new_resource.instance_variable_defined?('@on_failure_handlers'.to_sym)
      new_resource.on_failure_handlers.each do |on_failure_struct|
        if !on_failure_struct.options[:continue] &&
          on_failure_struct.options[:retries] > 0 &&
          (on_failure_struct.exceptions.any? { |klass| e.is_a?(klass) } || on_failure_struct.exceptions.empty?)
          on_failure_struct.options[:retries] -= 1
          Chef::Log.debug "Executing the block"
          instance_exec(new_resource, &on_failure_struct.block)
          Chef::Log.debug "Retrying the resource action"
          run_action_rescued(action)
          return
        end
        if on_failure_struct.options[:continue] &&
          (on_failure_struct.exceptions.any? { |klass| e.is_a?(klass) } || on_failure_struct.exceptions.empty?)
          Chef::Log.debug "Executing the block, *not* retrying the resource action"
          instance_exec(new_resource, &on_failure_struct.block)
          return
        end
      end
    end
    Chef::Log.debug "No on_failure handlers defined or finished retrying."
    raise e
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

  unless Chef::Provider.ancestors.include?(OnFailureDoThis)
    Chef::Provider.send(:include, OnFailureDoThis)
  end
end

class Chef::Resource
  class OnFailure < Struct.new(:options, :exceptions, :block)
  end

  attr_accessor :on_failure_handlers

  def on_failure(*args, &block)
    options = {:retries => 1, :continue => false}
    exceptions = []
    args.each do |arg|
      exceptions << arg if arg.is_a?(Class)
      options.merge!(arg) if arg.is_a?(Hash)
    end
    @on_failure_handlers ||= []
    @on_failure_handlers << OnFailure.new(options || {}, exceptions || [], block)
  end
end