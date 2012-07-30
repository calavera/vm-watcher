# Vm::Watcher

Continuous VM provisioning.

## Installation

Or install it yourself as:

    $ gem install vm-watcher

## Usage

1. Set up a VM using Vagrant.
2. Write your `script/provision` script, for instance to use chef-solo:

    chef-solo -j dna.json -c solo.rb

3. Run `vm-watcher` from the terminal. It executes the provisioning script
   inside the VM every time one of the files change.

There a several options that you can modify:

```
  --watch:  pattern that matches the files to watch, `Dir.pwd/**/*` by default.
  --script:   script to execute when one of those files change, `script/provision` by default.
  --interval: sleep time before each check, 1 sec by default.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
