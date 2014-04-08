node.override['meal']['bacon_required'] = 3

meal 'breakfast' do
  on_failure(RuntimeError, retries: 5) { notify :eat, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
