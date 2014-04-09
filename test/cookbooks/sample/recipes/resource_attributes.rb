#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: sample
# Recipe:: default
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

# At least 1 bacon slice is required to complete breakfast without getting hungry.
node.override['meal']['bacon_required'] = 1

# The handler block is just used to demonstrate that the resource attributes can be accessed.
meal 'breakfast' do
  time '2014-04-09 08:00:00 -0700'
  on_failure { |breakfast| Chef::Log.info "Tried eating breakfast at: #{breakfast.time}" }
end
