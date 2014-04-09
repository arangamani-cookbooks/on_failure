#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: sample
# Recipe:: multiple_blocks
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

# Simulate that meal is not cooked so UncookedError is raised
node.set['meal']['cooked'] = false

# Simulate that meal is cold so ColdError is raised
node.set['meal']['cold'] = true

meal 'breakfast' do
  on_failure(UncookedError) { notify :fry, 'food[bacon]' }
  on_failure(ColdError) { notify :microwave, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
