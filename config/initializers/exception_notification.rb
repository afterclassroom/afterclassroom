Afterclassroom::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ERROR: Afterclassroom] ",
  :sender_address => '"Notifier" <notifier@afterclassroom.com>',
  :exception_recipients => ['dungtqa@gmail.com']