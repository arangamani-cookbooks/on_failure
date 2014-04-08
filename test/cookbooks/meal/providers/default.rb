action :eat do
  Chef::Log.info "Going to eat breakfast. Currently ate: #{node['meal'].inspect}"
  raise UncookedError, 'Meal is not cooked well' unless node['meal']['cooked']
  raise ColdError, 'Meal is cold' if node['meal']['cold']
  # TODO: Fix me up
  raise "#{node['meal']['bacon_required']} Bacan needed. Ate: #{node['meal']['items']['bacon'] || 0}" \
    unless (node['meal']['items']['bacon'] && node['meal']['items']['bacon'] >= node['meal']['bacon_required'])
  log "Meal '#{new_resource.name}' completed successfully. yummy!"
end
