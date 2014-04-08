action :eat do
  Chef::Log.debug "Going to eat breakfast. Currently ate: #{node['meal']['items'].inspect}"
  # TODO: delete this debug statements
  Chef::Log.debug "Meal attributes: #{node['meal'].inspect}"
  raise UncookedError, 'Meal is not cooked well' unless node['meal']['cooked']
  raise ColdError, 'Meal is cold' if node['meal']['cold']
  # TODO: Fix me up
  if node['meal']['bacon_required'] > 0 &&
    (node['meal']['items']['bacon'].nil? ||
    node['meal']['items']['bacon'] < node['meal']['bacon_required'])
    raise "#{node['meal']['bacon_required']} Bacan needed. Ate: #{node['meal']['items']['bacon'] || 0}"
  end
  Chef::Log.info "Meal '#{new_resource.name}' completed successfully."
  new_resource.updated_by_last_action(true)
end
