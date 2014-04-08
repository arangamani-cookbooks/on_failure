# Simlate that the meal is not cooked so UncookedError is raised
node.set['meal']['cooked'] = false

meal 'breakfast' do
  on_failure(UncookedError, HungryError, retries: 3) { notify :fry, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
