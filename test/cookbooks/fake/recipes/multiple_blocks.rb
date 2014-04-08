# Simulate that meal is not cooked so UncookedError is raised
node.set['meal']['cooked'] = false
# Simulate that meal is cold so ColdError is raised
node.set['meal']['cold'] = true

meal 'breakfast' do
  on_failure(UncookedError) { notify :fry, 'food[bacon]' }
  on_failure(ColdError) { notify :microwave, 'food[bacon]' }
end

food 'bacon' do
  action :nothing
end
