#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: meal
# Provider:: default
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

action :eat do
  Chef::Log.debug "Going to eat breakfast. Currently ate: #{node['meal']['items'].inspect}"
  Chef::Log.debug "Meal attributes: #{node['meal'].inspect}"

  raise UncookedError, 'Meal is not cooked well' unless node['meal']['cooked']
  raise ColdError, 'Meal is cold' if node['meal']['cold']

  if node['meal']['bacon_required'] > 0 &&
    (node['meal']['items']['bacon'].nil? ||
    node['meal']['items']['bacon'] < node['meal']['bacon_required'])
    raise HungryError, "I want #{node['meal']['bacon_required']} bacon slices." +
      " But I only ate: #{node['meal']['items']['bacon'] || 0}"
  end
  Chef::Log.info "Meal '#{new_resource.name}' completed successfully."
  new_resource.updated_by_last_action(true)
end
