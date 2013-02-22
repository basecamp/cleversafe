# Cleversafe SOH

## Description
This is a Ruby interface into the Cleversafe's SOH API.

## Notes
* Multipart uploads are not supported by Cleversafe's API. Coming soon.
* If you upload a file with "X-Digest" you will get back a hash that includes :id and :x_content_digest. 

## Todo
* Support range requests for getting an object

## Examples

```ruby
#Setup Conection
request = Cleversafe::Connection.new("USERNAME", "PASSWORD", "HOSTNAME")

#Does a vault exist?
request.vault_exists?("VAULTNAME")

# load vault
vault = request.vault("VAULTNAME")

# bytes used in vault
vault.bytes_used

# list objects in vault
vault.objects(:limit => 10, :start_id => "1f1665dce23b515cedf29edaf1d033730000")

# load object
object = "1f1665dce23b515cedf29edaf1d033730000"

# get etag of object
vault.object(object).etag

# download object
File.open("downloaded.file", 'w') {|f| f.write(vault.object(object).data) }

# upload object, don't use multipart, it is not supported
upload_object = vault.create_object
uploaded_object = upload_object.write File.new("upload.file", "r"), :multipart => false, 'X-Digest' => "md5" 

# uploaded object's digest
uploaded_object[:id]

# object's digest
uploaded_object[:x_content_digest]

# uploaded object exists?
vault.object_exists?(uploaded_object[:id])

# deleting the uploaded object
vault.delete_object(uploaded_object[:id])

```

