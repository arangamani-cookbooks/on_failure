#
# Author:: Kannan Manickam <me@arangamani.net>
# Cookbook Name:: sample
# Recipe:: multiple_exceptions
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

# Simlate that the meal is not cooked so UncookedError is raised
node.set['meal']['cooked'] = false

meal 'breakfast' do
  on_failure(UncookedError, HungryError, retries: 3) { notify :fry, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
