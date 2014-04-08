node.override['meal']['bacon_required'] = 1

meal 'breakfast' do
  on_failure(RuntimeError) { notify :eat, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
