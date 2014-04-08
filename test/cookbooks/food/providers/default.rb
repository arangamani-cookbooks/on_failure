action :eat do
  if node['meal']['items'][new_resource.name]
    node.set['meal']['items'][new_resource.name] += 1
  else
    node.set['meal']['items'][new_resource.name] = 1
  end
  Chef::Log.info "Ate '#{new_resource.name}' successfully. yummy!"
end
