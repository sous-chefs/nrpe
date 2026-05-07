# Migrating to custom resources

This release removes the public recipe and node attribute APIs. Use the `nrpe` and
`nrpe_check` custom resources instead.

## Replacing recipes

Before:

```ruby
include_recipe 'nrpe::default'
```

After:

```ruby
nrpe 'default'
```

Before:

```ruby
include_recipe 'nrpe::configure'
```

After:

```ruby
nrpe 'default' do
  action :configure
end
```

## Replacing attributes

Before:

```ruby
node.default['nrpe']['server_port'] = 5666
node.default['nrpe']['allowed_hosts'] = %w(192.0.2.10)
include_recipe 'nrpe::default'
```

After:

```ruby
nrpe 'default' do
  server_port 5666
  allowed_hosts %w(192.0.2.10)
end
```

## Source installs

Before:

```ruby
node.default['nrpe']['install_method'] = 'source'
include_recipe 'nrpe::default'
```

After:

```ruby
nrpe 'source' do
  install_method 'source'
  nrpe_version '4.1.3'
  plugins_version '2.4.0'
end
```

## Test cookbook examples

Runnable examples live in:

* `test/cookbooks/test/recipes/default.rb`
* `test/cookbooks/test/recipes/check.rb`
* `test/cookbooks/test/recipes/source.rb`
