# Watchr can be used to automatically run only necessary tests on file save.
# This script will detect changes in:
#   - all files in 'tests/' with extension 'php'
#   - all files in 'library/Saffron' with extension 'php'
#   - all files in 'application/' with extension 'php' (models, controllers, helpers)
#
# One limitation is lack of support for view tests (since mappings between
# corresponding view and test files are hard to describe in regex).
#
#
# To install, run:
#
#   $ gem install watchr
#   $ gem install notifier
#
# for windows also run $ gem install win32-open3, Install Snarl: download from www.fullphat.net, $ gem install ruby-snarl
#
# To run the script, do:
#
#   $ watchr tests/watchr.rb

require 'rubygems'
require 'notifier'

if RUBY_PLATFORM.include? 'w32'
  require 'win32/open3'
else
  require 'open3'
end

watch '^tests/.*Test\.php' do |match|
  phpcs(match[0]) && phpunit(match[0])
  say "waiting..."
end


watch '^library/My/(.*)\.php' do |match|
 phpcs("library/My/#{match[1]}.php") && phpunit("tests/library/#{match[1]}Test.php")
  say "waiting..."
end

watch '^application/(.*)\.php' do |match|
  phpcs("application/#{match[1]}.php") && phpunit("tests/application/#{match[1]}Test.php")
  say "waiting..."
end

watch '^application/configs/.*\.ini' do |match|
  phpunit "tests/application/ConfigTest.php"
  say "waiting..."
end

watch 'library/Zend/(.*)\.php' do |match|
  phpunit "tests/Zend/#{match[1]}Test.php"
  say "waiting..."
end

def say what
  puts "\n   [#{Time.now.strftime('%H:%M:%S')}] #{what}\n"
end

def phpcs file
  cmd = "phpcs --standard=tools/Standards/Saffron #{file}"
  say "About to run `#{cmd}`"
  success = system cmd
  unless success
    image, summary, message = 'dialog-error', 'CodeSniffer failed!', "In #{file}\nCheck your terminal for details"
    notify image, summary, message
  end

  success
end

def phpunit file
  if File.exists? file
    cmd = "phpunit -c tests/phpunit.xml -v --debug --stop-on-error #{file} 2>&1"
    say "About to run `#{cmd}`"
    _, out, _ = Open3.popen3(cmd)

    previous = last = nil

    until out.eof?
      previous = last
      puts last = out.gets
    end

    file_name = File.basename(file)
    image, summary, message = case
    when last =~ /\AOK/
      ['dialog-ok', file_name, last.gsub('OK (', '').gsub(')', '')]
    when previous =~ /\AOK, but incomplete or skipped tests/
      ['dialog-question', file_name, last]
    when last =~ /\APHP/
      ['dialog-error', 'Fatal error!', last.gsub(File.dirname(File.dirname(__FILE__)) + '/', '')]
    else
      ['dialog-warning', previous, last]
    end

    notify image, summary, message
  end
end


def notify image, summary, message
  Notifier.notify :image => image, :title => summary, :message => message
end
