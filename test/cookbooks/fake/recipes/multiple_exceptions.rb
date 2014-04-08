node.set['meal']['cooked'] = false

meal 'breakfast' do
  on_failure(UncookedError, HungryError) { notify :fry, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
