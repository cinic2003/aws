require 'rubygems'
require 'aws/s3'
include AWS::S3

current_day = Time.now.strftime('%Y%m%d')

dump = %x[ which mysqldump ].strip
databases = [{"user"=>"username", "data"=>"database", "pwd"=>"password"}, 
             {"user"=>"username", "data"=>"database", "pwd"=>"password"}
            ]

puts 'backup database.....'
databases.each do |database|
  backup_path = "/home/app/allbackup/#{database['data']}_#{current_day}"
  options =  "-u #{database['user']} -p#{database['pwd']}"
  %x[ #{dump} #{options} #{database['data']} > #{backup_path}.sql ]
end

tar = %x[ which tar ].strip
puts 'tar the sql file ...'
%x[ #{tar} -czvf /home/app/allbackup/jove_kb_tk_#{current_day}.tar.gz /home/app/allbackup/*_#{current_day}.sql]

AWS::S3::Base.establish_connection!(
  :access_key_id     => 'your_key_id',
  :secret_access_key => 'your_access_key'
)

class JoveDataBucket < AWS::S3::S3Object
  set_current_bucket_to 'jove_data'
end

file_name = "jove_kb_tk_#{current_day}"
file = "/home/app/allbackup/jove_kb_tk_#{current_day}.tar.gz"
puts 'backup data file to s3...'
JoveDataBucket.store(file_name, open(file))


rm = %x[ which rm ].strip
if S3Object.exists? file_name, 'jove_data'
  puts 'delete the file localed ...'
  %x[ #{rm} -rf #{file} ]
  %x[ #{rm} -rf /home/app/allbackup/*.sql ]
end
