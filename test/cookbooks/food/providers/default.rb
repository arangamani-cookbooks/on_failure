#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: food
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
  if node['meal']['items'][new_resource.name]
    node.set['meal']['items'][new_resource.name] += 1
  else
    node.set['meal']['items'][new_resource.name] = 1
  end
  Chef::Log.info "Ate '#{new_resource.name}' successfully. yummy!"
  new_resource.updated_by_last_action(true)
end

action :fry do
  if node['meal']['cooked'] == true
    Chef::Log.info "Meal '#{new_resource.name}' is already cooked"
  else
    node.set['meal']['cooked'] = true
    Chef::Log.info "Meal '#{new_resource.name}' is cooked"
    new_resource.updated_by_last_action(true)
  end
end

action :microwave do
  if node['meal']['cold'] == true
    node.set['meal']['cold'] = false
    Chef::Log.info "Meal '#{new_resource.name}' is now hot!"
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "Meal '#{new_resource.name}' is already hot"
  end
end
