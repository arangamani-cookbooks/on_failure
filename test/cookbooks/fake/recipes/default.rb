meal 'breakfast' do
  on_failure { notify :eat, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
