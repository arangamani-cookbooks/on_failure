#execute 'simple execute resource' do
  #command 'exit 1'
  #on_failure(:retries => 3) { |the_resource| Chef::Log.info "The failed command: #{the_resource.command}"}
  #on_failure(:retries => 3) { notify :run, 'execute[notified_resource]' }
  #on_failure do
  #  execute 'inline_resource' do
  #    command 'echo look who is this'
  #  end.run_action(:run)
  #end
  #action :run
#end

filesystem 'test' do
  action :freeze
  on_failure(ArgumentError) { notify :write, 'log[notified_resource]' }
end

log 'notified_resource' do
  message 'See... I am notified because of your damn mistake'
  level :info
  action :nothing
end
