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
