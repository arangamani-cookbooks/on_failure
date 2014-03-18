execute 'simple execute resource' do
  command 'exit 1'
  on_failure(:retries => 3) { |the_resource| Chef::Log.info "The failed command: #{the_resource.command}"}
  #on_failure(:retries => 3) { notify :run, 'execute[notified_resource]' }
  #on_failure do
  #  execute 'inline_resource' do
  #    command 'echo look who is this'
  #  end.run_action(:run)
  #end
  action :run
end

execute 'notified_resource' do
  command 'echo I am notified'
  action :nothing
end
