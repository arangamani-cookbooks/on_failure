module MealExceptions
  class UncookedError < RuntimeError; end

  class ColdError < RuntimeError; end
end

::Chef::Provider.send(:include, MealExceptions)
::Chef::Recipe.send(:include, MealExceptions)
