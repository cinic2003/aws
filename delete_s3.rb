require 'rubygems'
require 'aws/s3'
include AWS::S3
AWS::S3::Base.establish_connection!(
:access_key_id     => 'your_key_id',
:secret_access_key => 'your_access_key'
)

buckets = Service.buckets
buckets.each do |bucket|
  bucket.objects.each do |object|
    ob_time = Time.parse(object.about['last-modified']).yday
    n_time = Time.now.yday
    object.delete if (n_time - ob_time) > 20
  end
end
