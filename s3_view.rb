require 'rubygems'
require 'aws/s3'
include AWS::S3
AWS::S3::Base.establish_connection!(
:access_key_id     => 'your_key_id',
:secret_access_key => 'your_access_key'
)
buckets = Service.buckets
buckets.each do |object|
  puts "file size: #{object.size}" 
  object.map(&:url).each{|url| puts url}
end
