# Cleversafe SOH

## Description
This is a Ruby interface into the Cleversafe's SOH API.

## Notes
* Multipart uploads are not supported by Cleversafe's API. Coming soon.
* If you upload a file with "X-Digest" you will get back a hash that includes :id and :x_content_digest. 

## Todo
* Support range requests for getting an object

## Usage

```ruby
# Connect to Cleversafe
connection = Cleversafe::Connection.new('http://127.0.0.1:1234')

# Open a vault
vault = connection.vault('pictures')

# Upload, download, delete
key = vault.create_object(open('~/cat.jpg'))

vault[key].exists?
vault[key].size
vault[key].open { |io| ... }
vault[key].delete

```
