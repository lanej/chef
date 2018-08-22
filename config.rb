log_level                :debug
log_location             STDERR
cache_type               'BasicFile'
node_name                'admin'
client_key               File.expand_path('admin.pem', __dir__)
validation_client_name   'my_org-validator'
validation_key           File.expand_path('my_org-validator.pem', __dir__)
chef_server_url          'https://chef-server:444/organizations/my_org'

knife[:vault_mode] = 'client'
