# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
directories %w(app lib config test) \
 .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :minitest, spring: "bin/rails test", all_on_start: false do
  watch('app/models/application_record.rb')                         { 'test/models' }
  watch('app/controllers/application_controller.rb')                { 'test/controllers' }
  watch('app/mailers/application_mailer.rb')                        { 'test/mailers' }
  watch('app/helpers/application_helper.rb')                        { 'test/helpers' }
  watch('app/views/layouts/application.html.erb')                   { 'test/integration' }
  watch(%r{^app/models/(?<model>.+)\.rb$})                          { |m| "test/models/#{m[:model]}_test.rb" }
  watch(%r{^app/controllers/(?<controller>.+)_controller\.rb$})     { |m| "test/controllers/#{m[:controller]}_controller_test.rb" }
  watch(%r{^app/mailers/(?<mailer>.+)_mailer\.rb$})                 { |m| "test/mailers/#{m[:mailer]}_mailer_test.rb" }
  watch(%r{^app/helpers/(?<helper>.+)_helper\.rb$})                 { |m| "test/helpers/#{m[:helper]}_helper_test.rb" }
  watch(%r{^app/views/(?<resource>.+)/.*\.html\.erb$})              { |m| ["test/controllers/#{m[:resource]}_controller_test.rb", "test/integration/#{m[:resource]}_test.rb"] }

  watch(%r{^app/views/layouts/mailer\.(html|text)\.erb$})            { 'test/mailers' }
  watch(%r{^app/views/(?<resource>.+)_mailer/.+\.(html|text)\.erb$}) { |m| "test/mailers/#{m[:resource]}_mailer_test.rb" }

  watch('test/test_helper.rb')                                      { 'test' }
  watch('test/application_system_test_case.rb')                     { 'test/system' }
  watch(%r{^test/(?<dir>.+)/(?<test>.+)_test\.rb$})                 { |m| "test/#{m[:dir]}/#{m[:test]}_test.rb" } # Rerun every modified test

  watch('config/routes.rb')                                         { 'test/integration' } 
end

