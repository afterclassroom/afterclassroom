##
# Backup
# Generated Template
#
# For more information:
#
# View the Git repository at https://github.com/meskyanichi/backup
# View the Wiki/Documentation at https://github.com/meskyanichi/backup/wiki
# View the issue log at https://github.com/meskyanichi/backup/issues
#
# When you're finished configuring this configuration file,
# you can run it from the command line by issuing the following command:
#
# $ backup -t my_backup [-c <path_to_configuration_file>]

Backup::Model.new(:after_backup, 'After Backup') do

  database MySQL do |db|
    db.name               = "afterclassroom"
    db.username           = "root"
    #db.password           = "Ia9auNb6u*"
    db.password           = ""
    db.host               = "localhost"
    db.port               = 3306
    db.socket             = "/var/run/mysqld/mysqld.sock"
    db.additional_options = ['--quick', '--single-transaction']
  end

  store_with S3 do |s3|
    s3.access_key_id      = 'AKIAJ3B6N3Y22A2R2LZQ'
    s3.secret_access_key  = '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'
    s3.region             = 'us-east-1'
    s3.bucket             = 'backup_sql'
    s3.path               = '/afterclassroom_backup'
    s3.keep               = 10
  end

  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

end

