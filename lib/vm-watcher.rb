module Vm
  module Watcher
    require 'observer'
    require 'optparse'
    require 'vagrant'
    require 'vagrant/ui'

    class VmObserver
      def initialize(observable, script)
        observable.add_observer(self, :provision)

        @script = script

        @vagrant = Vagrant::Environment.new(:ui_class => Vagrant::UI::Basic)
        @vagrant.cli('up', '--no-provision')
        @vagrant.primary_vm.channel.ready?
      end

      def provision
        @vagrant.primary_vm.channel.execute(@script, false) do |type, data|
          @vagrant.primary_vm.ui.info(data.to_s, :prefix => false, :new_line => false, :channel => :out)
        end
      end
    end

    class VmWatcher
      include Observable

      def initialize(options = {})
        @last_mtime = @last_ctime = Time.now
        @watch = options[:watch]
        @sleep_interval = options[:interval]
      end

      def watch
        files = Dir.glob(@watch).map {|f| Pathname(f).expand_path }
        if files.empty?
          abort "No files to watch under #{@watch}"
        end

        loop do
          last_modified = files.max {|a, b| a.mtime <=> b.mtime}

          if last_modified.mtime > @last_mtime
            notify(last_modified)
          else
            last_changed = files.max {|a, b| a.ctime <=> b.ctime}
            notify(last_changed) if last_changed.ctime > @last_ctime
          end

          sleep @sleep_interval
        end
      end

      def notify(modified)
        @last_mtime, @last_ctime = modified.mtime, modified.ctime
        changed
        notify_observers
      end
    end

    def self.init(args)
      options = parse(args)

      watcher = VmWatcher.new(options)
      observer = VmObserver.new(watcher, options[:script])
      watcher.watch
    end

    def self.parse(args)
      options = {
        :script => 'script/provision',
        :watch => "#{Dir.pwd}/**/*",
        :interval => 1
      }

      OptionParser.new do |opts|
        opts.banner = "Usage: vm-watcher [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on('-s', '--script SCRIPT', 'Path to the script to call') do |script|
          options[:script] = script
        end

        opts.on('-w', '--watch PATTERN', 'Files pattern to watch') do |pattern|
          options[:watch] = pattern
        end

        opts.on('-i', '--interval SECONDS', 'Sleep time interval before checking modifications') do |interval|
          options[:interval] = interval.to_i
        end
      end.parse!(args)

      options
    end
  end
end
